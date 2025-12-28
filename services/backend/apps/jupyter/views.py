"""Docstring для services.backend.apps.jupyter.views."""

from django.http import HttpRequest, HttpResponse
from django.views import View
from rest_framework import status


class ProtectedJupyterView(View):
    """Docstring для ProtectedJupyterView."""

    def get(self, request: HttpRequest) -> HttpResponse:
        """Docstring для get.

        :param self: Описание
        :param request: Описание
        :type request: HttpRequest
        :return: Описание
        :rtype: HttpResponse
        """
        if request.user.is_authenticated and request.user.is_staff:
            return HttpResponse(status=status.HTTP_200_OK)

        return HttpResponse(status=status.HTTP_401_UNAUTHORIZED)
