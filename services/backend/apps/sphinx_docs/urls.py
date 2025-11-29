"""Docstring for services.backend.apps.sphinx_docs.urls."""

from django.urls import path

from apps.sphinx_docs.views import sphinx_docs

urlpatterns = [
    path("", sphinx_docs),
    path("<path:path>", sphinx_docs),
]
