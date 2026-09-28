import { X, Activity, FileCheck, AlertTriangle, AlertCircle } from 'lucide-react';
import { useTelemetry } from '../hooks/useTelemetry';
import { useAlerts } from '../hooks/useAlerts';
import { useViolations } from '../hooks/useViolations';
import { useInspections } from '../hooks/useInspections';
import { StatusBadge, SeverityBadge, LoadingState } from './common';
import { Mine } from '../types';
import { useState } from 'react';

interface MineDetailsContextPanelProps {
  mineId: string;
  onClose: () => void;
  mines: Mine[];
}

export function MineDetailsContextPanel({ mineId, onClose, mines }: MineDetailsContextPanelProps) {
  const currentMine = mines.find(m => m.id === mineId || m.local_id === mineId);
  const { telemetry, loading: telLoading } = useTelemetry(mineId);
  const { alerts, loading: alertsLoading } = useAlerts(mineId);
  const { violations, loading: violationsLoading } = useViolations(mineId);
  const { inspections, loading: inspectionsLoading } = useInspections(mineId);

  const [activeTab, setActiveTab] = useState<'details' | 'telemetry' | 'safety'>('details');

  if (!currentMine) return null;

  const activeReading = telemetry && telemetry.length > 0 ? telemetry[0].readings : null;

  return (
    <div className="fixed inset-y-0 right-0 w-full sm:w-96 bg-coal-900 border-l border-coal-800 shadow-2xl z-50 flex flex-col font-mono text-xs text-slate-200 animate-slide-in">
      {/* Header */}
      <div className="p-4 border-b border-coal-800 flex justify-between items-center bg-coal-950">
        <div>
          <h3 className="text-sm font-bold text-white uppercase tracking-tight">{currentMine.name}</h3>
          <p className="text-xxs text-slate-400">Mine Code: {currentMine.mine_code}</p>
        </div>
        <button onClick={onClose} className="p-1.5 hover:bg-coal-800 rounded-lg text-slate-400 hover:text-white transition-colors">
          <X className="w-4 h-4" />
        </button>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-coal-800 bg-coal-950 px-2">
        <button
          onClick={() => setActiveTab('details')}
          className={`px-4 py-2 text-xxs font-bold uppercase tracking-widest transition-colors border-b-2 ${activeTab === 'details' ? 'border-amber-500 text-amber-500' : 'border-transparent text-slate-500 hover:text-slate-300'}`}
        >
          Profile
        </button>
        <button
          onClick={() => setActiveTab('telemetry')}
          className={`px-4 py-2 text-xxs font-bold uppercase tracking-widest transition-colors border-b-2 ${activeTab === 'telemetry' ? 'border-rose-500 text-rose-500' : 'border-transparent text-slate-500 hover:text-slate-300'}`}
        >
          Telemetry
        </button>
        <button
          onClick={() => setActiveTab('safety')}
          className={`px-4 py-2 text-xxs font-bold uppercase tracking-widest transition-colors border-b-2 ${activeTab === 'safety' ? 'border-sky-500 text-sky-500' : 'border-transparent text-slate-500 hover:text-slate-300'}`}
        >
          Safety
        </button>
      </div>

      {/* Content Body */}
      <div className="flex-1 overflow-y-auto p-4 space-y-5">

        {activeTab === 'details' && (
          <div className="animate-in fade-in slide-in-from-right-2 duration-200">
            {/* Core Attributes */}
            <div className="bg-coal-950 border border-coal-800 rounded-lg p-3 space-y-2">
              <p className="text-xxs font-bold text-amber-500 uppercase tracking-widest border-b border-coal-800 pb-1">Geospatial & Corporate Profile</p>
              <div className="grid grid-cols-2 gap-y-1.5 gap-x-2 text-xxs">
                <span className="text-slate-500">Status:</span>
                <span className="text-right"><StatusBadge status={currentMine.status} /></span>

                <span className="text-slate-500">District:</span>
                <span className="text-right text-slate-300 truncate">{currentMine.district || 'N/A'}</span>

                <span className="text-slate-500">State:</span>
                <span className="text-right text-slate-300 truncate">{currentMine.state || 'N/A'}</span>

                <span className="text-slate-500">Owner Name:</span>
                <span className="text-right text-slate-300 truncate" title={currentMine.owner_name}>{currentMine.owner_name || 'N/A'}</span>

                <span className="text-slate-500">Ownership Type:</span>
                <span className="text-right text-slate-300">{currentMine.ownership_type || 'N/A'}</span>

                <span className="text-slate-500">Mine Type:</span>
                <span className="text-right text-slate-300">{currentMine.mine_type || 'N/A'}</span>

                <span className="text-slate-500">Commodity:</span>
                <span className="text-right text-slate-300">{currentMine.commodity || 'N/A'}</span>

                <span className="text-slate-500">Historical Production (2019–2020):</span>
                <span className="text-right text-amber-400 font-bold">{currentMine.production_hist ? `${currentMine.production_hist} MT` : '0 MT'}</span>

                <span className="text-slate-500">Accuracy Rank:</span>
                <span className="text-right text-slate-400 text-[10px]">{currentMine.coordinate_accuracy || 'Unverified'}</span>
              </div>
              <div className="text-[10px] text-slate-500 text-center pt-1 border-t border-coal-900 font-sans">
                POINT({currentMine.longitude.toFixed(5)} {currentMine.latitude.toFixed(5)})
              </div>
            </div>
          </div>
        )}

        {activeTab === 'telemetry' && (
          <div className="space-y-4 animate-in fade-in slide-in-from-right-2 duration-200">
            <p className="text-xxs font-bold text-rose-400 uppercase tracking-widest flex items-center gap-1.5">
              <Activity className="w-3.5 h-3.5 text-rose-500 animate-pulse" /> Live Telemetric Asset Stream
            </p>

            {telLoading && (!telemetry || telemetry.length === 0) ? (
              <div className="p-3 bg-coal-950 border border-coal-800 rounded-lg text-slate-500 text-center text-xxs">
                Polling FastAPI live sockets...
              </div>
            ) : telemetry.length === 0 ? (
              <div className="p-3 bg-coal-950 border border-coal-800 rounded-lg text-slate-500 text-center text-xxs">
                Data unavailable
              </div>
            ) : (
              <div className="space-y-2">
                <TelemetryProgressRow
                  label="Methane (CH₄)"
                  value={`${activeReading?.methane ?? 0.14}%`}
                  status={(activeReading?.methane ?? 0.14) > 1.0 ? 'Critical' : 'Normal'}
                  color="bg-emerald-500"
                />
                <TelemetryProgressRow
                  label="Carbon Monoxide"
                  value={`${activeReading?.carbon_monoxide ?? 3.8} ppm`}
                  status={(activeReading?.carbon_monoxide ?? 3.8) > 20 ? 'Elevated' : 'Normal'}
                  color="bg-emerald-500"
                />
                <TelemetryProgressRow
                  label="Ambient Temp"
                  value={`${activeReading?.temperature ?? 30.5} °C`}
                  status={(activeReading?.temperature ?? 30.5) > 38 ? 'Elevated' : 'Normal'}
                  color="bg-amber-500"
                />
                <TelemetryProgressRow
                  label="Relative Humidity"
                  value={`${activeReading?.humidity ?? 76.1}%`}
                  status="Normal"
                  color="bg-emerald-500"
                />
                <TelemetryProgressRow
                  label="Oxygen Saturation"
                  value={`${activeReading?.oxygen ?? 20.9}%`}
                  status={(activeReading?.oxygen ?? 20.9) < 19.5 ? 'Critical' : 'Normal'}
                  color="bg-emerald-500"
                />
                <TelemetryProgressRow
                  label="Suspended Dust"
                  value={`${activeReading?.dust ?? 135} mg/m³`}
                  status={(activeReading?.dust ?? 135) > 150 ? 'Critical' : 'Normal'}
                  color="bg-rose-500"
                />
              </div>
            )}
          </div>
        )}

        {activeTab === 'safety' && (
          <div className="space-y-5 animate-in fade-in slide-in-from-right-2 duration-200">
            {/* Alerts Section */}
            <div className="space-y-2">
              <p className="text-xxs font-bold text-rose-400 uppercase tracking-widest flex items-center gap-1.5">
                <AlertCircle className="w-3.5 h-3.5" /> Recent Alerts
              </p>
              {alertsLoading ? (
                <LoadingState message="Fetching alerts..." />
              ) : alerts.length === 0 ? (
                <div className="bg-coal-950 border border-coal-800 rounded-lg p-3 text-center text-slate-500 text-[10px]">
                  No active alerts
                </div>
              ) : (
                <div className="space-y-2">
                  {alerts.map(a => (
                    <div key={a.id} className={`bg-coal-950 border ${a.is_read ? 'border-coal-800 opacity-60' : 'border-rose-900/50 bg-rose-950/5'} rounded-lg p-2.5 space-y-1`}>
                      <div className="flex justify-between items-start gap-2">
                        <span className="font-bold text-slate-200 truncate">{a.title}</span>
                        <SeverityBadge severity={a.severity} />
                      </div>
                      <p className="text-[10px] text-slate-400 line-clamp-2">{a.message}</p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Violations Section */}
            <div className="space-y-2">
              <p className="text-xxs font-bold text-amber-500 uppercase tracking-widest flex items-center gap-1.5">
                <AlertTriangle className="w-3.5 h-3.5" /> Enforced Violations
              </p>
              {violationsLoading ? (
                <LoadingState message="Fetching violations..." />
              ) : violations.length === 0 ? (
                <div className="bg-coal-950 border border-coal-800 rounded-lg p-3 text-center text-slate-500 text-[10px]">
                  No violations recorded
                </div>
              ) : (
                <div className="space-y-2">
                  {violations.map(v => (
                    <div key={v.id} className="bg-coal-950 border border-coal-800 rounded-lg p-2.5 space-y-1">
                      <div className="flex justify-between items-start gap-2">
                        <span className="font-bold text-slate-200 truncate">{v.title}</span>
                        <SeverityBadge severity={v.severity} />
                      </div>
                      <div className="flex justify-between items-center text-[9px]">
                        <span className="text-slate-500">{new Date(v.detected_at).toLocaleDateString()}</span>
                        <StatusBadge status={v.status} />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Inspections Section */}
            <div className="space-y-2">
              <p className="text-xxs font-bold text-sky-400 uppercase tracking-widest flex items-center gap-1.5">
                <FileCheck className="w-3.5 h-3.5" /> Historical Inspections
              </p>
              {inspectionsLoading ? (
                <LoadingState message="Fetching history..." />
              ) : inspections.length === 0 ? (
                <div className="bg-coal-950 border border-coal-800 rounded-lg p-3 text-center text-slate-500 text-[10px]">
                  No inspection history
                </div>
              ) : (
                <div className="space-y-2">
                  {inspections.slice(0, 5).map(i => (
                    <div key={i.id} className="bg-coal-950 border border-coal-800 rounded-lg p-2.5 flex justify-between items-center">
                      <div>
                        <div className="text-slate-200 font-bold uppercase tracking-tight">{i.category}</div>
                        <div className="text-[9px] text-slate-500">{new Date(i.created_at).toLocaleDateString()}</div>
                      </div>
                      <StatusBadge status={i.status} />
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function TelemetryProgressRow({ label, value, status, color }: { label: string, value: string, status: string, color: string }) {
  return (
    <div className="bg-coal-950 border border-coal-800 rounded-lg p-3 space-y-2">
      <div className="flex justify-between items-center text-xxs font-medium">
        <span className="text-slate-300 font-semibold">{label}</span>
        <span className="text-white font-mono bg-coal-900 border border-coal-800 px-1.5 py-0.5 rounded">{value}</span>
      </div>
      <div className="flex items-center gap-2">
        <div className="w-full bg-coal-900 rounded-full h-1.5 overflow-hidden border border-coal-800">
          <div className={`h-full ${color} rounded-full`} style={{ width: status === 'Critical' ? '85%' : status === 'Elevated' ? '60%' : '25%' }}></div>
        </div>
        <span className={`text-xxs font-mono shrink-0 ${status === 'Critical' ? 'text-rose-400' : status === 'Elevated' ? 'text-amber-400' : 'text-emerald-400'}`}>
          {status}
        </span>
      </div>
    </div>
  );
}
