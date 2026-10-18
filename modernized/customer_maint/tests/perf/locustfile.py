from locust import HttpUser, task, between


class CustomerMaintUser(HttpUser):
    wait_time = between(0.5, 2)

    @task(4)
    def lookup(self):
        self.client.get("/customers/3", name="GET /customers/{id}")

    @task(1)
    def not_found(self):
        with self.client.get("/customers/99999", name="GET /customers/{id} (404)", catch_response=True) as r:
            if r.status_code == 404:
                r.success()
