"""Docstring для services.backend.apps.testapp.serializers.user."""

from django.contrib.auth.models import User
from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    """Docstring для UserSerializer."""

    class Meta:
        """Docstring для Meta."""

        model = User
        fields = ["id", "username", "email", "first_name", "last_name"]  # noqa: RUF012
