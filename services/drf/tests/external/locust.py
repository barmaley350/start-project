"""Docstring для services.drf.tests.external.locust."""

from locust import HttpUser, between, task


class ApiProject(HttpUser):
    """Docstring для ApiProject."""

    # Время ожидания между запросами (в секундах)
    wait_time = between(1, 3)

    @task(5)
    def get_projects_api(self) -> None:
        """Docstring для get_projects.

        :param self: Описание
        """
        headers = {}
        self.client.get("/api/v1/project/", headers=headers)
