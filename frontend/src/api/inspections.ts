import { client } from './client';
import { Inspection } from '../types';

export const inspectionsApi = {
  getAll: (params?: { mine_id?: string }): Promise<Inspection[]> => {
    const urlParams = new URLSearchParams();
    if (params?.mine_id) {
      urlParams.set('mine_id', params.mine_id);
    }
    const queryString = urlParams.toString();
    const endpoint = queryString ? `/inspections?${queryString}` : '/inspections';
    return client.get(endpoint);
  },
  create: (data: any): Promise<Inspection> => client.post('/inspections', data),
};
