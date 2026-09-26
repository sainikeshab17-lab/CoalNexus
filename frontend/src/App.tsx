import React, { useEffect, useState } from 'react';
import { Layout, Shield, Activity, Map as MapIcon, AlertTriangle, FileCheck } from 'lucide-react';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';

function App() {
  const [health, setHealth] = useState<any>(null);

  useEffect(() => {
    fetch(`${API_URL}/health`)
      .then(res => res.json())
      .then(data => setHealth(data))
      .catch(err => console.error("Health check failed", err));
  }, []);

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col">
      <header className="bg-slate-900 text-white p-4 shadow-lg flex justify-between items-center">
        <div className="flex items-center gap-2">
          <Shield className="text-blue-400" />
          <h1 className="text-xl font-bold">CoalNexus Dashboard</h1>
        </div>
        <div className="flex gap-4">
          <span className={`px-2 py-1 rounded text-xs ${health?.status === 'ok' ? 'bg-green-500' : 'bg-red-500'}`}>
            API: {health?.status || 'connecting...'}
          </span>
        </div>
      </header>

      <div className="flex flex-1">
        <aside className="w-64 bg-white border-r p-4 hidden md:block">
          <nav className="space-y-2">
            <NavItem icon={<Activity size={20}/>} label="Overview" active />
            <NavItem icon={<MapIcon size={20}/>} label="Mine Risk Map" />
            <NavItem icon={<FileCheck size={20}/>} label="Inspections" />
            <NavItem icon={<AlertTriangle size={20}/>} label="Violations" />
          </nav>
        </aside>

        <main className="flex-1 p-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
            <StatCard title="Total Mines" value="3" color="blue" />
            <StatCard title="Active Risks" value="12" color="red" />
            <StatCard title="Open Inspections" value="5" color="orange" />
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h2 className="text-lg font-semibold mb-4">Operational Status (WCL Region)</h2>
            <div className="h-64 flex items-center justify-center bg-slate-100 rounded border-dashed border-2">
              <p className="text-slate-500">GIS Visualization Placeholder (WCL Umrer, Majri, Ballarpur)</p>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}

function NavItem({ icon, label, active = false }: { icon: React.ReactNode, label: string, active?: boolean }) {
  return (
    <div className={`flex items-center gap-3 p-2 rounded-lg cursor-pointer transition-colors ${active ? 'bg-blue-50 text-blue-700' : 'hover:bg-slate-50'}`}>
      {icon}
      <span className="font-medium">{label}</span>
    </div>
  );
}

function StatCard({ title, value, color }: { title: string, value: string, color: string }) {
  const colors: Record<string, string> = {
    blue: 'border-l-blue-500',
    red: 'border-l-red-500',
    orange: 'border-l-orange-500'
  };
  return (
    <div className={`bg-white p-4 rounded-xl shadow-sm border border-l-4 ${colors[color]}`}>
      <p className="text-slate-500 text-sm">{title}</p>
      <p className="text-2xl font-bold">{value}</p>
    </div>
  );
}

export default App;
