import { client } from './client';
import { Mine } from '../types';

export const minesApi = {
  getAll: (): Promise<Mine[]> => client.get('/mines?skip=0&limit=500'),
  getById: (id: string): Promise<Mine> => client.get(`/mines/${id}`),
};
