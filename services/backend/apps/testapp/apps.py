"""Docstring for services.backend.apps.testapp.apps."""

from django.apps import AppConfig


class TestappConfig(AppConfig):
    """Docstring for TestappConfig.

    :var default_auto_field: Description
    :vartype default_auto_field: Literal['django.db.models.BigAutoField']
    :var name: Description
    :vartype name: Literal['testapp']
    """

    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.testapp"
    verbose_name = "Приложение testapp"
