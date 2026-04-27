import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [updated, setUpdated] = useState<boolean>(false);

  const fetchCustomer = async (id: number) => {
    setLoading(true);
    setError('');
    try {
      const response = await fetch(`/customers/${id}`);
      if (!response.ok) {
        throw new Error('Customer not found');
      }
      const data = await response.json();
      setCustomer(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdate = async () => {
    if (!customer) return;
    setLoading(true);
    setError('');
    try {
      const response = await fetch(`/customers/${customer.CustNum}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(customer),
      });
      if (!response.ok) {
        throw new Error('Failed to update customer');
      }
      setUpdated(true);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    if (custNum) {
      fetchCustomer(Number(custNum));
    }
  };

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px', maxWidth: '600px', margin: 'auto' }}>
      <h1 style={{ color: '#3b5bdb' }}>Customer Maintenance</h1>
      <div style={{ marginBottom: '20px' }}>
        <input
          type="number"
          value={custNum}
          onChange={(e) => setCustNum(e.target.value)}
          placeholder="Enter Customer Number"
          style={{ padding: '10px', width: '100%', borderRadius: '5px', border: '1px solid #ccc' }}
        />
        <button
          onClick={handleSearch}
          style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
        >
          Search
        </button>
      </div>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '15px', backgroundColor: '#f9f9f9' }}>
          <h2>Customer Details</h2>
          <div>
            <label>CustNum:</label>
            <input
              type="text"
              value={customer.CustNum}
              readOnly
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>Name:</label>
            <input
              type="text"
              value={customer.Name}
              onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>Address:</label>
            <input
              type="text"
              value={customer.Address}
              onChange={(e) => setCustomer({ ...customer, Address: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>City:</label>
            <input
              type="text"
              value={customer.City}
              onChange={(e) => setCustomer({ ...customer, City: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>State:</label>
            <input
              type="text"
              value={customer.State}
              onChange={(e) => setCustomer({ ...customer, State: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>Postal Code:</label>
            <input
              type="text"
              value={customer.PostalCode}
              onChange={(e) => setCustomer({ ...customer, PostalCode: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <div>
            <label>Phone:</label>
            <input
              type="text"
              value={customer.Phone}
              onChange={(e) => setCustomer({ ...customer, Phone: e.target.value })}
              style={{ margin: '5px', padding: '5px', width: '100%' }}
            />
          </div>
          <button
            onClick={handleUpdate}
            style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
          >
            Update
          </button>
          {updated && <p style={{ color: 'green' }}>Record updated successfully.</p>}
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;