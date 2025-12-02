"""Docstring for services.backend.tests.testapp.conftest."""

import pytest
from django.contrib.auth.models import User
from faker import Faker
from rest_framework.test import APIClient

from apps.testapp.models import Project


@pytest.fixture
def faker() -> Faker:
    """Docstring for faker.

    :return: Description
    :rtype: Faker
    """
    return Faker(locale="ru_RU")


@pytest.fixture
def api_client() -> APIClient:
    """Docstring for api_client.

    :return: Description
    :rtype: APIClient
    """
    return APIClient()


@pytest.fixture
def admin_user(db) -> User:  # noqa: ANN001, ARG001
    """Docstring for user.

    :return: Description
    :rtype: User
    """
    return User.objects.create_superuser(
        username="testuser",
        password="testpass",  # noqa: S106
        email="test@test",
    )


@pytest.fixture
def user(db) -> User:  # noqa: ANN001, ARG001
    """Docstring for user.

    :return: Description
    :rtype: User
    """
    return User.objects.create_user(username="testuser", password="testpass")  # noqa: S106


@pytest.fixture
def sample_project(db) -> Project:  # noqa: ANN001, ARG001
    """Docstring for sample_article.

    :return: Description
    :rtype: Project
    """
    return Project.objects.create(
        title="Test Article",
        description="This is a test content with 7 words.",
        owner=admin_user,
    )
