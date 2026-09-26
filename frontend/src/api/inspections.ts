import { client } from './client';
import { Inspection } from '../types';

export const inspectionsApi = {
  getAll: (): Promise<Inspection[]> => client.get('/inspections'),
  create: (data: any): Promise<Inspection> => client.post('/inspections', data),
};
