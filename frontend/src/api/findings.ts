import { client } from './client';
import { Finding } from '../types';

export const findingsApi = {
  getAll: (): Promise<Finding[]> => client.get('/findings'),
};
