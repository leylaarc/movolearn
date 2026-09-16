from __future__ import annotations

from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from ..config import get_settings
from ..db import get_db
from ..models import AuditEvent, ChildRecord, Parent
from ..schemas import ChildSnapshot, FamilySnapshot, ParentOut, SyncPayload
from ..security import json_size_ok, utcnow
from .auth import current_parent

router = APIRouter(prefix="/v1", tags=["family"])


def _snapshot(record: ChildRecord) -> ChildSnapshot:
    return ChildSnapshot(
        child_id=record.id,
        profile=record.profile_json or {},
        completions=record.completions_json or [],
        learning_state=record.learning_state_json,
        game_progress=record.game_progress_json,
        home_activity=record.home_activity_json,
        updated_at=record.updated_at,
    )


def _merge_completions(existing: list, incoming: list) -> list:
    merged: dict[str, dict] = {}
    for item in existing + incoming:
        if not isinstance(item, dict):
            continue
        key = str(item.get("id") or uuid4())
        merged[key] = item
    records = list(merged.values())
    records.sort(key=lambda item: str(item.get("completedAt") or item.get("completed_at") or ""))
    return records[-400:]


def _owned_child(db: Session, parent: Parent, child_id: str) -> ChildRecord:
    record = db.get(ChildRecord, child_id)
    if record is None or record.parent_id != parent.id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Child profile not found.")
    return record


@router.get("/me", response_model=FamilySnapshot)
def family_snapshot(parent: Parent = Depends(current_parent)) -> FamilySnapshot:
    return FamilySnapshot(
        parent=ParentOut.model_validate(parent),
        children=[_snapshot(child) for child in parent.children],
    )


@router.put("/children/{child_id}", response_model=ChildSnapshot)
def upsert_child(
    child_id: str,
    body: SyncPayload,
    db: Session = Depends(get_db),
    parent: Parent = Depends(current_parent),
) -> ChildSnapshot:
    settings = get_settings()
    if str(body.child_id) != child_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Child id mismatch.")
    payload = body.model_dump(mode="json")
    if not json_size_ok(payload, settings.max_json_bytes):
        raise HTTPException(status_code=413, detail="Profile is too large.")
    if not isinstance(body.profile, dict) or not body.profile:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A child profile is required.")

    record = db.get(ChildRecord, child_id)
    if record and record.parent_id != parent.id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Child profile not found.")
    now = utcnow()
    if record is None:
        record = ChildRecord(
            id=child_id,
            parent_id=parent.id,
            profile_json=body.profile,
            completions_json=_merge_completions([], body.completions),
            learning_state_json=body.learning_state,
            game_progress_json=body.game_progress,
            home_activity_json=body.home_activity,
            created_at=now,
            updated_at=now,
        )
        db.add(record)
    else:
        record.profile_json = body.profile
        record.completions_json = _merge_completions(record.completions_json or [], body.completions)
        if body.learning_state is not None:
            record.learning_state_json = body.learning_state
        if body.game_progress is not None:
            record.game_progress_json = body.game_progress
        if body.home_activity is not None:
            record.home_activity_json = body.home_activity
        record.updated_at = now
    db.add(
        AuditEvent(
            id=str(uuid4()),
            parent_id=parent.id,
            event_type="child_synced",
            detail="child_record_updated",
            created_at=now,
        )
    )
    db.commit()
    db.refresh(record)
    return _snapshot(record)


@router.delete("/children/{child_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_child(
    child_id: str,
    db: Session = Depends(get_db),
    parent: Parent = Depends(current_parent),
) -> None:
    record = _owned_child(db, parent, child_id)
    db.delete(record)
    db.add(
        AuditEvent(
            id=str(uuid4()),
            parent_id=parent.id,
            event_type="child_deleted",
            detail="child_record_removed",
            created_at=utcnow(),
        )
    )
    db.commit()


@router.delete("/account", status_code=status.HTTP_204_NO_CONTENT)
def delete_account(
    db: Session = Depends(get_db),
    parent: Parent = Depends(current_parent),
) -> None:
    parent_id = parent.id
    db.delete(parent)
    db.add(
        AuditEvent(
            id=str(uuid4()),
            parent_id=parent_id,
            event_type="account_deleted",
            detail="parent_and_children_removed",
            created_at=utcnow(),
        )
    )
    db.commit()
