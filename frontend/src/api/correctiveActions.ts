import { client } from './client';
import { CorrectiveAction } from '../types';

export const correctiveActionsApi = {
  getAll: (): Promise<CorrectiveAction[]> => client.get('/corrective-actions'),
  update: (id: string, data: any): Promise<CorrectiveAction> => client.put(`/corrective-actions/${id}`, data),
};
