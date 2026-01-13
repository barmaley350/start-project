"""Docstring для services.fastapi.tests.external.locust."""

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
        self.client.get("/fastapi/api/v1/projects", headers=headers)

    # @task(5)
    # def get_projects(self) -> None:
    #     """Docstring для get_projects.

    #     :param self: Описание
    #     """
    #     headers = {}
    #     self.client.get("/projects/", headers=headers)

    # @task(1)
    # def get_main(self) -> None:
    #     """Docstring для get_main.

    #     :param self: Описание
    #     """
    #     headers = {}
    #     self.client.get("/", headers=headers)
