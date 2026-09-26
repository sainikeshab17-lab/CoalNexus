import { client } from './client';
import { Alert } from '../types';

export const alertsApi = {
  getAll: (): Promise<Alert[]> => client.get('/alerts'),
};
