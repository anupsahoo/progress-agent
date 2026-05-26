from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def create_customer(self):
        self.client.post('/customers/', json={
            'customer_number': 1,
            'customer_name': 'John Doe',
            'customer_address': '123 Elm St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-1234'
        })

    @task(2)
    def read_customer(self):
        self.client.get('/customers/1')

    @task(1)
    def delete_customer(self):
        self.client.delete('/customers/1')
