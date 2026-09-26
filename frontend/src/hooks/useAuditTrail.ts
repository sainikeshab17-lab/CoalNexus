import { useState, useEffect } from 'react';
import { AuditTrail } from '../types';
import { auditApi } from '../api/audit';

export function useAuditTrail() {
  const [auditTrail, setAuditTrail] = useState<AuditTrail[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchAuditTrail = async () => {
    try {
      setLoading(true);
      const data = await auditApi.getAll();
      setAuditTrail(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch audit trail');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAuditTrail();
  }, []);

  return { auditTrail, loading, error, refresh: fetchAuditTrail };
}
