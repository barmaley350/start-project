"""Docstring for services.backend.apps.testapp.factories."""

import factory
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from faker import Faker

from apps.testapp.models import Comment, Project, Tag

factory.Faker._DEFAULT_LOCALE = "ru_RU"  # noqa: SLF001  pylint: disable=W0212
fake_en = Faker("en_US")


class UserFactory(factory.django.DjangoModelFactory):
    """Docstring для UserFactory."""

    class Meta:
        """Docstring для Meta."""

        model = User

    username = factory.Faker("user_name")
    email = factory.Faker("email")
    first_name = factory.Faker("first_name")
    last_name = factory.Faker("last_name")
    password = factory.LazyFunction(lambda: make_password("testpass123"))


class ProjectFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:
        """Docstring for Meta."""

        model = Project

    title = factory.Faker("text", max_nb_chars=100)
    description = factory.Faker("text", max_nb_chars=500)


class CommentFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:
        """Docstring for Meta."""

        model = Comment

    title = factory.Faker("text", max_nb_chars=100)
    description = factory.Faker("text", max_nb_chars=500)
    project = factory.SubFactory(ProjectFactory)
    owner = factory.LazyAttribute(lambda _: User.objects.first())


class TagFactory(factory.django.DjangoModelFactory):
    """Docstring для TagFactory."""

    class Meta:
        """Docstring для Meta."""

        model = Tag

    name = factory.LazyAttribute(lambda _: fake_en.unique.word())
