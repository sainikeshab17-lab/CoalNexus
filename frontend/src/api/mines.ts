import { client } from './client';
import { Mine } from '../types';

export const minesApi = {
  getAll: (): Promise<Mine[]> => client.get('/mines'),
  getById: (id: string): Promise<Mine> => client.get(`/mines/${id}`),
};
