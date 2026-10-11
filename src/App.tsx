import React, { useEffect, useState } from 'react';
import { CheckCircle2 } from 'lucide-react';
import { Shell } from './components/Shell';
import { Dashboard } from './screens/Dashboard';
import { CustomerMaint } from './screens/CustomerMaint';
import { CustomerOrders } from './screens/CustomerOrders';
import { CustomerList } from './screens/CustomerList';
import { OrderReport } from './screens/OrderReport';
import { UpdateCredit } from './screens/UpdateCredit';
import { ROI } from './screens/ROI';
import { Mapping } from './screens/Mapping';
import { LegacyGate, ModulePage } from './screens/ModulePage';
import { LiveProvider, useLive } from './data/live';
import { moduleById, moduleForRoute } from './data/estate';
import { useToasts } from './components/ui';

const TITLES: Record<string, string> = {
  dashboard: 'Estate overview',
  'customer-list': 'Customers',
  'customer-maint': 'Customer maintenance',
  'customer-orders': 'Orders',
  'order-report': 'Order report',
  'update-credit': 'Credit management',
  mapping: 'Legacy and modern mapping',
  roi: 'ROI',
  m: 'Module',
};

/** Hash routes look like #route, #route/param or #m/<module>/<screen>. */
function readHash(): { route: string; param?: string; sub?: string } {
  const h = window.location.hash.replace(/^#\/?/, '').trim();
  const [r, param, sub] = h.split('/');
  const route = !r || r === 'home' ? 'dashboard' : r;
  return { route: TITLES[route] ? route : 'dashboard', param: param || undefined, sub: sub || undefined };
}

export default function App() {
  const toasts = useToasts();
  return (
    <LiveProvider onChange={(msg) => toasts.push(msg, <CheckCircle2 size={17} color="#5fd34b" />)}>
      <Routes />
      {toasts.node}
    </LiveProvider>
  );
}

function Routes() {
  const [loc, setLoc] = useState(readHash);
  const live = useLive();

  useEffect(() => {
    const onHash = () => setLoc(readHash());
    window.addEventListener('hashchange', onHash);
    return () => window.removeEventListener('hashchange', onHash);
  }, []);

  useEffect(() => {
    const t = loc.route === 'm' ? moduleById(loc.param ?? '')?.title ?? 'Module' : TITLES[loc.route];
    document.title = `${t} · Sports2000 Enterprise`;
  }, [loc.route, loc.param]);

  const navigate = (r: string) => {
    window.location.hash = `#${r}`;
    window.scrollTo({ top: 0 });
  };

  const { route, param, sub } = loc;
  const gatedModule = moduleForRoute(route);
  const screen = (() => {
    if (gatedModule && !live.isModern(gatedModule)) return <LegacyGate moduleId={gatedModule} onNavigate={navigate} />;
    switch (route) {
      case 'm': return <ModulePage id={param ?? ''} tab={sub} onNavigate={navigate} />;
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

  const activeModule = route === 'm' ? param : gatedModule;
  return (
    <Shell onNavigate={navigate} currentRoute={route} activeModule={activeModule}>
      <React.Fragment key={`${route}/${route === 'm' ? `${param}/${sub ?? ''}` : ''}`}>{screen}</React.Fragment>
    </Shell>
  );
}
