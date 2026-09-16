from __future__ import annotations

from collections import defaultdict
from time import time

from fastapi import HTTPException, Request, status

_hits: dict[str, list[float]] = defaultdict(list)


def rate_limit(request: Request, max_hits: int, window_seconds: int) -> None:
    ip = request.client.host if request.client else "unknown"
    key = f"{ip}:{request.url.path}"
    now = time()
    bucket = [stamp for stamp in _hits[key] if now - stamp < window_seconds]
    if len(bucket) >= max_hits:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Too many attempts. Please wait and try again.",
        )
    bucket.append(now)
    _hits[key] = bucket
