import React, { useState, useEffect } from 'react';

const CustomerMaintenance: React.FC = () => {
  const [custNum, setCustNum] = useState<number | ''>('');
  const [customer, setCustomer] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [success, setSuccess] = useState<boolean>(false);

  const fetchCustomer = async () => {
    if (custNum) {
      setLoading(true);
      setError('');
      try {
        const response = await fetch(`/api/customer/${custNum}`);
        if (!response.ok) {
          throw new Error('Customer not found.');
        }
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
    }
  };

  useEffect(() => {
    if (success) {
      setTimeout(() => setSuccess(false), 3000);
    }
  }, [success]);

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
          onClick={fetchCustomer}
          style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
        >
          Search
        </button>
      </div>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>Record updated successfully.</p>}
      {customer && (
        <div style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '15px', marginTop: '20px' }}>
          <h3>Customer Details</h3>
          <div>
            <label>Customer Number:</label>
            <p>{customer.CustNum}</p>
          </div>
          <div>
            <label>Name:</label>
            <input
              type="text"
              value={customer.Name}
              onChange={(e) => setCustomer({ ...customer, Name: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <div>
            <label>Address:</label>
            <input
              type="text"
              value={customer.Address}
              onChange={(e) => setCustomer({ ...customer, Address: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <div>
            <label>City:</label>
            <input
              type="text"
              value={customer.City}
              onChange={(e) => setCustomer({ ...customer, City: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <div>
            <label>State:</label>
            <input
              type="text"
              value={customer.State}
              onChange={(e) => setCustomer({ ...customer, State: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <div>
            <label>Postal Code:</label>
            <input
              type="text"
              value={customer.PostalCode}
              onChange={(e) => setCustomer({ ...customer, PostalCode: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <div>
            <label>Phone:</label>
            <input
              type="text"
              value={customer.Phone}
              onChange={(e) => setCustomer({ ...customer, Phone: e.target.value })}
              style={{ width: '100%', padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
            />
          </div>
          <button
            onClick={updateCustomer}
            style={{ marginTop: '10px', padding: '10px 15px', backgroundColor: '#3b5bdb', color: '#fff', border: 'none', borderRadius: '5px', cursor: 'pointer' }}
          >
            Update
          </button>
        </div>
      )}
    </div>
  );
};

export default CustomerMaintenance;