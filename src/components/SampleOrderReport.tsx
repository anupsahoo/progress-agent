import React, { useState, useEffect } from 'react';

const OrderReport: React.FC = () => {
  const [customerNumber, setCustomerNumber] = useState<number | null>(null);
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);
  const [customerName, setCustomerName] = useState<string>('');

  const fetchOrders = async () => {
    if (customerNumber === null) return;
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`/api/sample-order-report?custNum=${customerNumber}`);
      if (!response.ok) {
        throw new Error(`Customer ${customerNumber} not found.`);
      }
      const data = await response.json();
      setOrders(data.orders);
      setCustomerName(data.customerName);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, [customerNumber]);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setCustomerNumber(Number(e.target.value));
  };

  return (
    <div style={{ fontFamily: 'Inter, sans-serif', padding: '20px' }}>
      <h1 style={{ color: '#3b5bdb' }}>Order Report</h1>
      <input
        type="number"
        placeholder="Enter Customer Number"
        onChange={handleInputChange}
        style={{ padding: '10px', marginBottom: '20px', borderRadius: '5px', border: '1px solid #ccc' }}
      />
      <button
        onClick={fetchOrders}
        style={{ padding: '10px 15px', backgroundColor: '#3b5bdb', color: 'white', border: 'none', borderRadius: '5px' }}
      >
        Fetch Orders
      </button>
      {loading && <p>Loading...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {orders.length === 0 && !loading && !error && <p>No orders found for this customer.</p>}
      {orders.map((order) => (
        <div key={order.orderNum} style={{ border: '1px solid #ccc', borderRadius: '5px', padding: '15px', margin: '10px 0' }}>
          <h2>Order #{order.orderNum}</h2>
          <p>Date: {new Date(order.orderDate).toLocaleDateString()}</p>
          <p>Ship Date: {new Date(order.shipDate).toLocaleDateString()}</p>
          <p>Status: {order.orderStatus}</p>
          <h3>Line Items</h3>
          {order.lineItems.map((line: any) => (
            <div key={line.lineNum} style={{ padding: '5px 0' }}>
              <span style={{ display: 'inline-block', width: '50px' }}>{line.lineNum}</span>
              <span style={{ display: 'inline-block', width: '200px' }}>{line.itemName}</span>
              <span style={{ display: 'inline-block', width: '50px' }}>{line.qty}</span>
              <span style={{ display: 'inline-block', width: '80px' }}>${line.price.toFixed(2)}</span>
              <span style={{ display: 'inline-block', width: '80px' }}>${line.extendedPrice.toFixed(2)}</span>
            </div>
          ))}
          <p>Total Lines: {order.lineCount}, Total: ${order.orderTotal.toFixed(2)}</p>
        </div>
      ))}
    </div>
  );
};

export default OrderReport;