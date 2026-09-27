import { useState, useEffect } from 'react';
import { CorrectiveAction } from '../types';
import { correctiveActionsApi } from '../api/correctiveActions';

export function useCorrectiveActions(manualInit = true) {
  const [correctiveActions, setCorrectiveActions] = useState<CorrectiveAction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchCorrectiveActions = async () => {
    try {
      setLoading(true);
      const data = await correctiveActionsApi.getAll();
      setCorrectiveActions(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch corrective actions');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (manualInit) {
      fetchCorrectiveActions();
    }
  }, [manualInit]);

  return { correctiveActions, loading, error, refresh: fetchCorrectiveActions };
}
