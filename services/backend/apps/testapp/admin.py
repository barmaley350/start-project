"""Docstring for services.backend.apps.testapp.admin."""

from django.contrib import admin

from .models import Comment, Project


class ProjectAdmin(admin.ModelAdmin):
    """Docstring for ProjectAdmin."""

    list_per_page = 10
    list_display = ("title", "owner", "created_at", "updated_at")
    search_fields = ("title", "description")


admin.site.register(Project, ProjectAdmin)


class CommentAdmin(admin.ModelAdmin):
    """Docstring for ProjectAdmin."""

    list_per_page = 10
    list_display = ("title", "owner", "project_link", "created_at", "updated_at")
    search_fields = ("title", "description")
    readonly_fields = ("created_at", "updated_at", "project_description")

    def get_fields(self, request, obj=None) -> dict:  # noqa: ANN001, ARG002
        """Docstring for get_fields.

        :param self: Description
        :param request: Description
        :param obj: Description
        """
        fields = [
            field.name
            for field in self.model._meta.fields  # noqa: SLF001
            if field.name not in ["id"]
        ]
        fields.extend(["project_description"])
        return fields

    def project_description(self, obj) -> str:  # noqa: ANN001
        """Docstring for project_description.

        :param self: Description
        :param obj: Description
        """
        return obj.project.description

    def project_link(self, obj):  # noqa: ANN001, ANN201
        """Docstring for author_link.

        :param self: Description
        :param obj: Description
        """
        return obj.project.id

    project_description.short_description = "Описание проекта"
    project_link.short_description = "Проект"


admin.site.register(Comment, CommentAdmin)
