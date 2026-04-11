"""Docstring для services.drf.apps.auth_check.models."""

from typing import ClassVar

from django.db import models


class JupyterPermission(models.Model):
    """Docstring для JupyterPermission."""

    class Meta:
        """Docstring для Meta."""

        permissions: ClassVar[list[tuple[str, str]]] = [
            ("view_jupyter", "Может просматривать jupyter"),
        ]

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return "JupyterPermission"


class SphinxDocsPermission(models.Model):
    """Docstring for SphinxDocsPermission."""

    class Meta:
        """Docstring for Meta."""

        permissions: ClassVar[list[tuple[str, str]]] = [
            ("view_sphinx", "Может просматривать документацию Sphinx"),
        ]

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return "SphinxDocsPermission"


class AdminerPermission(models.Model):
    """Docstring для AdminerPermission."""

    class Meta:
        """Docstring для Meta."""

        permissions: ClassVar[list[tuple[str, str]]] = [
            ("view_adminer", "Может просматривать adminer"),
        ]

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return "AdminerPermission"
