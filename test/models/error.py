"""Errors for test models."""


class TangoTestingBaseError(Exception):
    """Base exception for all Tango testing."""


class ModelError(TangoTestingBaseError):
    """Error in model definition."""


class UsageError(TangoTestingBaseError):
    """Error in user usage of test framework."""


class TestCompileError(TangoTestingBaseError):
    """Test compilation of lucid code failed."""
