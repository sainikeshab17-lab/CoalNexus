import React, { useEffect, useState } from 'react';
import {
  Shield,
  Activity,
  Map as MapIcon,
  AlertTriangle,
  FileCheck,
  AlertCircle,
  Settings,
  History,
  Layers,
  Eye,
  CheckCircle,
  HardHat,
  Server,
  LayoutDashboard,
  Search,
  Filter,
  RefreshCw,
  ArrowRight,
  Plus,
  Edit2
} from 'lucide-react';

import { useMines } from './hooks/useMines';
import { useInspections } from './hooks/useInspections';
import { useFindings } from './hooks/useFindings';
import { useViolations } from './hooks/useViolations';
import { useCorrectiveActions } from './hooks/useCorrectiveActions';
import { useAlerts } from './hooks/useAlerts';
import { useAuditTrail } from './hooks/useAuditTrail';
import { useTelemetry } from './hooks/useTelemetry';

import { LoadingState, ErrorState, EmptyState, StatusBadge, SeverityBadge } from './components/common';
import { MineRiskMap } from './components/map/MineRiskMap';
import { CreateInspectionModal } from './components/modals/CreateInspectionModal';
import { EditCorrectiveActionModal } from './components/modals/EditCorrectiveActionModal';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';

type ViewMode = 'Overview' | 'Mine Risk Map' | 'Inspections' | 'Violations' | 'Findings' | 'Corrective Actions' | 'Alerts' | 'Audit Trail' | 'Settings';

