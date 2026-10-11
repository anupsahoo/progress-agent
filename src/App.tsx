import React, { useEffect, useState } from 'react';
import { Shell } from './components/Shell';
import { Dashboard } from './screens/Dashboard';
import { CustomerMaint } from './screens/CustomerMaint';
import { CustomerOrders } from './screens/CustomerOrders';
import { CustomerList } from './screens/CustomerList';
import { OrderReport } from './screens/OrderReport';
import { UpdateCredit } from './screens/UpdateCredit';
import { ROI } from './screens/ROI';
import { Mapping } from './screens/Mapping';

const TITLES: Record<string, string> = {
  dashboard: 'Dashboard',
  'customer-list': 'Customers',
  'customer-maint': 'Customer maintenance',
  'customer-orders': 'Orders',
  'order-report': 'Order report',
  'update-credit': 'Credit management',
  mapping: 'Legacy and modern mapping',
  roi: 'ROI',
};

/** Hash routes look like #route or #route/param (e.g. #customer-maint/3). */
function readHash(): { route: string; param?: string } {
  const h = window.location.hash.replace(/^#\/?/, '').trim();
  const [r, param] = h.split('/');
  const route = !r || r === 'home' ? 'dashboard' : r;
  return { route: TITLES[route] ? route : 'dashboard', param: param || undefined };
}

export default function App() {
  const [loc, setLoc] = useState(readHash);

  useEffect(() => {
    const onHash = () => setLoc(readHash());
    window.addEventListener('hashchange', onHash);
    return () => window.removeEventListener('hashchange', onHash);
  }, []);

  useEffect(() => {
    document.title = `${TITLES[loc.route]} · Sports2000`;
  }, [loc.route]);

  const navigate = (r: string) => {
    window.location.hash = `#${r}`;
    window.scrollTo({ top: 0 });
  };

  const { route, param } = loc;
  const screen = (() => {
    switch (route) {
      case 'customer-maint': return <CustomerMaint param={param} />;
      case 'customer-orders': return <CustomerOrders param={param} onNavigate={navigate} />;
      case 'customer-list': return <CustomerList param={param} onNavigate={navigate} />;
      case 'order-report': return <OrderReport param={param} />;
      case 'update-credit': return <UpdateCredit />;
      case 'roi': return <ROI />;
      case 'mapping': return <Mapping />;
      default: return <Dashboard onNavigate={navigate} />;
    }
  })();

  return (
    <Shell onNavigate={navigate} currentRoute={route}>
      <React.Fragment key={route}>{screen}</React.Fragment>
    </Shell>
  );
}
