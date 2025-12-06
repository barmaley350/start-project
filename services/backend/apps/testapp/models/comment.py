"""Docstring for services.backend.apps.testapp.models.comment."""

from django.contrib.auth.models import User
from django.db import models


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
