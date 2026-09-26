import { useState, useEffect } from 'react';
import { Alert } from '../types';
import { alertsApi } from '../api/alerts';

export function useAlerts() {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchAlerts = async () => {
    try {
      setLoading(true);
      const data = await alertsApi.getAll();
      setAlerts(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch alerts');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAlerts();
  }, []);

  return { alerts, loading, error, refresh: fetchAlerts };
}
