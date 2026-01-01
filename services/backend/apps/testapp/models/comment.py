"""Docstring for services.backend.apps.testapp.models.comment."""

from django.contrib.auth.models import User
from django.db import models


class Comment(models.Model):
    """Docstring for Project."""

    parent_id = models.IntegerField(default=0)
    title = models.CharField(
        max_length=250, null=False, blank=False, verbose_name="Заголовок"
    )
    description = models.TextField()
    project = models.ForeignKey(
        "Project",
        on_delete=models.CASCADE,
        verbose_name="Проект",
        related_name="comments",
    )
    owner = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        verbose_name="Кто создал",
        related_name="authored_comments",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Дата создания")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Дата редактирования")

    class Meta:
        """Docstring for Meta."""

        verbose_name = "Коментарий"
        verbose_name_plural = "Коментарии"

    def __str__(self) -> str:
        """Docstring for __str__.

        :param self: Description
        :return: Description
        :rtype: str
        """
        return self.title
