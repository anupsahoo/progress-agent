import React, { useState } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState('');
  const [customer, setCustomer] = useState(null);
  const [message, setMessage] = useState('');

  const fetchCustomer = async () => {
    const response = await fetch(`/customers/${custNum}`);
    if (response.ok) {
      const data = await response.json();
      setCustomer(data);
      setMessage('');
    } else {
      setMessage('Customer not found.');
      setCustomer(null);
    }
  };

  const updateCustomer = async () => {
    const response = await fetch(`/customers/${custNum}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(customer),
    });
    if (response.ok) {
      setMessage('Record updated successfully.');
    } else {
      setMessage('Error updating record.');
    }
  };

  return (
    <div style={{ padding: '20px' }}>
      <h1>Customer Maintenance</h1>
      <input
        type="text"
        value={custNum}
        onChange={(e) => setCustNum(e.target.value)}
        placeholder="Enter Customer Number"
      />
      <button onClick={fetchCustomer}>Find Customer</button>
      {customer && (
        <div>
          <h2>Customer Details</h2>
          <input
            type="text"
            value={customer.Name}
            onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
          />
          <button onClick={updateCustomer}>Update Customer</button>
        </div>
      )}
      {message && <p>{message}</p>}
    </div>
  );
};

export default CustomerMaintenance;