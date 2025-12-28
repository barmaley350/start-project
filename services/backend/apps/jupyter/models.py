"""Docstring для services.backend.apps.jupyter.models."""

from typing import ClassVar

from django.db import models


class JupyterPermission(models.Model):
    """Docstring для JupyterPermission."""

    class Meta:
        """Docstring для Meta."""

        permissions: ClassVar[dict] = [
            ("view_jupyter", "Может просматривать jupyter"),
        ]

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return "JupyterPermission"
