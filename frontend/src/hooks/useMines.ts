import { useState, useEffect } from 'react';
import { Mine } from '../types';
import { minesApi } from '../api/mines';

export function useMines() {
  const [mines, setMines] = useState<Mine[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMines = async () => {
    try {
      setLoading(true);
      const data = await minesApi.getAll();
      setMines(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch mines');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMines();
  }, []);

  return { mines, loading, error, refresh: fetchMines };
}
