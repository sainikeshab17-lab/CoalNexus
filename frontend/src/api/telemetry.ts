import { client } from './client';
import { Telemetry } from '../types';

export const telemetryApi = {
  getAll: (): Promise<Telemetry[]> => client.get('/telemetry'),
  getByMineId: (mineId: string): Promise<Telemetry[]> => client.get(`/telemetry/${mineId}`),
};
