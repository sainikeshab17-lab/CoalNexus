export type MineStatus = 'active' | 'inactive' | 'suspended' | 'underMaintenance';

export interface Mine {
  id: string;
  local_id?: string;
  name: string;
  mine_code: string;
  latitude: number;
  longitude: number;
  status: MineStatus;
  created_at: string;
  updated_at: string;
}

export type InspectionStatus = 'draft' | 'inProgress' | 'completed' | 'findingsGenerated' | 'submitted';

export interface Inspection {
  id: string;
  mine_id: string;
  inspector_id: string;
  status: InspectionStatus;
  category: string;
  created_at: string;
  updated_at: string;
}

export type FindingStatus = 'open' | 'acknowledged' | 'resolved' | 'compliant' | 'nonCompliant' | 'notApplicable';

export interface Finding {
  id: string;
  inspection_id: string;
  requirement_id: string;
  description: string;
  status: FindingStatus;
  severity: string;
  created_at: string;
  updated_at: string;
}

export type ViolationSeverity = 'low' | 'medium' | 'high' | 'critical';
export type ViolationStatus = 'open' | 'resolved' | 'inProgress' | 'closed';

export interface Violation {
  id: string;
  mine_id: string;
  inspection_id: string;
  finding_id: string;
  title: string;
  description: string;
  severity: ViolationSeverity;
  status: ViolationStatus;
  assigned_to?: string;
  due_date?: string;
  detected_at: string;
  created_at: string;
  updated_at: string;
}

export interface Alert {
  id: string;
  mine_id: string;
  title: string;
  message: string;
  severity: string;
  is_read: boolean;
  created_at: string;
}

export interface CorrectiveAction {
  id: string;
  violation_id: string;
  title: string;
  description: string;
  assigned_to: string;
  priority: string;
  due_date: string;
  status: string;
  submitted_at?: string;
  verified_at?: string;
  evidence?: string;
  created_at: string;
  updated_at: string;
}

export interface AuditTrail {
  id: string;
  entity_type: string;
  entity_id: string;
  action: string;
  previous_state?: string;
  new_state: string;
  actor_id: string;
  timestamp: string;
  comment?: string;
  created_at: string;
}

export interface TelemetryReadings {
  methane?: number;
  carbon_monoxide?: number;
  temperature?: number;
  humidity?: number;
  oxygen?: number;
  dust?: number;
  vibration?: number;
}

export interface Telemetry {
  id?: number;
  mine_id: string;
  device_id: string;
  timestamp: string;
  readings: TelemetryReadings;
}
