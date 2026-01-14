"""Docstring для services.fastapi.tests.external.locust."""

from locust import HttpUser, between, task


class ApiProject(HttpUser):
    """Docstring для ApiProject."""

    host = "http://localhost:1338"
    wait_time = between(1, 3)

    @task(5)
    def get_projects_api(self) -> None:
        """Docstring для get_projects.

        :param self: Описание
        """
        headers = {}
        self.client.get("/fastapi/api/v1/projects", headers=headers)
