import { useState, useEffect } from 'react';
import { Finding } from '../types';
import { findingsApi } from '../api/findings';

export function useFindings() {
  const [findings, setFindings] = useState<Finding[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchFindings = async () => {
    try {
      setLoading(true);
      const data = await findingsApi.getAll();
      setFindings(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch findings');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchFindings();
  }, []);

  return { findings, loading, error, refresh: fetchFindings };
}
