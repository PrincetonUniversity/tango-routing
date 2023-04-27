"""All errors pertaining to Tango classes."""


class TangoBaseError(Exception):
    """Base exception for all Tango errors."""


class InvalidParameterError(TangoBaseError):
    """A paramter is does not pass validation."""
