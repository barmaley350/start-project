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

    help = "Заполнение моделей приложения apps/testapp данными"

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

    def output_text(
        self, text: str, output_type: str | None = None, str_end: str = "\n"
    ) -> None:
        r"""Вывод форматированных сообщений.

        :param text: _description_
        :type text: str
        :param output_type: _description_, defaults to None
        :type output_type: str | None, optional
        :param str_end: _description_, defaults to "\n"
        :type str_end: str, optional
        """
        match output_type:
            case "notice":
                self.stdout.write(f"\033[94m{text}\033[0m", ending=str_end)
            case "success":
                self.stdout.write(self.style.SUCCESS(text), ending=str_end)
            case "error":
                self.stdout.write(self.style.ERROR(text), ending=str_end)
            case _:
                self.stdout.write(text, ending=str_end)

    def print_stat(self) -> None:
        """Вывод статистики."""
        projects = Project.objects.count()
        tags = Tag.objects.count()
        comments = Comment.objects.count()
        users = User.objects.count()

        self.output_text("Общая статистика", "notice")
        self.output_text(f"\u2192 Кол-во проектов {projects}")
        self.output_text(f"\u2192 Кол-во тегов {tags}")
        self.output_text(f"\u2192 Кол-во коментариев {comments}")
        self.output_text(f"\u2192 Кол-во пользователей {users}")

    def clear_data(self) -> None:
        """Удаление всех данных."""
        if self.options.get("clear"):
            self.output_text(f"Удаляем модели ({', '.join(self.models)})", "notice")
            Project.objects.all().delete()
            self.output_text("\u2192 Удалено Project - ", str_end="")
            self.output_text("OK", "success")

            Tag.objects.all().delete()
            self.output_text("\u2192 Удалено Tag - ", str_end="")
            self.output_text("OK", "success")

            User.objects.filter(pk__gt=1).delete()
            self.output_text("\u2192 Удалено User - ", str_end="")
            self.output_text("OK", "success")

    def output_process(self, idx: str) -> None:
        """Вывод текста на одной строке."""
        print(idx, end="\r")  # noqa: T201

    def make_project(self, model: str) -> None:
        """Заполнение модели Project."""
        count = self.options.get("count")
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

    def make_comment(self, model: str) -> None:
        """Заполнение модели Comment."""
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
        self.output_text(
            f"\r\u2192 Создано {model} ({count_comments}) - ",
            str_end="",
        )
        self.output_text("OK" + " " * 10, "success")

    def make_model(self, model: str) -> None:
        """Заполнение моделей."""
        if model == "Tag":
            self.tags = TagFactory.create_batch(10)
            self.output_text(f"\u2192 Создано {model} (10) - ", str_end="")
            self.output_text("OK", "success")
        elif model == "User":
            self.users = UserFactory.create_batch(10)
            self.output_text(f"\u2192 Создано {model} (10) - ", str_end="")
            self.output_text("OK", "success")
        else:
            self.output_text(f"\u2192 Нет такой модели {model} ", str_end="")
            self.output_text("ERROR", "error")

    def filling_models(self) -> None:
        """_summary_."""
        self.output_text(f"Создаем модели ({', '.join(self.models)})", "notice")
        for model in self.models:
            if model == "Project":
                self.make_project(model)
            elif model == "Comment":
                self.make_comment(model)
            else:
                self.make_model(model)

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
