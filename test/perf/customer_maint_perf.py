from locust import HttpUser, task, between

class CustomerUser(HttpUser):
    wait_time = between(1, 3)

    @task(1)
    def create_customer(self):
        self.client.post('/customers/', json={
            'CustNum': 1,
            'Name': 'John Doe',
            'Address': '123 Main St',
            'City': 'Anytown',
            'State': 'CA',
            'PostalCode': '12345',
            'Phone': '555-1234'
        })

    @task(2)
    def read_customer(self):
        self.client.get('/customers/1')

    @task(1)
    def delete_customer(self):
        self.client.delete('/customers/1')
