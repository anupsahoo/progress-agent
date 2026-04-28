from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def create_customer(self):
        self.client.post("/customers/", json={"customer_number": "C001", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"})

    @task(2)
    def find_customer(self):
        self.client.get("/customers/C001")

    @task(1)
    def delete_customer(self):
        self.client.delete("/customers/C001")
