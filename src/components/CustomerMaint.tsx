import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [updated, setUpdated] = useState<boolean>(false);

  const fetchCustomer = async () => {
    if (custNum) {
      setLoading(true);
      setError('');
      try {
        const response = await fetch(`/api/customer/${custNum}`);
        if (!response.ok) throw new Error('Customer not found');
        const data = await response.json();
        setCustomer(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
  };

  const handleUpdate = async () => {
    if (customer) {
      setLoading(true);
      setError('');
      try {
        const response = await fetch(`/api/customer/${custNum}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(customer),
        });
        if (!response.ok) throw new Error('Failed to update customer');
        setUpdated(true);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
  };

  useEffect(() => {
    if (updated) {
      fetchCustomer();
      setUpdated(false);
    }
  }, [updated]);

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px', maxWidth: '600px', margin: 'auto' }}>
      <h1 style={{ color: '#3b5bdb' }}>Customer Maintenance</h1>
      <input
        type="number"
        value={custNum}
        onChange={(e) => setCustNum(Number(e.target.value))}
        placeholder="Enter Customer Number"
        style={{ padding: '10px', width: '100%', marginBottom: '20px' }}
      />
      <button
        onClick={fetchCustomer}
        style={{ padding: '10px 20px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', cursor: 'pointer' }}
      >
        Search
      </button>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', padding: '20px', borderRadius: '8px', marginTop: '20px' }}>
          <h2>Customer Details</h2>
          <div>
            <label>CustNum:</label> {customer.CustNum}
          </div>
          <div>
            <label>Name:</label>
            <input
              type="text"
              value={customer.Name}
              onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <div>
            <label>Address:</label>
            <input
              type="text"
              value={customer.Address}
              onChange={(e) => setCustomer({ ...customer, Address: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <div>
            <label>City:</label>
            <input
              type="text"
              value={customer.City}
              onChange={(e) => setCustomer({ ...customer, City: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <div>
            <label>State:</label>
            <input
              type="text"
              value={customer.State}
              onChange={(e) => setCustomer({ ...customer, State: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <div>
            <label>Postal Code:</label>
            <input
              type="text"
              value={customer.PostalCode}
              onChange={(e) => setCustomer({ ...customer, PostalCode: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <div>
            <label>Phone:</label>
            <input
              type="text"
              value={customer.Phone}
              onChange={(e) => setCustomer({ ...customer, Phone: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
          </div>
          <button
            onClick={handleUpdate}
            style={{ padding: '10px 20px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', cursor: 'pointer' }}
          >
            Update
          </button>
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;