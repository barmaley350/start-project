"""Docstring for services.backend.apps.testapp.factories."""

import factory
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from factory.declarations import LazyAttribute, LazyFunction, SubFactory
from factory.faker import Faker
from faker import Faker as FakerBase

from apps.testapp.models import Comment, Project, Tag

fake_en = FakerBase("en_US")


class UserFactory(factory.django.DjangoModelFactory):
    """Docstring для UserFactory."""

    class Meta:  # type: ignore  # noqa: PGH003
        """Docstring для Meta."""

        model = User

    username = Faker("user_name")
    email = Faker("email")
    first_name = Faker("first_name", locale="ru_RU")
    last_name = Faker("last_name", locale="ru_RU")
    password = LazyFunction(lambda: make_password("testpass123"))


class ProjectFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:  # type: ignore  # noqa: PGH003
        """Docstring for Meta."""

        model = Project

    title = Faker("text", max_nb_chars=100, locale="ru_RU")
    description = Faker("text", max_nb_chars=500, locale="ru_RU")


class CommentFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:  # type: ignore  # noqa: PGH003
        """Docstring for Meta."""

        model = Comment

    title = Faker("text", max_nb_chars=100, locale="ru_RU")
    description = Faker("text", max_nb_chars=500, locale="ru_RU")
    project = SubFactory(ProjectFactory)
    owner = SubFactory(UserFactory)


class TagFactory(factory.django.DjangoModelFactory):
    """Docstring для TagFactory."""

    class Meta:  # type: ignore  # noqa: PGH003
        """Docstring для Meta."""

        model = Tag

    name = LazyAttribute(lambda _: fake_en.unique.word())
