"""Shared errors for the content-generation pipeline."""


class NotConfiguredError(RuntimeError):
    """Raised when a licensed provider is selected but credentials are missing."""


class PrivacyViolationError(ValueError):
    """Raised when a request contains child PII that must never leave the device."""


class GenerationRejectedError(RuntimeError):
    """Raised when a draft fails validation and cannot be approved."""
