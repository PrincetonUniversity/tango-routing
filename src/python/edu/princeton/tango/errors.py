"""All errors pertaining to Tango classes."""


class BaseTangoException(Exception):
    """Base exception for all Tango errors."""


class InvalidParameterError(BaseTangoException):
    """A paramter is does not pass validation."""
