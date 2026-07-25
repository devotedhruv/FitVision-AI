"""Guard integration tests from ever selecting an unsafe database."""

import os
from urllib.parse import urlparse

import pytest


def isolated_test_database_url() -> str:
    test_url = os.getenv("TEST_DATABASE_URL")
    runtime_url = os.getenv("DATABASE_URL")
    if not test_url:
        pytest.skip("TEST_DATABASE_URL is not configured")
    if test_url == runtime_url:
        pytest.fail("TEST_DATABASE_URL must not equal DATABASE_URL")
    database_name = urlparse(test_url.replace("+asyncpg", "")).path.lower()
    if "test" not in database_name:
        pytest.fail("TEST_DATABASE_URL database name must clearly contain 'test'")
    return test_url


@pytest.mark.integration
def test_database_target_is_explicitly_isolated():
    assert "test" in isolated_test_database_url().lower()
