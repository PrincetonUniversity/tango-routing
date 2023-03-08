"""Errors for test models."""


class TangoTestingBaseException(Exception):
    """Base exception for all Tango testing."""


class ModelError(TangoTestingBaseException):
    """Error in model definition."""


class UsageError(TangoTestingBaseException):
    """Error in user usage of test framework."""


class TestCompileError(TangoTestingBaseException):
    """Test compilation of lucid code failed."""
