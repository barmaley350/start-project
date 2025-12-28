"""Docstring для services.backend.apps.jupyter.urls."""

from django.urls import path

from apps.jupyter.views import ProtectedJupyterView

urlpatterns = [
    path("", ProtectedJupyterView.as_view(), name="protected-jupyter"),
]
