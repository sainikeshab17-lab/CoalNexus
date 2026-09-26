import { useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { Mine } from '../../types';
import { StatusBadge } from '../common';
import { HardHat, Activity } from 'lucide-react';

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
}

function ChangeView({ center }: { center: [number, number] }) {
  const map = useMap();
  useEffect(() => {
    map.setView(center, 7);
  }, [center, map]);
  return null;
}

export function MineRiskMap({ mines }: MineRiskMapProps) {
  const center: [number, number] = mines.length > 0
    ? [mines[0].latitude, mines[0].longitude]
    : [20.5937, 78.9629]; // India center

  return (
    <div className="h-full w-full rounded-lg overflow-hidden border border-coal-800">
      <MapContainer
        center={center}
        zoom={7}
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
          >
            <Popup className="coalnexus-popup">
              <div className="p-1 min-w-[200px]">
                <div className="flex justify-between items-start mb-2">
                  <h4 className="font-bold text-coal-950 m-0">{mine.name}</h4>
                  <StatusBadge status={mine.status} />
                </div>
                <div className="space-y-1 text-xs text-slate-600">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold">Code:</span> {mine.mine_code}
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="font-semibold">Coords:</span> {mine.latitude.toFixed(4)}, {mine.longitude.toFixed(4)}
                  </div>
                </div>
                <div className="mt-3 pt-2 border-t border-slate-200 flex flex-wrap gap-2">
                   <div className="text-[10px] bg-slate-100 px-2 py-0.5 rounded flex items-center gap-1">
                      <Activity className="w-3 h-3 text-emerald-600" /> Sensors OK
                   </div>
                   <div className="text-[10px] bg-slate-100 px-2 py-0.5 rounded flex items-center gap-1">
                      <HardHat className="w-3 h-3 text-amber-600" /> WCL
                   </div>
                </div>
              </div>
            </Popup>
          </Marker>
        ))}
        {mines.length > 0 && <ChangeView center={center} />}
      </MapContainer>
    </div>
  );
}
