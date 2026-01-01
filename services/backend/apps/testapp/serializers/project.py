"""Docstring для services.backend.apps.testapp.serializers.project."""

from rest_framework import serializers

from apps.testapp.models import Project

from .comment import CommentSerializer
from .user import UserSerializer


class ProjectSerializer(serializers.ModelSerializer):
    """Docstring for ProjectSerializer."""

    comments = CommentSerializer(many=True, read_only=True)
    comments_count = serializers.IntegerField(read_only=True)
    owner = UserSerializer(read_only=True)

    class Meta:
        """Docstring for Meta."""

        model = Project
        fields = [  # noqa: RUF012
            "id",
            "title",
            "description",
            "owner",
            "comments_count",
            "comments",
        ]
