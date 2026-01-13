"""Docstring for services.backend.apps.testapp.factories."""

import random

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
    # owner = None  # noqa: ERA001

    # owner = factory.LazyAttribute(lambda _: User.objects.first()) # noqa: ERA001
    # owner = factory.SubFactory(UserFactory)  # noqa: ERA001

    # @factory.post_generation
    # def tags(
    #     self,
    #     create: any,
    #     extracted: any,
    #     **kwargs: dict[str, any],  # noqa: ARG002
    # ) -> None:
    #     """_summary_.

    #     :param create: _description_
    #     :type create: any
    #     :param extracted: _description_
    #     :type extracted: any | None
    #     """
    #     if not create:
    #         return
    #     if extracted:
    #         self.tags.add(*extracted)

    # @factory.post_generation
    # def comments(
    #     self,
    #     create: any,
    #     extracted: any,
    #     **kwargs: dict[str, any],  # noqa: ARG002
    # ) -> None:
    #     """_summary_.

    #     :param create: _description_
    #     :type create: any
    #     :param extracted: _description_
    #     :type extracted: any
    #     """
    #     if not create:
    #         return
    #     count = extracted or 10
    #     CommentFactory.create_batch(count, project=self)


class CommentFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:
        """Docstring for Meta."""

        model = Comment

    title = factory.Faker("text", max_nb_chars=100)
    description = factory.Faker("text", max_nb_chars=500)
    project = factory.SubFactory(ProjectFactory)
    # owner = factory.LazyFunction(lambda: User.objects.get(id=1))  # noqa: ERA001
    # owner = factory.SubFactory(UserFactory)  # noqa: ERA001
    owner = factory.LazyAttribute(lambda _: User.objects.first())


class TagFactory(factory.django.DjangoModelFactory):
    """Docstring для TagFactory."""

    class Meta:
        """Docstring для Meta."""

        model = Tag

    # name = factory.Faker("unique.word", locale="en_US")  # noqa: ERA001
    name = factory.LazyAttribute(lambda _: fake_en.unique.word())
