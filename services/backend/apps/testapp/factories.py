"""Docstring for services.backend.apps.testapp.factories."""

import factory
from django.contrib.auth.models import User

from apps.testapp.models import Comment, Project

factory.Faker._DEFAULT_LOCALE = "ru_RU"  # noqa: SLF001


class ProjectFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:
        """Docstring for Meta."""

        model = Project

    title = factory.Faker("text", max_nb_chars=100)
    description = factory.Faker("text", max_nb_chars=500)
    owner = factory.LazyFunction(lambda: User.objects.get(id=1))


class CommentFactory(factory.django.DjangoModelFactory):
    """Docstring for ProjectFactory."""

    class Meta:
        """Docstring for Meta."""

        model = Comment

    title = factory.Faker("text", max_nb_chars=100)
    description = factory.Faker("text", max_nb_chars=500)
    project = factory.SubFactory(ProjectFactory)
    owner = factory.LazyFunction(lambda: User.objects.get(id=1))
