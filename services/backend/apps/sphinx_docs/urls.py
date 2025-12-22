"""Docstring for services.backend.apps.sphinx_docs.urls."""

from django.urls import path

from apps.sphinx_docs.views import ProtectedSphinxView

urlpatterns = [
    path("<path:path>", ProtectedSphinxView.as_view(), name="sphinx_docs"),
    path("", ProtectedSphinxView.as_view(), name="sphinx_docs_root"),
]
