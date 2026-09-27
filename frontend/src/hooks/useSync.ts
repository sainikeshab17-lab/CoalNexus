import { useEffect, useCallback } from 'react';
import { useMines } from './useMines';
import { useInspections } from './useInspections';
import { useFindings } from './useFindings';
import { useViolations } from './useViolations';
import { useCorrectiveActions } from './useCorrectiveActions';
import { useAlerts } from './useAlerts';
import { useAuditTrail } from './useAuditTrail';

export function useSync(manualInit = true) {
  const { refresh: refreshMines } = useMines(false);
  const { refresh: refreshInspections } = useInspections(false);
  const { refresh: refreshFindings } = useFindings(false);
  const { refresh: refreshViolations } = useViolations(false);
  const { refresh: refreshCAs } = useCorrectiveActions(false);
  const { refresh: refreshAlerts } = useAlerts(false);
  const { refresh: refreshAudit } = useAuditTrail(false);

  const refreshMap: Record<string, () => void> = {
    'mine': refreshMines,
    'inspection': refreshInspections,
    'finding': refreshFindings,
    'violation': refreshViolations,
    'corrective_action': refreshCAs,
    'alert': refreshAlerts,
    'audit': refreshAudit
  };

  const handleSyncEvent = useCallback((payload: any) => {
    const event = payload.event;
    const entityType = payload.entity_type;

    if (event === 'entity.updated' || entityType) {
      if (entityType && refreshMap[entityType]) {
        refreshMap[entityType]();
      } else {
        // Refresh all if entity type is unknown or missing
        Object.values(refreshMap).forEach(refresh => refresh());
      }
    }
  }, []);

  useEffect(() => {
    if (!manualInit) return;
    let WS_URL = "";
    if (import.meta.env.VITE_API_URL) {
      if (import.meta.env.VITE_API_URL.startsWith('http')) {
        WS_URL = import.meta.env.VITE_API_URL
          .replace('https://', 'wss://')
          .replace('http://', 'ws://')
          .replace('/api', '/ws/telemetry');
      } else {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        WS_URL = `${protocol}//${window.location.host}${import.meta.env.VITE_API_URL.replace('/api', '/ws/telemetry')}`;
      }
    } else {
      const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
      WS_URL = `${protocol}//${window.location.host}/ws/telemetry`;
    }

    let ws: WebSocket | null = null;
    let reconnectTimeout: any = null;

    const connect = () => {
      try {
        ws = new WebSocket(WS_URL);

        ws.onmessage = (event) => {
          try {
            const payload = JSON.parse(event.data);
            handleSyncEvent(payload);
          } catch (e) {
            console.error("Failed to parse WS sync message", e);
          }
        };

        ws.onclose = () => {
          reconnectTimeout = setTimeout(connect, 5000);
        };

        ws.onerror = () => {
          ws?.close();
        };
      } catch (e) {
        reconnectTimeout = setTimeout(connect, 5000);
      }
    };

    connect();

    return () => {
      if (ws) {
        ws.onclose = null;
        ws.close();
      }
      if (reconnectTimeout) clearTimeout(reconnectTimeout);
    };
  }, [handleSyncEvent, manualInit]);
}
