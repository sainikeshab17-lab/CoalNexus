import { client } from './client';
import { Mine } from '../types';

export interface MineFilters {
  skip?: number;
  limit?: number;
  state?: string;
  district?: string;
  owner_code?: string;
  owner?: string;
  mine_type?: string;
  ownership_type?: string;
  commodity?: string;
  status?: string;
  search?: string;
  sort_by?: string;
  sort_order?: 'asc' | 'desc';
}

export const minesApi = {
  getAll: (filters?: MineFilters): Promise<Mine[]> => {
    const params = new URLSearchParams();
    if (filters) {
      if (filters.skip !== undefined) params.set('skip', String(filters.skip));
      if (filters.limit !== undefined) params.set('limit', String(filters.limit));
      if (filters.state) params.set('state', filters.state);
      if (filters.district) params.set('district', filters.district);
      if (filters.owner_code) params.set('owner_code', filters.owner_code);
      if (filters.owner) params.set('owner', filters.owner);
      if (filters.mine_type) params.set('mine_type', filters.mine_type);
      if (filters.ownership_type) params.set('ownership_type', filters.ownership_type);
      if (filters.commodity) params.set('commodity', filters.commodity);
      if (filters.status) params.set('status', filters.status);
      if (filters.search) params.set('search', filters.search);
      if (filters.sort_by) params.set('sort_by', filters.sort_by);
      if (filters.sort_order) params.set('sort_order', filters.sort_order);
    }
    const queryString = params.toString();
    const endpoint = queryString ? `/public/mines?${queryString}` : '/public/mines';
    return client.get(endpoint);
  },
  getById: (id: string): Promise<Mine> => client.get(`/mines/${id}`),
};
