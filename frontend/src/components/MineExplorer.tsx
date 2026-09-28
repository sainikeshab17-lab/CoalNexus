import { useState, useEffect } from 'react';
import { Search, Filter, ArrowUp, ArrowDown, ChevronLeft, ChevronRight, RefreshCw, Layers } from 'lucide-react';
import { useMines } from '../hooks/useMines';
import { MineFilters } from '../api/mines';
import { LoadingState, ErrorState, EmptyState, StatusBadge } from './common';
import { MineDetailsContextPanel } from './MineDetailsContextPanel';

export function MineExplorer() {
  const [filters, setFilters] = useState<MineFilters>({
    skip: 0,
    limit: 25,
    status: 'active',
    sort_by: 'name',
    sort_order: 'asc'
  });

  const [debouncedSearch, setDebouncedSearch] = useState('');
  const [selectedMineId, setSelectedMineId] = useState<string | null>(null);

  const { mines, loading, error, refresh } = useMines(false);

  // Debounce search
  useEffect(() => {
    const timer = setTimeout(() => {
      setFilters(prev => ({ ...prev, search: debouncedSearch, skip: 0 }));
    }, 300);
    return () => clearTimeout(timer);
  }, [debouncedSearch]);

  // Fetch when filters change
  useEffect(() => {
    refresh(filters);
  }, [filters, refresh]);

  const handleFilterChange = (key: keyof MineFilters, value: any) => {
    setFilters(prev => ({
      ...prev,
      [key]: value === '' ? undefined : value,
      skip: key === 'skip' ? value : 0 // Reset page on any change except pagination
    }));
  };

  const handleSort = (field: string) => {
    setFilters(prev => ({
      ...prev,
      sort_by: field,
      sort_order: prev.sort_by === field && prev.sort_order === 'asc' ? 'desc' : 'asc',
      skip: 0
    }));
  };

  const clearFilters = () => {
    setDebouncedSearch('');
    setFilters({
      skip: 0,
      limit: 25,
      status: 'active',
      sort_by: 'name',
      sort_order: 'asc'
    });
  };

  const hasNextPage = mines.length === filters.limit;
  const hasPrevPage = (filters.skip || 0) > 0;

  return (
    <div className="flex flex-col h-full space-y-4">
      {/* Header & Controls */}
      <div className="bg-coal-900 border border-coal-800 rounded-xl p-4 shadow-xl">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
          {/* Search */}
          <div className="relative">
            <Search className="absolute left-3 top-2.5 w-4 h-4 text-slate-500" />
            <input
              type="text"
              placeholder="Search mines (Name, Code)..."
              value={debouncedSearch}
              onChange={(e) => setDebouncedSearch(e.target.value)}
              className="w-full bg-coal-950 border border-coal-800 rounded-lg pl-9 pr-4 py-2 text-xs font-mono text-slate-200 focus:outline-none focus:border-amber-500/50"
            />
          </div>

          {/* State Filter */}
          <div className="flex items-center gap-2">
            <Filter className="w-4 h-4 text-slate-500 shrink-0" />
            <select
              value={filters.state || ''}
              onChange={(e) => handleFilterChange('state', e.target.value)}
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-xs font-mono text-slate-300 focus:outline-none focus:border-amber-500/50"
            >
              <option value="">All States</option>
              <option value="Jharkhand">Jharkhand</option>
              <option value="Odisha">Odisha</option>
              <option value="Chhattisgarh">Chhattisgarh</option>
              <option value="West Bengal">West Bengal</option>
              <option value="Madhya Pradesh">Madhya Pradesh</option>
              <option value="Maharashtra">Maharashtra</option>
              <option value="Telangana">Telangana</option>
              <option value="Tamil Nadu">Tamil Nadu</option>
            </select>
          </div>

          {/* Mine Type */}
          <select
            value={filters.mine_type || ''}
            onChange={(e) => handleFilterChange('mine_type', e.target.value)}
            className="w-full bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-xs font-mono text-slate-300 focus:outline-none focus:border-amber-500/50"
          >
            <option value="">All Types</option>
            <option value="OC">Opencast (OC)</option>
            <option value="UG">Underground (UG)</option>
            <option value="Mixed">Mixed</option>
          </select>

          {/* District Filter */}
          <div className="flex items-center gap-2">
            <Filter className="w-4 h-4 text-slate-500 shrink-0" />
            <input
              type="text"
              placeholder="District..."
              value={filters.district || ''}
              onChange={(e) => handleFilterChange('district', e.target.value)}
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-xs font-mono text-slate-300 focus:outline-none focus:border-amber-500/50"
            />
          </div>
        </div>

        <div className="flex flex-wrap items-center justify-between gap-4 pt-4 border-t border-coal-800">
           <div className="flex items-center gap-4">
              <div className="flex items-center gap-2">
                <span className="text-xxs text-slate-500 uppercase font-bold tracking-widest">Ownership:</span>
                <select
                  value={filters.ownership_type || ''}
                  onChange={(e) => handleFilterChange('ownership_type', e.target.value)}
                  className="bg-coal-950 border border-coal-800 rounded-lg px-2 py-1 text-xxs font-mono text-slate-400 focus:outline-none focus:border-amber-500/50"
                >
                  <option value="">Any</option>
                  <option value="Public">Public</option>
                  <option value="Private">Private</option>
                  <option value="Joint Venture">JV</option>
                </select>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-xxs text-slate-500 uppercase font-bold tracking-widest">Status:</span>
                <select
                  value={filters.status || ''}
                  onChange={(e) => handleFilterChange('status', e.target.value)}
                  className="bg-coal-950 border border-coal-800 rounded-lg px-2 py-1 text-xxs font-mono text-slate-400 focus:outline-none focus:border-amber-500/50"
                >
                  <option value="">Any</option>
                  <option value="active">Active</option>
                  <option value="inactive">Inactive</option>
                  <option value="suspended">Suspended</option>
                </select>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-xxs text-slate-500 uppercase font-bold tracking-widest">Page Size:</span>
                <select
                  value={filters.limit || 25}
                  onChange={(e) => handleFilterChange('limit', Number(e.target.value))}
                  className="bg-coal-950 border border-coal-800 rounded-lg px-2 py-1 text-xxs font-mono text-slate-400 focus:outline-none focus:border-amber-500/50"
                >
                  <option value={10}>10</option>
                  <option value={25}>25</option>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                </select>
              </div>
           </div>

           <div className="flex items-center gap-2">
             <button
               onClick={clearFilters}
               className="px-3 py-1.5 bg-coal-800 hover:bg-coal-700 text-slate-400 hover:text-white rounded-lg text-xxs font-bold transition-all border border-coal-700"
             >
               Clear Filters
             </button>
             <button
               onClick={() => refresh(filters)}
               className="p-1.5 bg-coal-800 hover:bg-amber-500 hover:text-coal-950 rounded-lg transition-all border border-coal-700"
               title="Reload Data"
             >
               <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
             </button>
           </div>
        </div>
      </div>

      {/* Main Table Content */}
      <div className="bg-coal-900 border border-coal-800 rounded-xl shadow-xl flex-1 flex flex-col overflow-hidden">
        <div className="flex-1 overflow-x-auto overflow-y-auto min-h-[400px]">
          {loading && mines.length === 0 ? (
            <LoadingState message="Connecting to production mine dataset..." />
          ) : error ? (
            <ErrorState message={error} onRetry={() => refresh(filters)} />
          ) : mines.length === 0 ? (
            <EmptyState message="No mines match your search criteria." />
          ) : (
            <table className="w-full text-left border-collapse font-mono text-xs">
              <thead className="sticky top-0 bg-coal-900 z-10 shadow-sm shadow-black/50">
                <tr className="border-b border-coal-800 text-slate-400">
                  <SortableHeader label="Mine Name" field="name" activeSort={filters.sort_by} order={filters.sort_order} onClick={handleSort} />
                  <SortableHeader label="State" field="state" activeSort={filters.sort_by} order={filters.sort_order} onClick={handleSort} />
                  <SortableHeader label="District" field="district" activeSort={filters.sort_by} order={filters.sort_order} onClick={handleSort} />
                  <SortableHeader label="Owner / Company" field="company" activeSort={filters.sort_by} order={filters.sort_order} onClick={handleSort} />
                  <th className="p-3">Type</th>
                  <th className="p-3">Commodity</th>
                  <th className="p-3">Status</th>
                  <th className="p-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-coal-800 text-slate-200">
                {mines.map((mine) => (
                  <tr
                    key={mine.id}
                    onClick={() => setSelectedMineId(mine.id)}
                    className={`hover:bg-amber-500/5 transition-colors cursor-pointer group ${selectedMineId === mine.id ? 'bg-amber-500/10' : ''}`}
                  >
                    <td className="p-3">
                      <div className="font-bold text-white group-hover:text-amber-500 transition-colors">{mine.name}</div>
                      <div className="text-[10px] text-slate-500">{mine.mine_code}</div>
                    </td>
                    <td className="p-3 text-slate-300">{mine.state}</td>
                    <td className="p-3 text-slate-400">{mine.district}</td>
                    <td className="p-3 text-slate-300 max-w-[150px] truncate" title={mine.company || mine.owner_name}>
                      {mine.company || mine.owner_name || 'N/A'}
                    </td>
                    <td className="p-3">
                      <span className="text-[10px] bg-coal-800 border border-coal-700 px-1.5 py-0.5 rounded text-slate-400 font-bold uppercase">
                        {mine.mine_type || 'N/A'}
                      </span>
                    </td>
                    <td className="p-3 text-slate-400">{mine.commodity}</td>
                    <td className="p-3"><StatusBadge status={mine.status} /></td>
                    <td className="p-3 text-right">
                       <button className="p-1.5 bg-coal-800 border border-coal-700 rounded hover:bg-amber-500 hover:text-coal-950 transition-all opacity-0 group-hover:opacity-100">
                          <Layers className="w-3 h-3" />
                       </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>

        {/* Pagination Controls */}
        <div className="bg-coal-950 border-t border-coal-800 p-3 flex items-center justify-between">
          <div className="text-xxs text-slate-500 font-mono">
            SHOWING <span className="text-slate-300 font-bold">{mines.length}</span> RECORDS ON THIS PAGE
          </div>
          <div className="flex items-center gap-2">
            <button
              disabled={!hasPrevPage || loading}
              onClick={() => handleFilterChange('skip', Math.max(0, (filters.skip || 0) - (filters.limit || 25)))}
              className="p-2 bg-coal-900 border border-coal-800 rounded-lg text-slate-400 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <div className="px-4 py-1.5 bg-coal-900 border border-coal-800 rounded-lg text-xs font-bold text-amber-500 font-mono">
              PAGE {Math.floor((filters.skip || 0) / (filters.limit || 25)) + 1}
            </div>
            <button
              disabled={!hasNextPage || loading}
              onClick={() => handleFilterChange('skip', (filters.skip || 0) + (filters.limit || 25))}
              className="p-2 bg-coal-900 border border-coal-800 rounded-lg text-slate-400 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Details Sidebar */}
      {selectedMineId && (
        <MineDetailsContextPanel
          mineId={selectedMineId}
          onClose={() => setSelectedMineId(null)}
          mines={mines}
        />
      )}
    </div>
  );
}

function SortableHeader({ label, field, activeSort, order, onClick }: { label: string, field: string, activeSort?: string, order?: string, onClick: (f: string) => void }) {
  const isActive = activeSort === field;
  return (
    <th
      className="p-3 cursor-pointer hover:text-white transition-colors group"
      onClick={() => onClick(field)}
    >
      <div className="flex items-center gap-1">
        {label}
        <div className={`transition-opacity ${isActive ? 'opacity-100' : 'opacity-0 group-hover:opacity-50'}`}>
          {isActive && order === 'desc' ? <ArrowDown className="w-3 h-3 text-amber-500" /> : <ArrowUp className={`w-3 h-3 ${isActive ? 'text-amber-500' : ''}`} />}
        </div>
      </div>
    </th>
  );
}
