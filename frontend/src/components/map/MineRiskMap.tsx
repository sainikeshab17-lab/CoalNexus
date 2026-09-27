import { useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { Mine } from '../../types';
import { StatusBadge } from '../common';
import { HardHat, Activity, BarChart2 } from 'lucide-react';

// Fix Leaflet marker icon issue
import markerIcon from 'leaflet/dist/images/marker-icon.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

let DefaultIcon = L.icon({
  iconUrl: markerIcon,
  shadowUrl: markerShadow,
  iconSize: [25, 41],
  iconAnchor: [12, 41]
});
L.Marker.prototype.options.icon = DefaultIcon;

interface MineRiskMapProps {
  mines: Mine[];
  onMineSelect?: (mineId: string) => void;
  selectedMineId?: string | null;
}

function ChangeView({ center }: { center: [number, number] }) {
  const map = useMap();
  useEffect(() => {
    // If the center is just default 0,0, don't re-center automatically unless it's a real mine coordinate
    if (center[0] !== 0 || center[1] !== 0) {
      map.setView(center, map.getZoom());
    }
  }, [center, map]);
  return null;
}

export function MineRiskMap({ mines, onMineSelect }: MineRiskMapProps) {
  // Let's filter out mines with 0,0 coordinates for center calculation to zoom into actual data points
  const validMines = mines.filter(m => m.latitude !== 0 || m.longitude !== 0);
  const center: [number, number] = validMines.length > 0
    ? [validMines[0].latitude, validMines[0].longitude]
    : [20.5937, 78.9629]; // India center

  return (
    <div className="h-full w-full rounded-lg overflow-hidden border border-coal-800">
      <MapContainer
        center={center}
        zoom={6}
        className="h-full w-full z-0"
        scrollWheelZoom={true}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {mines.map((mine) => (
          <Marker
            key={mine.id}
            position={[mine.latitude, mine.longitude]}
            eventHandlers={{
              click: () => {
                onMineSelect?.(mine.id);
              }
            }}
          >
            <Popup className="coalnexus-popup">
              <div className="p-1 min-w-[240px]">
                <div className="flex justify-between items-start mb-2 gap-2">
                  <h4 className="font-bold text-coal-950 m-0 leading-tight">{mine.name}</h4>
                  <StatusBadge status={mine.status} />
                </div>
                <div className="space-y-1 text-xs text-slate-600">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-slate-700">Code:</span> {mine.mine_code}
                  </div>
                  {mine.state && (
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-slate-700">Location:</span> {mine.district ? `${mine.district}, ` : ''}{mine.state}
                    </div>
                  )}
                  {mine.owner_name && (
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-slate-700">Owner:</span> {mine.owner_name}
                    </div>
                  )}
                  {mine.mine_type && (
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-slate-700">Type:</span> {mine.mine_type}
                    </div>
                  )}
                  {mine.commodity && (
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-slate-700">Commodity:</span> {mine.commodity}
                    </div>
                  )}
                  {mine.production_hist !== undefined && mine.production_hist > 0 && (
                    <div className="flex items-center gap-2 bg-amber-50 text-amber-800 px-1.5 py-0.5 rounded text-[11px] font-medium mt-1">
                      <BarChart2 className="w-3.5 h-3.5" />
                      <span>Production (19-20): {mine.production_hist} MT</span>
                    </div>
                  )}
                  <div className="flex items-center gap-2 text-[10px] text-slate-400 mt-1">
                    <span>Coords: {mine.latitude.toFixed(4)}, {mine.longitude.toFixed(4)}</span>
                    {mine.coordinate_accuracy && <span>({mine.coordinate_accuracy})</span>}
                  </div>
                </div>
                <div className="mt-3 pt-2 border-t border-slate-200 flex flex-wrap gap-2">
                   <div className="text-[10px] bg-slate-100 px-2 py-0.5 rounded flex items-center gap-1">
                      <Activity className="w-3 h-3 text-emerald-600" /> Live Telemetry
                   </div>
                   <div className="text-[10px] bg-slate-100 px-2 py-0.5 rounded flex items-center gap-1">
                      <HardHat className="w-3 h-3 text-amber-600" /> {mine.ownership_type || 'G/P'}
                   </div>
                </div>
              </div>
            </Popup>
          </Marker>
        ))}
        {validMines.length > 0 && <ChangeView center={center} />}
      </MapContainer>
    </div>
  );
}
