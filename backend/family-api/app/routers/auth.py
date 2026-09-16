from __future__ import annotations

from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..config import get_settings
from ..db import get_db
from ..models import AuditEvent, Parent, RefreshToken
from ..rate_limit import rate_limit
from ..schemas import AuthResponse, LoginRequest, ParentOut, RefreshRequest, RegisterRequest
from ..security import (
    create_access_token,
    decode_access_token,
    hash_password,
    hash_refresh_token,
    is_valid_email,
    new_refresh_token,
    normalize_email,
    refresh_expiry,
    utcnow,
    validate_password,
    verify_password,
)

router = APIRouter(prefix="/v1/auth", tags=["auth"])


def _issue_session(db: Session, parent: Parent) -> AuthResponse:
    settings = get_settings()
    refresh = new_refresh_token()
    db.add(
        RefreshToken(
            id=str(uuid4()),
            parent_id=parent.id,
            token_hash=hash_refresh_token(refresh),
            expires_at=refresh_expiry(),
            revoked_at=None,
            created_at=utcnow(),
        )
    )
    parent.last_login_at = utcnow()
    db.commit()
    return AuthResponse(
        access_token=create_access_token(parent.id),
        refresh_token=refresh,
        expires_in=settings.access_token_minutes * 60,
        parent=ParentOut.model_validate(parent),
    )


def _audit(db: Session, parent_id: str | None, event_type: str, detail: str = "") -> None:
    db.add(
        AuditEvent(
            id=str(uuid4()),
            parent_id=parent_id,
            event_type=event_type,
            detail=detail,
            created_at=utcnow(),
        )
    )


@router.post("/register", response_model=AuthResponse)
def register(request: Request, body: RegisterRequest, db: Session = Depends(get_db)) -> AuthResponse:
    rate_limit(request, max_hits=8, window_seconds=60)
    if not body.parental_consent:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A parent or guardian must consent before we store a child's learning profile.",
        )
    email = normalize_email(str(body.email))
    if not is_valid_email(email):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Enter a valid email.")
    password_error = validate_password(body.password)
    if password_error:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=password_error)
    existing = db.scalar(select(Parent).where(Parent.email == email))
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with that email already exists.",
        )
    parent = Parent(
        id=str(uuid4()),
        email=email,
        password_hash=hash_password(body.password),
        parental_consent_at=utcnow(),
        created_at=utcnow(),
        last_login_at=utcnow(),
    )
    db.add(parent)
    _audit(db, parent.id, "parent_registered")
    db.flush()
    return _issue_session(db, parent)


@router.post("/login", response_model=AuthResponse)
def login(request: Request, body: LoginRequest, db: Session = Depends(get_db)) -> AuthResponse:
    rate_limit(request, max_hits=10, window_seconds=60)
    email = normalize_email(str(body.email))
    parent = db.scalar(select(Parent).where(Parent.email == email))
    if parent is None or not verify_password(body.password, parent.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password.",
        )
    _audit(db, parent.id, "parent_login")
    return _issue_session(db, parent)


@router.post("/refresh", response_model=AuthResponse)
def refresh(request: Request, body: RefreshRequest, db: Session = Depends(get_db)) -> AuthResponse:
    rate_limit(request, max_hits=20, window_seconds=60)
    token_hash = hash_refresh_token(body.refresh_token)
    record = db.scalar(select(RefreshToken).where(RefreshToken.token_hash == token_hash))
    now = utcnow()
    expires_at = record.expires_at if record else None
    if expires_at is not None and expires_at.tzinfo is None:
        from datetime import timezone

        expires_at = expires_at.replace(tzinfo=timezone.utc)
    if record is None or record.revoked_at is not None or expires_at is None or expires_at <= now:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session expired.")
    parent = db.get(Parent, record.parent_id)
    if parent is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session expired.")
    record.revoked_at = now
    _audit(db, parent.id, "token_rotated")
    return _issue_session(db, parent)


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
def logout(body: RefreshRequest, db: Session = Depends(get_db)) -> None:
    token_hash = hash_refresh_token(body.refresh_token)
    record = db.scalar(select(RefreshToken).where(RefreshToken.token_hash == token_hash))
    if record and record.revoked_at is None:
        record.revoked_at = utcnow()
        _audit(db, record.parent_id, "parent_logout")
        db.commit()


def current_parent(request: Request, db: Session = Depends(get_db)) -> Parent:
    header = request.headers.get("Authorization", "")
    scheme, _, token = header.partition(" ")
    if scheme.lower() != "bearer" or not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sign in required.")
    parent_id = decode_access_token(token)
    if not parent_id:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sign in required.")
    parent = db.get(Parent, parent_id)
    if parent is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sign in required.")
    return parent
