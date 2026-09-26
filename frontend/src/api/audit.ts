import { client } from './client';
import { AuditTrail } from '../types';

export const auditApi = {
  getAll: (): Promise<AuditTrail[]> => client.get('/audit-trail'),
};
