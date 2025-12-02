"""Docstring for services.backend.apps.testapp.admin."""

from django.contrib import admin

from .models import Project


class ProjectAdmin(admin.ModelAdmin):
    """Docstring for ProjectAdmin."""

    list_per_page = 10
    list_display = ("title", "owner")
    search_fields = ("title", "description")


admin.site.register(Project, ProjectAdmin)
admin.site.site_header = "Тестовый проект"
