import { useState, useEffect } from 'react';
import { Inspection } from '../types';
import { inspectionsApi } from '../api/inspections';

export function useInspections(mineId?: string) {
  const [inspections, setInspections] = useState<Inspection[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchInspections = async () => {
    try {
      setLoading(true);
      const data = await inspectionsApi.getAll(mineId ? { mine_id: mineId } : undefined);
      setInspections(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch inspections');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInspections();
  }, [mineId]);

  return { inspections, loading, error, refresh: fetchInspections };
}
