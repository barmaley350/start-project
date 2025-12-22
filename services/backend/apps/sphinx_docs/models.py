"""Docstring for services.backend.apps.sphinx_docs.models."""

from typing import ClassVar

from django.db import models


class DocPermission(models.Model):
    """Docstring for DocPermission."""

    class Meta:
        """Docstring for Meta."""

        permissions: ClassVar[dict] = [
            ("view_sphinx", "Может просматривать документацию Sphinx"),
        ]

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return "DocPermission"
