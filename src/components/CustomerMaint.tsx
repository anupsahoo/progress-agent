import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [success, setSuccess] = useState<string>('');

  const fetchCustomer = async () => {
    if (custNum) {
      setLoading(true);
      setError('');
      setSuccess('');
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
    }
  };

  const updateCustomer = async () => {
    if (customer) {
      setLoading(true);
      setError('');
      setSuccess('');
      try {
        const response = await fetch(`/api/customer/${custNum}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(customer),
        });
        if (!response.ok) throw new Error('Failed to update customer.');
        setSuccess('Record updated successfully.');
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
  };

  useEffect(() => {
    if (custNum) fetchCustomer();
  }, [custNum]);

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px', maxWidth: '600px', margin: 'auto' }}>
      <h1 style={{ color: '#3b5bdb' }}>Customer Maintenance</h1>
      <input
        type="number"
        value={custNum}
        onChange={(e) => setCustNum(Number(e.target.value))}
        placeholder="Enter Customer Number"
        style={{ padding: '10px', width: '100%', marginBottom: '20px', border: '1px solid #ccc', borderRadius: '5px' }}
      />
      <button
        onClick={fetchCustomer}
        style={{ padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
      >
        Search
      </button>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>{success}</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '20px', marginTop: '20px' }}>
          <h2>Customer Details</h2>
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
            style={{ padding: '10px', width: '100%', marginBottom: '20px' }}
          />
          <button
            onClick={updateCustomer}
            style={{ padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
          >
            Update
          </button>
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;