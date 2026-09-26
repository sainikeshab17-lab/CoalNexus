import { client } from './client';
import { Violation } from '../types';

export const violationsApi = {
  getAll: (): Promise<Violation[]> => client.get('/violations'),
};
