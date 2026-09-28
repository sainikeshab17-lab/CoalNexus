import { useState, useEffect, useCallback } from 'react';
import { Mine } from '../types';
import { minesApi, MineFilters } from '../api/mines';

export function useMines(manualInitOrFilters: boolean | MineFilters = true) {
  const [mines, setMines] = useState<Mine[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMines = useCallback(async (filters?: MineFilters) => {
    setLoading(true);
    try {
      const data = await minesApi.getAll(filters);
      setMines(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch mines');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (typeof manualInitOrFilters === 'boolean') {
      if (manualInitOrFilters) {
        fetchMines();
      }
    } else {
      fetchMines(manualInitOrFilters);
    }
  }, [manualInitOrFilters, fetchMines]);

  return { mines, loading, error, refresh: fetchMines };
}
