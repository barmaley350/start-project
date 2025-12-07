"""Docstring for services.backend.apps.testapp.management.commands.sample."""

import random

from django.core.management.base import BaseCommand

from apps.testapp.factories import CommentFactory, ProjectFactory
from apps.testapp.models import Project


class Command(BaseCommand):
    """Docstring for Command."""

    help = "Заполнение моделей приложения apps/testapp фейковыми данными"

    def add_arguments(self, parser) -> None:  # noqa: ANN001
        """Docstring for add_arguments.

        :param self: Description
        :param parser: Description
        """
        parser.add_argument(
            "--clear",
            action="store_true",
            help="Очисть все данные перед заполнением (default=False)",
        )

        parser.add_argument(
            "--count",
            type=int,
            default=100,
            help="Количество записей для создания (default=100)",
        )

    def filling_project_model(self, *args, **options) -> int | None:  # noqa: ANN002, ANN003, ARG002
        """Docstring for filling_project_model.

        :param self: Description
        """
        count = options["count"]
        if options["clear"]:
            Project.objects.all().delete()

        projects = ProjectFactory.create_batch(count)
        for project in projects:
            CommentFactory.create_batch(random.randint(5, 20), project=project)  # noqa: S311
        return Project.objects.count()

    def handle(self, *args, **options) -> None:  # noqa: ANN002, ANN003
        """Docstring for handle.

        :param self: Description
        :param args: Description
        :param options: Description
        """
        count = self.filling_project_model(*args, **options)
        self.stdout.write(
            self.style.SUCCESS("Создание записей в моделе Project завершено")
        )
        self.stdout.write(
            self.style.SUCCESS(f"Кол-во записей в моделе Project = {count}")
        )
