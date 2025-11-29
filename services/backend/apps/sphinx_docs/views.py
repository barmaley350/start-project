"""Docstring for services.backend.apps.testapp.views."""

from pathlib import Path

from django.contrib.auth.decorators import login_required
from django.http import HttpRequest, HttpResponse
from django.views.static import serve

from settings.settings import BASE_DIR


@login_required
def sphinx_docs(request: HttpRequest, path: str = "") -> HttpResponse:
    """Функция для ограничения доступа к документации.

    Документация создается через Sphinx.
    Доступ получают авторизированные пользователи через /admin/

    Из текущих проблем:

    1. После авторизации нет перехода на страницу документации. Нужно заходить по ссылке

    2. Нужно подправить формат вывода документации

    :param request: Description
    :type request: HttpRequest
    :param path: Description
    :type path: str
    :return: Description
    :rtype: HttpResponse
    """
    docs_path = Path(BASE_DIR) / "docs" / "_build" / "html"
    return serve(request, path, str(docs_path))
