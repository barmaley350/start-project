"""Docstring для testapp_fill_all_models."""

import random
import time
from typing import Any

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand, CommandParser
from django.db import transaction

from apps.testapp.factories import (
    CommentFactory,
    ProjectFactory,
    TagFactory,
    UserFactory,
)
from apps.testapp.models import Comment, Project, Tag


class Command(BaseCommand):
    """Пользовательская команда для удаления/заполнения моделей данными."""

    help = "Заполнение моделей приложения apps/testapp фейковыми данными"

    def add_arguments(self, parser: CommandParser) -> None:
        """Чтение агрументов командной строки.

        :param parser: Описание
        :type parser: CommandParser
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

    def print_stat(self) -> None:
        """Вывод статистики."""
        projects = Project.objects.count()
        tags = Tag.objects.count()
        comments = Comment.objects.count()
        users = User.objects.count()

        self.output_text("")
        self.output_text("Общая статистика", "notice")
        self.output_text(f"\t Кол-во проектов {projects}")
        self.output_text(f"\t Кол-во тегов {tags}")
        self.output_text(f"\t Кол-во коментариев {comments}")
        self.output_text(f"\t Кол-во пользователей {users}")

    def clear_data(self, is_clear: bool) -> None:  # noqa: FBT001
        """Docstring для clear_data.

        :param option: Описание
        :type option: dict[str: Any]
        """
        if is_clear:
            Project.objects.all().delete()
            Tag.objects.all().delete()
            User.objects.filter(pk__gt=1).delete()

    def output_text(self, text: str, output_type: str | None = None) -> None:
        """_summary_.

        :param text: _description_
        :type text: str
        :param output_type: _description_, defaults to None
        :type output_type: str | None, optional
        """
        match output_type:
            case "notice":
                self.stdout.write(f"\033[94m{text}\033[0m")
            case "success":
                self.stdout.write(self.style.SUCCESS(text))
            case "error":
                self.stdout.write(self.style.ERROR(text))
            case _:
                self.stdout.write(text)

    def output_process(self, idx: int) -> None:
        """Docstring для output_process."""
        print(idx, end="\r")  # noqa: T201

    def filling_project_models(self, options: dict[str, Any]) -> None:  # pylint: disable=too-many-locals
        """Заполнение моделей данными.

        :return: _description_
        :rtype: None
        """
        count = options.get("count")

        self.clear_data(bool(options.get("clear")))

        users = UserFactory.create_batch(10)
        tags = TagFactory.create_batch(10)

        self.output_text(f"Создаем проекты - {count} шт. Ожидайте...", "notice")
        project_data = []
        for idx in range(count):  # pyright: ignore[reportArgumentType]
            self.output_process(f"\u2192 Создано {idx + 1} проектов из {count}")  # pyright: ignore[reportArgumentType]
            project = ProjectFactory.build(
                owner=random.choice(self.users)  # noqa: S311
            )
            project.id = None
            project_data.append(project)
        self.output_text(f"\u2192 Создано {model} ({count}) - ", str_end="")
        self.output_text("OK" + " " * 10, "success")

        with transaction.atomic():
            self.projects = Project.objects.bulk_create(project_data)

        min_comments = 4
        max_comments = 10
        min_tags = 3
        max_tags = 6

        all_comments = []
        count_comments = 0
        for project in self.projects:
            selected_tags = random.choices(  # noqa: S311
                self.tags,
                k=random.randint(min_tags, max_tags),  # noqa: S311
            )
            project.tags.set(selected_tags)

            num_comments = random.randint(min_comments, max_comments)  # noqa: S311
            comment_users = random.sample(self.users, k=num_comments)
            count_comments += num_comments

            comments_for_project = [
                CommentFactory.build(
                    project=project,
                    owner=user,
                )
                for user in comment_users
            ]
            all_comments.extend(comments_for_project)
            self.output_process(f"\u2192 Создано {model} ({count_comments})")

        Comment.objects.bulk_create(all_comments)
        self.output_text("")
        self.output_text(f"\t Создано комментариев - {count_comments}")

    def handle(self, *args: list[Any], **options: dict[str, Any]) -> None:
        """Основная точка входа в программу.

        :param self: Описание
        :param args: Описание
        :type args: list[Any]
        :param options: Описание
        :type options: dict[str: Any]
        """
        self.options = options
        self.args = args
        self.models = [
            "Tag",
            "User",
            "Project",
            "Comment",
        ]

        start_time = time.time()
        self.clear_data()
        self.filling_models()
        self.print_stat()
        end_time = time.time()

        execution_time = end_time - start_time

        self.output_text(
            f"Добавление данных заняло {execution_time:.4f} сек.", "notice"
        )
