"""Docstring for services.backend.apps.testapp.views."""

from django.contrib.auth.views import redirect_to_login
from django.http import HttpRequest, HttpResponse
from django.shortcuts import redirect
from django.urls import reverse
from django.views import View


class ProtectedSphinxView(View):
    """Docstring for ProtectedSphinxView."""

    def get(self, request: HttpRequest, path: str = "") -> HttpResponse:
        """Docstring for get.

        :param self: Description
        :param request: Description
        :type request: HttpRequest
        :param path: Description
        :type path: str
        """
        if not request.user.is_authenticated:
            login_url = reverse("admin:login")
            next_url = request.get_full_path()
            return redirect_to_login(next_url, login_url)

        if not request.user.has_perm("docs.view_sphinx"):
            return redirect(reverse("home"))

        response = HttpResponse()

        # При такое схеме работы есть ну удалять заголовки то будет два заголовка
        if "Content-Type" in response:
            del response["Content-Type"]

        response["X-Accel-Redirect"] = f"/internal/sphinx/{path}"
        return response
