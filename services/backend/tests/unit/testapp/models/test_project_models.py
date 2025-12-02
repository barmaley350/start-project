"""Docstring for test_model.py."""

import pytest
from django.contrib.auth.models import User
from django.urls import reverse
from faker import Faker
from rest_framework import status
from rest_framework.test import APIClient

from apps.testapp.models import Project


@pytest.mark.django_db
class TestProjectAPI:
    """Docstring for TestProjectAPI."""

    def test_create_project(
        self,
        api_client: APIClient,
        user: User,
        faker: Faker,
    ) -> None:
        """Docstring for test_create_project.

        :param self: Description
        :param api_client: Description
        :type api_client: APIClient
        :param user: Description
        :type user: User
        """
        api_client.force_authenticate(user=user)
        url = reverse("project-list")
        title = faker.text(100)
        description = faker.text()
        data = {
            "title": title,
            "description": description,
            "owner": user.id,
        }
        response = api_client.post(url, data, format="json")

        assert response.status_code == status.HTTP_201_CREATED
        assert response.data["title"] == title
        assert response.data["description"] == description
        assert Project.objects.count() == 1
