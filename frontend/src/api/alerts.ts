import { client } from './client';
import { Alert } from '../types';

export const alertsApi = {
  getAll: (params?: { mine_id?: string }): Promise<Alert[]> => {
    const urlParams = new URLSearchParams();
    if (params?.mine_id) {
      urlParams.set('mine_id', params.mine_id);
    }
    const queryString = urlParams.toString();
    const endpoint = queryString ? `/alerts?${queryString}` : '/alerts';
    return client.get(endpoint);
  },
};
