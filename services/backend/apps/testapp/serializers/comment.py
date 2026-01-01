"""Docstring для services.backend.apps.testapp.serializers.comment."""

from rest_framework import serializers

from apps.testapp.models import Comment

from .user import UserSerializer


class CommentSerializer(serializers.ModelSerializer):
    """Docstring для CommentSerializer."""

    owner = UserSerializer(read_only=True)

    class Meta:
        """Docstring для Meta."""

        model = Comment
        fields = [  # noqa: RUF012
            "id",
            "parent_id",
            "title",
            "description",
            "project",
            "owner",
            "created_at",
            "updated_at",
        ]