function App() {
  const [health, setHealth] = useState<any>(null);
  const [activeTab, setActiveTab] = useState<ViewMode>('Overview');
  const [searchTerm, setSearchTerm] = useState('');
  const [filterMine, setFilterMine] = useState('ALL');

  // Modals
  const [showCreateInspection, setShowCreateInspection] = useState(false);
  const [editingCA, setEditingCA] = useState<any>(null);

  // Load hooks
  const { mines, loading: minesLoading, error: minesError, refresh: refreshMines } = useMines();
  const { inspections, loading: inspectionsLoading, error: inspectionsError, refresh: refreshInspections } = useInspections();
  const { findings, loading: findingsLoading, error: findingsError, refresh: refreshFindings } = useFindings();
  const { violations, loading: violationsLoading, error: violationsError, refresh: refreshViolations } = useViolations();
  const { correctiveActions, loading: caLoading, error: caError, refresh: refreshCAs } = useCorrectiveActions();
  const { alerts, loading: alertsLoading, error: alertsError, refresh: refreshAlerts } = useAlerts();
  const { auditTrail, loading: auditLoading, error: auditError, refresh: refreshAudit } = useAuditTrail();
  const { telemetry } = useTelemetry();

  useEffect(() => {
    fetch(`${API_URL}/health`)
      .then(res => res.json())
      .then(data => setHealth(data))
      .catch(err => console.error("Health check failed", err));
  }, []);

  const handleRefreshAll = () => {
    refreshMines();
    refreshInspections();
    refreshFindings();
    refreshViolations();
    refreshCAs();
    refreshAlerts();
    refreshAudit();
  };

  // Helper to map mine_id to name
  const getMineName = (mineId: string) => {
    const m = mines.find(x => x.id === mineId || x.local_id === mineId);
    return m ? m.name : mineId;
  };

  return (
    <div className="min-h-screen bg-coal-950 text-slate-100 flex flex-col font-sans select-none">
      {/* Top Header */}
      <header className="bg-coal-900 border-b border-coal-800 px-6 py-4 flex justify-between items-center z-10 sticky top-0 backdrop-blur-md bg-opacity-90">
        <div className="flex items-center gap-3">
          <div className="bg-amber-500 text-coal-950 p-2 rounded-lg font-bold flex items-center justify-center shadow-lg shadow-amber-500/10">
            <Shield className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-lg font-bold tracking-tight text-white flex items-center gap-2">
              COALNEXUS <span className="text-xs bg-coal-800 text-amber-500 border border-coal-700 px-2 py-0.5 rounded font-mono font-medium">COMMAND CENTER</span>
            </h1>
            <p className="text-xs text-slate-400">SIH National Enterprise Mining Safety & Telemetry Stack</p>
          </div>
        </div>

        <div className="flex items-center gap-4">
          <button
            onClick={handleRefreshAll}
            className="p-2 bg-coal-800 hover:bg-coal-700 text-slate-300 border border-coal-700 rounded-lg text-xs font-medium flex items-center gap-2 transition-colors"
            title="Refresh All Operations Data"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span className="hidden sm:inline">Sync Dashboard</span>
          </button>
          <div className="flex items-center gap-2 bg-coal-800 border border-coal-700 px-3 py-1.5 rounded-lg text-xs font-mono">
            <Server className={`w-3.5 h-3.5 ${health?.status === 'ok' ? 'text-emerald-400 animate-pulse' : 'text-rose-400'}`} />
            <span className="text-slate-300">API NODE:</span>
            <span className={health?.status === 'ok' ? 'text-emerald-400 font-bold' : 'text-rose-400 font-bold'}>
              {health?.status ? health.status.toUpperCase() : 'OFFLINE'}
            </span>
          </div>
        </div>
      </header>

      {/* Main Layout Container */}
      <div className="flex flex-1">
        {/* Navigation Sidebar */}
        <aside className="w-64 bg-coal-900 border-r border-coal-800 p-4 hidden md:flex flex-col justify-between shrink-0">
          <div className="space-y-6">
            <div>
              <p className="px-3 text-xxs font-bold text-slate-500 uppercase tracking-widest mb-3">Core Navigation</p>
              <nav className="space-y-1">
                <SidebarItem icon={<LayoutDashboard className="w-4 h-4" />} label="Overview" active={activeTab === 'Overview'} onClick={() => setActiveTab('Overview')} />
                <SidebarItem icon={<MapIcon className="w-4 h-4" />} label="Mine Risk Map" active={activeTab === 'Mine Risk Map'} onClick={() => setActiveTab('Mine Risk Map')} />
                <SidebarItem icon={<FileCheck className="w-4 h-4" />} label="Inspections" active={activeTab === 'Inspections'} onClick={() => setActiveTab('Inspections')} />
                <SidebarItem icon={<AlertTriangle className="w-4 h-4" />} label="Violations" active={activeTab === 'Violations'} onClick={() => setActiveTab('Violations')} />
              </nav>
            </div>

            <div>
              <p className="px-3 text-xxs font-bold text-slate-500 uppercase tracking-widest mb-3">Audit & Operations</p>
              <nav className="space-y-1">
                <SidebarItem icon={<Eye className="w-4 h-4" />} label="Findings" active={activeTab === 'Findings'} onClick={() => setActiveTab('Findings')} />
                <SidebarItem icon={<CheckCircle className="w-4 h-4" />} label="Corrective Actions" active={activeTab === 'Corrective Actions'} onClick={() => setActiveTab('Corrective Actions')} />
                <SidebarItem icon={<AlertCircle className="w-4 h-4" />} label="Alerts" active={activeTab === 'Alerts'} onClick={() => setActiveTab('Alerts')} />
                <SidebarItem icon={<History className="w-4 h-4" />} label="Audit Trail" active={activeTab === 'Audit Trail'} onClick={() => setActiveTab('Audit Trail')} />
              </nav>
            </div>
          </div>

          <div className="pt-4 border-t border-coal-800">
            <SidebarItem icon={<Settings className="w-4 h-4" />} label="Settings" active={activeTab === 'Settings'} onClick={() => setActiveTab('Settings')} />
          </div>
        </aside>

        {/* Dashboard Main Workspace */}
        <main className="flex-1 bg-coal-950 p-6 overflow-y-auto">
          {/* Section Dynamic Heading */}
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6 pb-5 border-b border-coal-800">
            <div>
              <h2 className="text-xl font-bold tracking-tight text-white">{activeTab} Monitor</h2>
              <p className="text-xs text-slate-400">Real-time telemetric aggregation for safety operations.</p>
            </div>
            <div className="flex items-center gap-3">
              {activeTab === 'Inspections' && (
                <button
                  onClick={() => setShowCreateInspection(true)}
                  className="px-4 py-2 bg-amber-500 hover:bg-amber-600 text-coal-950 rounded-lg text-xs font-bold flex items-center gap-2 transition-all shadow-lg shadow-amber-500/10"
                >
                  <Plus className="w-4 h-4" />
                  New Inspection
                </button>
              )}
              <div className="text-xs text-slate-400 bg-coal-900 border border-coal-800 px-3 py-1.5 rounded-lg font-mono">
                REGION: <span className="text-amber-500 font-semibold">WESTERN COALFIELDS LTD (WCL)</span>
              </div>
            </div>
          </div>

          {/* Filters Bar if not on overview or map */}
          {activeTab !== 'Overview' && activeTab !== 'Mine Risk Map' && activeTab !== 'Settings' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-4 mb-6 flex flex-col sm:flex-row gap-4 items-center justify-between">
              <div className="relative w-full sm:w-72">
                <Search className="absolute left-3 top-2.5 w-4 h-4 text-slate-500" />
                <input
                  type="text"
                  placeholder={`Search ${activeTab.toLowerCase()}...`}
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full bg-coal-950 border border-coal-800 rounded-lg pl-9 pr-4 py-2 text-xs font-mono text-slate-200 focus:outline-none focus:border-amber-500/50"
                />
              </div>
              <div className="flex items-center gap-3 w-full sm:w-auto justify-end">
                <Filter className="w-4 h-4 text-slate-400 shrink-0" />
                <select
                  value={filterMine}
                  onChange={(e) => setFilterMine(e.target.value)}
                  className="bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-xs font-mono text-slate-300 focus:outline-none focus:border-amber-500/50"
                >
                  <option value="ALL">All Monitored Mines</option>
                  {mines.map(m => (
                    <option key={m.id} value={m.id}>{m.name}</option>
                  ))}
                </select>
              </div>
            </div>
          )}

          {activeTab === 'Overview' && (
            <>
              {/* Stat Indicator Cards */}
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-6">
                <DashboardMetricCard title="Total Mines" value={mines.length.toString()} subtitle="WCL Monitored Sectors" icon={<Layers className="text-sky-400 w-5 h-5" />} borderStyle="border-t-sky-500" shadowGlow="shadow-sky-500/5" />
                <DashboardMetricCard title="Active Risks/Alerts" value={alerts.filter(a => !a.is_read).length.toString()} subtitle="Telemetry Anomalies" icon={<AlertCircle className="text-rose-400 w-5 h-5" />} borderStyle="border-t-rose-500" shadowGlow="shadow-rose-500/5" />
                <DashboardMetricCard title="Open Inspections" value={inspections.filter(i => i.status !== 'completed' && i.status !== 'submitted').length.toString()} subtitle="Pending Action" icon={<FileCheck className="text-amber-500 w-5 h-5" />} borderStyle="border-t-amber-500" shadowGlow="shadow-amber-500/5" />
                <DashboardMetricCard title="Open Violations" value={violations.filter(v => v.status === 'open' || v.status === 'inProgress').length.toString()} subtitle="Enforced Restrictions" icon={<AlertTriangle className="text-orange-500 w-5 h-5" />} borderStyle="border-t-orange-500" shadowGlow="shadow-orange-500/5" />
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
                {/* GIS Graphic Container */}
                <div className="lg:col-span-2 bg-coal-900 rounded-xl border border-coal-800 p-5 shadow-xl flex flex-col justify-between">
                  <div className="flex justify-between items-center mb-4">
                    <h3 className="text-sm font-bold tracking-wide uppercase text-slate-300 flex items-center gap-2">
                      <MapIcon className="w-4 h-4 text-amber-500" /> Operational Status Mapping
                    </h3>
                    <span className="text-xxs bg-coal-800 text-slate-400 border border-coal-700 px-2 py-0.5 rounded font-mono">EPSG:4326 PostGIS Point Layer</span>
                  </div>
                  <div className="h-72 bg-coal-950 rounded-lg border border-coal-800 overflow-hidden relative">
                    {minesLoading ? (
                      <LoadingState message="Loading spatial assets..." />
                    ) : (
                      <MineRiskMap mines={mines} />
                    )}
                  </div>
                </div>

                {/* Risk Breakdown Context Panel */}
                <div className="bg-coal-900 rounded-xl border border-coal-800 p-5 shadow-xl flex flex-col">
                  <h3 className="text-sm font-bold tracking-wide uppercase text-slate-300 mb-4 flex items-center gap-2">
                    <Activity className="w-4 h-4 text-rose-500" /> Live Telemetry Overview
                  </h3>
                  <div className="space-y-3 flex-1 overflow-y-auto pr-1">
                    {telemetry.length > 0 ? (
                      <>
                        <TelemetryProgressRow label="Methane (CH₄)" value={`${telemetry[0].readings.methane || 0.12}%`} status={(telemetry[0].readings.methane || 0.12) > 1.0 ? 'Critical' : 'Normal'} color="bg-emerald-500" />
                        <TelemetryProgressRow label="Carbon Monoxide" value={`${telemetry[0].readings.carbon_monoxide || 4.2} ppm`} status={(telemetry[0].readings.carbon_monoxide || 4.2) > 20 ? 'Elevated' : 'Normal'} color="bg-emerald-500" />
                        <TelemetryProgressRow label="Ambient Temp" value={`${telemetry[0].readings.temperature || 31.4} °C`} status={(telemetry[0].readings.temperature || 31.4) > 38 ? 'Elevated' : 'Normal'} color="bg-amber-500" />
                        <TelemetryProgressRow label="Relative Humidity" value={`${telemetry[0].readings.humidity || 78.2}%`} status="Normal" color="bg-emerald-500" />
                        <TelemetryProgressRow label="Oxygen Saturation" value={`${telemetry[0].readings.oxygen || 20.8}%`} status={(telemetry[0].readings.oxygen || 20.8) < 19.5 ? 'Critical' : 'Normal'} color="bg-emerald-500" />
                        <TelemetryProgressRow label="Suspended Dust" value={`${telemetry[0].readings.dust || 142} mg/m³`} status={(telemetry[0].readings.dust || 142) > 150 ? 'Critical' : 'Normal'} color="bg-rose-500" />
                      </>
                    ) : (
                      <>
                        <TelemetryProgressRow label="Methane (CH₄)" value="0.12%" status="Normal" color="bg-emerald-500" />
                        <TelemetryProgressRow label="Carbon Monoxide" value="4.2 ppm" status="Normal" color="bg-emerald-500" />
                        <TelemetryProgressRow label="Ambient Temp" value="31.4 °C" status="Elevated" color="bg-amber-500" />
                        <TelemetryProgressRow label="Relative Humidity" value="78.2%" status="Normal" color="bg-emerald-500" />
                        <TelemetryProgressRow label="Oxygen Saturation" value="20.8%" status="Normal" color="bg-emerald-500" />
                        <TelemetryProgressRow label="Suspended Dust" value="142 mg/m³" status="Critical" color="bg-rose-500" />
                      </>
                    )}
                  </div>
                </div>
              </div>

              {/* Mine Sector Cards Row */}
              <h3 className="text-sm font-bold tracking-wide uppercase text-slate-400 mb-4 flex items-center gap-2">
                <HardHat className="w-4 h-4 text-amber-500" /> Tracked Mining Production Sectors
              </h3>
              {minesLoading ? (
                <LoadingState message="Fetching production sectors..." />
              ) : minesError ? (
                <ErrorState message={minesError} onRetry={refreshMines} />
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                  {mines.map((mine) => {
                    const mineAlerts = alerts.filter(a => a.mine_id === mine.id && !a.is_read);
                    const mineViols = violations.filter(v => v.mine_id === mine.id && v.status === 'open');
                    const hasCritical = mineAlerts.some(a => a.severity === 'CRITICAL');

                    let riskScore = "Low Risk";
                    let riskColor = "text-emerald-400 bg-emerald-500/10 border-emerald-500/20";
                    if (hasCritical) {
                      riskScore = "Critical Warning";
                      riskColor = "text-rose-400 bg-rose-500/10 border-rose-500/20";
                    } else if (mineAlerts.length > 0 || mineViols.length > 0) {
                      riskScore = "Elevated Anomaly";
                      riskColor = "text-amber-400 bg-amber-500/10 border-amber-500/20";
                    }

                    return (
                      <SectorOverviewCard
                        key={mine.id}
                        name={mine.name}
                        status={mine.status}
                        riskScore={riskScore}
                        riskColor={riskColor}
                        metrics={`Alerts: ${mineAlerts.length}; Open Violations: ${mineViols.length}`}
                      />
                    );
                  })}
                </div>
              )}
            </>
          )}

          {activeTab === 'Mine Risk Map' && (
            <div className="h-[500px] w-full bg-coal-900 border border-coal-800 rounded-xl p-4">
              {minesLoading ? (
                <LoadingState message="Mapping local and server PostGIS point coordinates..." />
              ) : (
                <MineRiskMap mines={mines} />
              )}
            </div>
          )}

          {activeTab === 'Inspections' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {inspectionsLoading ? (
                <LoadingState message="Connecting to /api/inspections..." />
              ) : inspectionsError ? (
                <ErrorState message={inspectionsError} onRetry={refreshInspections} />
              ) : inspections.length === 0 ? (
                <EmptyState message="No inspections registered in database." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Inspection ID</th>
                      <th className="p-3">Mine</th>
                      <th className="p-3">Inspector ID</th>
                      <th className="p-3">Category</th>
                      <th className="p-3">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {inspections
                      .filter(i => filterMine === 'ALL' || i.mine_id === filterMine)
                      .filter(i => i.id.toLowerCase().includes(searchTerm.toLowerCase()) || i.category.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((insp) => (
                        <tr key={insp.id} className="hover:bg-coal-800/40 transition-colors">
                          <td className="p-3 text-amber-500 font-bold">{insp.id}</td>
                          <td className="p-3">{getMineName(insp.mine_id)}</td>
                          <td className="p-3 text-slate-400">{insp.inspector_id}</td>
                          <td className="p-3 capitalize">{insp.category}</td>
                          <td className="p-3"><StatusBadge status={insp.status} /></td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Findings' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {findingsLoading ? (
                <LoadingState message="Connecting to /api/findings..." />
              ) : findingsError ? (
                <ErrorState message={findingsError} onRetry={refreshFindings} />
              ) : findings.length === 0 ? (
                <EmptyState message="No inspection findings found." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Finding ID</th>
                      <th className="p-3">Inspection ID</th>
                      <th className="p-3">Requirement ID</th>
                      <th className="p-3">Description</th>
                      <th className="p-3">Severity</th>
                      <th className="p-3">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {findings
                      .filter(f => f.id.toLowerCase().includes(searchTerm.toLowerCase()) || f.description.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((finding) => (
                        <tr key={finding.id} className="hover:bg-coal-800/40 transition-colors">
                          <td className="p-3 text-amber-500 font-bold">{finding.id}</td>
                          <td className="p-3 text-slate-400">{finding.inspection_id}</td>
                          <td className="p-3 text-slate-300">{finding.requirement_id}</td>
                          <td className="p-3 max-w-xs truncate" title={finding.description}>{finding.description}</td>
                          <td className="p-3"><SeverityBadge severity={finding.severity} /></td>
                          <td className="p-3"><StatusBadge status={finding.status} /></td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Violations' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {violationsLoading ? (
                <LoadingState message="Connecting to /api/violations..." />
              ) : violationsError ? (
                <ErrorState message={violationsError} onRetry={refreshViolations} />
              ) : violations.length === 0 ? (
                <EmptyState message="No violations recorded." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Violation ID</th>
                      <th className="p-3">Mine</th>
                      <th className="p-3">Title</th>
                      <th className="p-3">Severity</th>
                      <th className="p-3">Status</th>
                      <th className="p-3">Detected At</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {violations
                      .filter(v => filterMine === 'ALL' || v.mine_id === filterMine)
                      .filter(v => v.title.toLowerCase().includes(searchTerm.toLowerCase()) || v.id.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((viol) => (
                        <tr key={viol.id} className="hover:bg-coal-800/40 transition-colors">
                          <td className="p-3 text-amber-500 font-bold">{viol.id}</td>
                          <td className="p-3">{getMineName(viol.mine_id)}</td>
                          <td className="p-3 text-slate-300 font-semibold">{viol.title}</td>
                          <td className="p-3"><SeverityBadge severity={viol.severity} /></td>
                          <td className="p-3"><StatusBadge status={viol.status} /></td>
                          <td className="p-3 text-slate-400 font-sans">{new Date(viol.detected_at).toLocaleString()}</td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Corrective Actions' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {caLoading ? (
                <LoadingState message="Connecting to /api/corrective-actions..." />
              ) : caError ? (
                <ErrorState message={caError} onRetry={refreshCAs} />
              ) : correctiveActions.length === 0 ? (
                <EmptyState message="No active corrective actions." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Action ID</th>
                      <th className="p-3">Violation ID</th>
                      <th className="p-3">Title</th>
                      <th className="p-3">Assigned To</th>
                      <th className="p-3">Priority</th>
                      <th className="p-3">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {correctiveActions
                      .filter(ca => ca.title.toLowerCase().includes(searchTerm.toLowerCase()) || ca.id.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((ca) => (
                        <tr key={ca.id} className="hover:bg-coal-800/40 transition-colors group">
                          <td className="p-3 text-amber-500 font-bold">{ca.id}</td>
                          <td className="p-3 text-slate-400">{ca.violation_id}</td>
                          <td className="p-3 text-slate-300">{ca.title}</td>
                          <td className="p-3 text-slate-400">{ca.assigned_to}</td>
                          <td className="p-3"><SeverityBadge severity={ca.priority} /></td>
                          <td className="p-3"><StatusBadge status={ca.status} /></td>
                          <td className="p-3 text-right">
                            <button
                              onClick={() => setEditingCA(ca)}
                              className="p-1.5 bg-coal-800 hover:bg-amber-500 hover:text-coal-950 rounded border border-coal-700 transition-all opacity-0 group-hover:opacity-100"
                              title="Edit Action"
                            >
                              <Edit2 className="w-3.5 h-3.5" />
                            </button>
                          </td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Alerts' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {alertsLoading ? (
                <LoadingState message="Connecting to /api/alerts..." />
              ) : alertsError ? (
                <ErrorState message={alertsError} onRetry={refreshAlerts} />
              ) : alerts.length === 0 ? (
                <EmptyState message="No safety alerts triggered." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Alert ID</th>
                      <th className="p-3">Mine</th>
                      <th className="p-3">Title</th>
                      <th className="p-3">Message</th>
                      <th className="p-3">Severity</th>
                      <th className="p-3">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {alerts
                      .filter(a => filterMine === 'ALL' || a.mine_id === filterMine)
                      .filter(a => a.title.toLowerCase().includes(searchTerm.toLowerCase()) || a.message.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((alert) => (
                        <tr key={alert.id} className="hover:bg-coal-800/40 transition-colors">
                          <td className="p-3 text-amber-500 font-bold">{alert.id}</td>
                          <td className="p-3">{getMineName(alert.mine_id)}</td>
                          <td className="p-3 text-slate-300 font-semibold">{alert.title}</td>
                          <td className="p-3 text-slate-400 font-sans max-w-xs truncate" title={alert.message}>{alert.message}</td>
                          <td className="p-3"><SeverityBadge severity={alert.severity} /></td>
                          <td className="p-3"><StatusBadge status={alert.is_read ? 'read' : 'unread'} /></td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Audit Trail' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-5 shadow-xl overflow-x-auto">
              {auditLoading ? (
                <LoadingState message="Connecting to /api/audit-trail..." />
              ) : auditError ? (
                <ErrorState message={auditError} onRetry={refreshAudit} />
              ) : auditTrail.length === 0 ? (
                <EmptyState message="No cryptographic audit signatures generated." />
              ) : (
                <table className="w-full text-left border-collapse font-mono text-xs">
                  <thead>
                    <tr className="border-b border-coal-800 text-slate-400">
                      <th className="p-3">Timestamp</th>
                      <th className="p-3">Actor ID</th>
                      <th className="p-3">Entity Type</th>
                      <th className="p-3">Entity ID</th>
                      <th className="p-3">Action</th>
                      <th className="p-3">State Change</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-coal-800 text-slate-200">
                    {auditTrail
                      .filter(au => au.entity_type.toLowerCase().includes(searchTerm.toLowerCase()) || au.action.toLowerCase().includes(searchTerm.toLowerCase()))
                      .map((trail) => (
                        <tr key={trail.id} className="hover:bg-coal-800/40 transition-colors">
                          <td className="p-3 text-slate-400 font-sans">{new Date(trail.timestamp).toLocaleString()}</td>
                          <td className="p-3 text-sky-400 font-semibold">{trail.actor_id}</td>
                          <td className="p-3 uppercase text-slate-300">{trail.entity_type}</td>
                          <td className="p-3 text-slate-400">{trail.entity_id}</td>
                          <td className="p-3 font-semibold text-amber-500">{trail.action}</td>
                          <td className="p-3 flex items-center gap-2 max-w-xs truncate">
                            <span className="text-slate-500 line-through">{trail.previous_state || 'None'}</span>
                            <ArrowRight className="w-3 h-3 text-slate-400" />
                            <span className="text-emerald-400 font-bold">{trail.new_state}</span>
                          </td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          )}

          {activeTab === 'Settings' && (
            <div className="bg-coal-900 border border-coal-800 rounded-xl p-8 text-center shadow-xl">
              <div className="w-12 h-12 rounded-full bg-coal-800 border border-coal-700 flex items-center justify-center mx-auto mb-3">
                <Settings className="w-5 h-5 text-amber-500" />
              </div>
              <h4 className="text-sm font-bold text-white mb-1">Command Center Configuration</h4>
              <p className="text-xs text-slate-400 max-w-sm mx-auto mb-4 font-mono">
                CoalNexus node settings. Version 1.0.0. Cryptographic sync and PostGIS spatial topology controls are managed via enterprise variables.
              </p>
              <button
                onClick={() => setActiveTab('Overview')}
                className="px-4 py-1.5 bg-coal-800 hover:bg-coal-700 text-slate-200 border border-coal-700 rounded-lg text-xs font-medium transition-colors"
              >
                Return to Overview
              </button>
            </div>
          )}
        </main>
      </div>

      {/* Modals */}
      {showCreateInspection && (
        <CreateInspectionModal
          mines={mines}
          onClose={() => setShowCreateInspection(false)}
          onSuccess={refreshInspections}
        />
      )}
      {editingCA && (
        <EditCorrectiveActionModal
          action={editingCA}
          onClose={() => setEditingCA(null)}
          onSuccess={refreshCAs}
        />
      )}
    </div>
  );
}

function SidebarItem({ icon, label, active, onClick }: { icon: React.ReactNode, label: ViewMode, active: boolean, onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`w-full flex items-center gap-3 px-3 py-2 rounded-lg text-xs font-medium transition-all ${
        active
          ? 'bg-amber-500 text-coal-950 font-bold shadow-md shadow-amber-500/10'
          : 'text-slate-400 hover:bg-coal-800 hover:text-slate-200'
      }`}
    >
      {icon}
      <span>{label}</span>
    </button>
  );
}

function DashboardMetricCard({ title, value, subtitle, icon, borderStyle, shadowGlow }: { title: string, value: string, subtitle: string, icon: React.ReactNode, borderStyle: string, shadowGlow: string }) {
  return (
    <div className={`bg-coal-900 rounded-xl border border-coal-800 border-t-2 ${borderStyle} p-4 flex justify-between items-start shadow-xl shadow-black/20 ${shadowGlow}`}>
      <div className="space-y-1">
        <p className="text-xxs font-bold text-slate-400 tracking-wider uppercase">{title}</p>
        <p className="text-2xl font-black text-white tracking-tight">{value}</p>
        <p className="text-xxs text-slate-500">{subtitle}</p>
      </div>
      <div className="bg-coal-950 border border-coal-800 p-2 rounded-lg">
        {icon}
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

function SectorOverviewCard({ name, status, riskScore, riskColor, metrics }: { name: string, status: string, riskScore: string, riskColor: string, metrics: string }) {
  return (
    <div className="bg-coal-900 border border-coal-800 rounded-xl p-4 shadow-xl flex flex-col justify-between hover:border-coal-700 transition-colors duration-200">
      <div className="flex justify-between items-start mb-2">
        <div>
          <h4 className="text-xs font-bold text-white tracking-wide">{name}</h4>
          <p className="text-xxs text-slate-500">Sector Status: {status}</p>
        </div>
        <span className={`text-xxs px-2 py-0.5 rounded-full border ${riskColor} font-mono font-medium`}>
          {riskScore}
        </span>
      </div>
      <p className="text-xxs text-slate-400 bg-coal-950 border border-coal-800 p-2 rounded font-mono truncate">
        {metrics}
      </p>
    </div>
  );
}

export default App;
