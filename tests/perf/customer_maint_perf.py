from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def get_customer(self):
        self.client.get('/customers/1')

    @task(2)
    def update_customer(self):
        self.client.put('/customers/1', json={'CustNum': 1, 'Name': 'Updated Name', 'Address': '123 Main St', 'City': 'Anytown', 'State': 'CA', 'PostalCode': '12345', 'Phone': '555-5555'})