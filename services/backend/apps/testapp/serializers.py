"""Docstring for services.backend.apps.testapp.serializers."""

from rest_framework import serializers

from apps.testapp.models import Project


class ProjectSerializer(serializers.ModelSerializer):
    """Docstring for ProjectSerializer."""

    class Meta:
        """Docstring for Meta."""

        model = Project
        fields = ["title", "description"]  # noqa: RUF012
