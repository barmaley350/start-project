"""Docstring for services.backend.apps.testapp.models."""

from django.contrib.auth.models import User
from django.db import models


class Project(models.Model):
    """Docstring for Project."""

    title = models.CharField(
        max_length=250,
        null=False,
        blank=False,
        verbose_name="Заголовок",
    )
    description = models.TextField(verbose_name="Описание проекта")
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    class Meta:
        """Docstring for Meta."""

        verbose_name = "Проект"
        verbose_name_plural = "Проекты"

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return self.title


class Comments(models.Model):
    """Docstring for Project."""

    title = models.CharField(max_length=250, null=False, blank=False)
    description = models.TextField()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return self.title
