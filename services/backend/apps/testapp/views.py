"""Docstring for services.backend.apps.testapp.views."""

from django.db.models import Count, Prefetch
from rest_framework import generics

from apps.testapp.models import Comment, Project

from .serializers import ProjectSerializer


class ProjectList(generics.ListCreateAPIView):
    """Docstring for ProjectList."""

    # queryset = Project.objects.prefetch_related("comments").all()  # noqa: ERA001
    # queryset = Project.objects.annotate(comments_count=Count("comments")).all()  # noqa: E501, ERA001
    queryset = (
        Project.objects.select_related("owner")
        .prefetch_related(
            Prefetch("comments", queryset=Comment.objects.select_related("owner"))
        )
        .annotate(comments_count=Count("comments"))
    )
    serializer_class = ProjectSerializer
