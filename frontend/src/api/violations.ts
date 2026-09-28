import { client } from './client';
import { Violation } from '../types';

export const violationsApi = {
  getAll: (params?: { mine_id?: string }): Promise<Violation[]> => {
    const urlParams = new URLSearchParams();
    if (params?.mine_id) {
      urlParams.set('mine_id', params.mine_id);
    }
    const queryString = urlParams.toString();
    const endpoint = queryString ? `/violations?${queryString}` : '/violations';
    return client.get(endpoint);
  },
};
