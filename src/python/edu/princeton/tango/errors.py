"""All errors pertaining to Tango classes."""


class TangoBaseException(Exception):
    """Base exception for all Tango errors."""


class InvalidParameterError(TangoBaseException):
    """A paramter is does not pass validation."""
