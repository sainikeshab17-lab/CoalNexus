import { useState, useEffect } from 'react';
import { Violation } from '../types';
import { violationsApi } from '../api/violations';

export function useViolations(manualInit = true) {
  const [violations, setViolations] = useState<Violation[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchViolations = async () => {
    try {
      setLoading(true);
      const data = await violationsApi.getAll();
      setViolations(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch violations');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (manualInit) {
      fetchViolations();
    }
  }, [manualInit]);

  return { violations, loading, error, refresh: fetchViolations };
}
