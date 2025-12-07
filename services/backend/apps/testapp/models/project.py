"""Docstring for services.backend.apps.testapp.models.project."""

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
    owner = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        verbose_name="Кто создал",
        related_name="projects",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Дата создания")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Дата редактирования")

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
