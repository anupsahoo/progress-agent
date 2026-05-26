import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [success, setSuccess] = useState<boolean>(false);

  const handleFetchCustomer = async () => {
    if (custNum === '') return;
    setLoading(true);
    setError('');
    setSuccess(false);

    try {
      const response = await fetch(`/api/customer/${custNum}`);
      if (!response.ok) {
        throw new Error('Customer not found.');
      }
      const data = await response.json();
      setCustomer(data);
    } catch (err) {
      setError(err.message);
      setCustomer(null);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateCustomer = async () => {
    if (!customer) return;
    setLoading(true);
    setError('');
    setSuccess(false);

    try {
      const response = await fetch(`/api/customer/${custNum}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(customer),
      });
      if (!response.ok) {
        throw new Error('Failed to update customer.');
      }
      setSuccess(true);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px', maxWidth: '600px', margin: 'auto' }}>
      <h1 style={{ color: '#3b5bdb' }}>Customer Maintenance</h1>
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
          style={{ marginTop: '10px', padding: '10px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
        >
          Find Customer
        </button>
      </div>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '20px', marginBottom: '20px' }}>
          <h2>Customer Details</h2>
          <p><strong>Customer Number:</strong> {customer.CustNum}</p>
          <input
            type="text"
            value={customer.Name}
            onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
            placeholder="Name"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <input
            type="text"
            value={customer.Address}
            onChange={(e) => setCustomer({ ...customer, Address: e.target.value })}
            placeholder="Address"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <input
            type="text"
            value={customer.City}
            onChange={(e) => setCustomer({ ...customer, City: e.target.value })}
            placeholder="City"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <input
            type="text"
            value={customer.State}
            onChange={(e) => setCustomer({ ...customer, State: e.target.value })}
            placeholder="State"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <input
            type="text"
            value={customer.PostalCode}
            onChange={(e) => setCustomer({ ...customer, PostalCode: e.target.value })}
            placeholder="Postal Code"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <input
            type="text"
            value={customer.Phone}
            onChange={(e) => setCustomer({ ...customer, Phone: e.target.value })}
            placeholder="Phone"
            style={{ padding: '10px', width: '100%', marginBottom: '10px' }}
          />
          <button
            onClick={handleUpdateCustomer}
            style={{ padding: '10px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
          >
            Update Customer
          </button>
          {success && <p style={{ color: 'green' }}>Record updated successfully.</p>}
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;