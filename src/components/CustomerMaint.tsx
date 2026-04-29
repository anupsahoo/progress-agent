import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [successMessage, setSuccessMessage] = useState<string>('');

  const handleFetchCustomer = async () => {
    if (!custNum) return;
    setLoading(true);
    setError('');
    setSuccessMessage('');

    try {
      const response = await fetch(`/api/customer/${custNum}`);
      if (!response.ok) throw new Error('Customer not found.');
      const data = await response.json();
      setCustomer(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateCustomer = async () => {
    if (!customer) return;
    setLoading(true);
    setError('');
    setSuccessMessage('');

    try {
      const response = await fetch(`/api/customer/${custNum}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(customer),
      });
      if (!response.ok) throw new Error('Failed to update customer.');
      setSuccessMessage('Record updated successfully.');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px', maxWidth: '600px', margin: 'auto' }}>
      <h2 style={{ color: '#3b5bdb' }}>Customer Maintenance</h2>
      <div style={{ marginBottom: '20px' }}>
        <input
          type="number"
          value={custNum}
          onChange={(e) => setCustNum(Number(e.target.value))}
          placeholder="Enter Customer Number"
          style={{ padding: '10px', width: '100%', borderRadius: '5px', border: '1px solid #ccc' }}
        />
        <button
          onClick={handleFetchCustomer}
          style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
        >
          Search
        </button>
      </div>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {successMessage && <p style={{ color: 'green' }}>{successMessage}</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '15px', marginTop: '20px' }}>
          <h3>Customer Details</h3>
          <div>
            <label>Customer Number:</label>
            <input
              type="text"
              value={customer.CustNum}
              readOnly
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>Name:</label>
            <input
              type="text"
              value={customer.Name}
              onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>Address:</label>
            <input
              type="text"
              value={customer.Address}
              onChange={(e) => setCustomer({ ...customer, Address: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>City:</label>
            <input
              type="text"
              value={customer.City}
              onChange={(e) => setCustomer({ ...customer, City: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>State:</label>
            <input
              type="text"
              value={customer.State}
              onChange={(e) => setCustomer({ ...customer, State: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>Postal Code:</label>
            <input
              type="text"
              value={customer.PostalCode}
              onChange={(e) => setCustomer({ ...customer, PostalCode: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <label>Phone:</label>
            <input
              type="text"
              value={customer.Phone}
              onChange={(e) => setCustomer({ ...customer, Phone: e.target.value })}
              style={{ width: '100%', marginBottom: '10px' }}
            />
            <button
              onClick={handleUpdateCustomer}
              style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
            >
              Update
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;