from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def create_customer(self):
        self.client.post('/customers/', json={'cust_num': 1, 'name': 'John Doe', 'address': '123 Elm St', 'city': 'Anytown', 'state': 'CA', 'postal_code': '12345', 'phone': '555-1234'})

    @task(2)
    def read_customer(self):
        self.client.get('/customers/1')

    @task(1)
    def delete_customer(self):
        self.client.delete('/customers/1')