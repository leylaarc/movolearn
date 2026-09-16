from __future__ import annotations

from datetime import datetime, timezone
from typing import Any, Dict, List, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_serializer


def _utc_z(value: datetime) -> str:
    if value.tzinfo is None:
        value = value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=10, max_length=128)
    parental_consent: bool


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)


class RefreshRequest(BaseModel):
    refresh_token: str = Field(min_length=20, max_length=200)


class ParentOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    email: str
    created_at: datetime

    @field_serializer("created_at")
    def serialize_created_at(self, value: datetime) -> str:
        return _utc_z(value)


class AuthResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
    parent: ParentOut


class SyncPayload(BaseModel):
    child_id: UUID
    profile: Dict[str, Any]
    completions: List[Dict[str, Any]] = Field(default_factory=list)
    learning_state: Optional[Dict[str, Any]] = None
    game_progress: Optional[Dict[str, Any]] = None
    home_activity: Optional[Dict[str, Any]] = None


class ChildSnapshot(BaseModel):
    child_id: str
    profile: Dict[str, Any]
    completions: List[Dict[str, Any]]
    learning_state: Optional[Dict[str, Any]]
    game_progress: Optional[Dict[str, Any]]
    home_activity: Optional[Dict[str, Any]]
    updated_at: datetime

    @field_serializer("updated_at")
    def serialize_updated_at(self, value: datetime) -> str:
        return _utc_z(value)


class FamilySnapshot(BaseModel):
    parent: ParentOut
    children: List[ChildSnapshot]
