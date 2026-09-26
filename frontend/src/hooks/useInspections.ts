import { useState, useEffect } from 'react';
import { Inspection } from '../types';
import { inspectionsApi } from '../api/inspections';

export function useInspections() {
  const [inspections, setInspections] = useState<Inspection[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchInspections = async () => {
    try {
      setLoading(true);
      const data = await inspectionsApi.getAll();
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
  }, []);

  return { inspections, loading, error, refresh: fetchInspections };
}
