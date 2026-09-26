import { useState, useEffect } from 'react';
import { Telemetry } from '../types';
import { telemetryApi } from '../api/telemetry';

export function useTelemetry(mineId?: string) {
  const [telemetry, setTelemetry] = useState<Telemetry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchTelemetry = async () => {
    try {
      setLoading(true);
      const data = mineId
        ? await telemetryApi.getByMineId(mineId)
        : await telemetryApi.getAll();
      setTelemetry(data);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch telemetry');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTelemetry();

    // Try WebSocket connection
    let WS_URL = "";
    if (import.meta.env.VITE_API_URL) {
      if (import.meta.env.VITE_API_URL.startsWith('http')) {
        WS_URL = import.meta.env.VITE_API_URL
          .replace('https://', 'wss://')
          .replace('http://', 'ws://')
          .replace('/api', '/ws/telemetry');
      } else {
        // Handle relative URL path if any
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        WS_URL = `${protocol}//${window.location.host}${import.meta.env.VITE_API_URL.replace('/api', '/ws/telemetry')}`;
      }
    } else {
      const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
      WS_URL = `${protocol}//${window.location.host}/ws/telemetry`;
    }

    let ws: WebSocket | null = null;

    try {
      ws = new WebSocket(WS_URL);

      ws.onmessage = (event) => {
        try {
          const newTelemetry = JSON.parse(event.data);
          if (!mineId || newTelemetry.mine_id === mineId) {
            setTelemetry(prev => [newTelemetry, ...prev].slice(0, 100));
          }
        } catch (e) {
          console.error("Failed to parse WS telemetry", e);
        }
      };

      ws.onerror = () => {
        console.warn("WebSocket error, falling back to polling");
      };
    } catch (e) {
      console.warn("Could not connect WebSocket", e);
    }

    // Polling fallback
    const interval = setInterval(fetchTelemetry, 10000);

    return () => {
      clearInterval(interval);
      if (ws) ws.close();
    };
  }, [mineId]);

  return { telemetry, loading, error, refresh: fetchTelemetry };
}
