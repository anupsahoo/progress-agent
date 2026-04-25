import React, { useEffect, useState } from 'react';
import { Shell } from './components/Shell';
import { Home } from './screens/Home';
import { CustomerMaint } from './screens/CustomerMaint';
import { CustomerOrders } from './screens/CustomerOrders';
import { CustomerList } from './screens/CustomerList';
import { OrderReport } from './screens/OrderReport';
import { UpdateCredit } from './screens/UpdateCredit';
import { ROI } from './screens/ROI';
import { Mapping } from './screens/Mapping';

function readHash(): string {
  const h = window.location.hash.replace(/^#\/?/, '').trim();
  return h || 'home';
}

export default function App() {
  const [route, setRoute] = useState<string>(readHash());

  useEffect(() => {
    const onHash = () => setRoute(readHash());
    window.addEventListener('hashchange', onHash);
    return () => window.removeEventListener('hashchange', onHash);
  }, []);

  const navigate = (r: string) => {
    window.location.hash = `#${r}`;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const screen = (() => {
    switch (route) {
      case 'customer-maint': return <CustomerMaint />;
      case 'customer-orders': return <CustomerOrders />;
      case 'customer-list': return <CustomerList />;
      case 'order-report': return <OrderReport />;
      case 'update-credit': return <UpdateCredit />;
      case 'roi': return <ROI />;
      case 'mapping': return <Mapping />;
      case 'home':
      default:
        return <Home onNavigate={navigate} />;
    }
  })();

  return (
    <Shell onNavigate={navigate} currentRoute={route}>
      {screen}
    </Shell>
  );
}
