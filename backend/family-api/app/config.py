from __future__ import annotations

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="FAMILY_API_",
        env_file=".env",
        extra="ignore",
    )

    env: str = "development"
    secret_key: str = "dev-only-change-me"
    database_url: str = "sqlite:///./data/family.db"
    access_token_minutes: int = 15
    refresh_token_days: int = 30
    cors_origins: str = ""
    max_json_bytes: int = 400_000

    @property
    def is_production(self) -> bool:
        return self.env.lower() in {"production", "prod"}

    @property
    def cors_origin_list(self) -> list[str]:
        return [item.strip() for item in self.cors_origins.split(",") if item.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
