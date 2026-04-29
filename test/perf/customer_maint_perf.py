from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def get_customer(self):
        self.client.get("/customers/1")

    @task(2)
    def list_customers(self):
        self.client.get("/customers")

    @task(3)
    def update_customer(self):
        self.client.put("/customers/1", json={"id": 1, "name": "Updated Name", "email": "updated@example.com"})