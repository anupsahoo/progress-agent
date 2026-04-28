import React, { useEffect, useState } from 'react';
import Home from './Home';
import CustomerMaint from './components/CustomerMaint';
import Shell from './components/Shell';

export default function App() {
  const [hash, setHash] = useState(window.location.hash);
  useEffect(() => {
    const onHash = () => setHash(window.location.hash);
    window.addEventListener('hashchange', onHash);
    return () => window.removeEventListener('hashchange', onHash);
  }, []);
  if (hash === '#/customermaint') return <CustomerMaint />;
  if (hash === '#/shell') return <Shell />;
  return <Home />;
}
