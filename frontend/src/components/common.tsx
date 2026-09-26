import { AlertCircle, Loader2 } from 'lucide-react';

export function LoadingState({ message = "Loading content..." }: { message?: string }) {
  return (
    <div className="flex flex-col items-center justify-center p-12 text-center bg-coal-900 border border-coal-800 rounded-xl">
      <Loader2 className="w-8 h-8 text-amber-500 animate-spin mb-3" />
      <p className="text-xs text-slate-300 font-mono">{message}</p>
    </div>
  );
}

export function ErrorState({ message, onRetry }: { message: string; onRetry?: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center p-8 text-center bg-coal-900 border border-rose-500/20 rounded-xl">
      <div className="w-10 h-10 rounded-full bg-rose-500/10 border border-rose-500/20 flex items-center justify-center mb-3">
        <AlertCircle className="w-5 h-5 text-rose-400" />
      </div>
      <h4 className="text-sm font-bold text-white mb-1">Connection/Operational Error</h4>
      <p className="text-xs text-slate-400 max-w-md mx-auto mb-4 font-mono">{message}</p>
      {onRetry && (
        <button
          onClick={onRetry}
          className="px-4 py-1.5 bg-coal-800 hover:bg-coal-700 text-slate-200 border border-coal-700 rounded-lg text-xs font-medium transition-colors"
        >
          Retry Connection
        </button>
      )}
    </div>
  );
}

export function EmptyState({ message = "No matching records found." }: { message?: string }) {
  return (
    <div className="flex flex-col items-center justify-center p-12 text-center bg-coal-900 border border-coal-800 rounded-xl">
      <p className="text-xs text-slate-400 font-mono mb-2">{message}</p>
    </div>
  );
}

export function StatusBadge({ status }: { status: string }) {
  const normalized = status.toLowerCase();
  let classes = "text-slate-400 bg-coal-800 border-coal-700";

  if (['active', 'open', 'completed', 'verified', 'compliant'].includes(normalized)) {
    classes = "text-emerald-400 bg-emerald-500/10 border-emerald-500/20";
  } else if (['inprogress', 'in_progress', 'inspecting', 'assigned', 'verification', 'findingsgenerated', 'findings_generated'].includes(normalized)) {
    classes = "text-amber-400 bg-amber-500/10 border-amber-500/20";
  } else if (['critical', 'failed', 'noncompliant', 'rejected'].includes(normalized)) {
    classes = "text-rose-400 bg-rose-500/10 border-rose-500/20";
  } else if (['closed', 'resolved'].includes(normalized)) {
    classes = "text-sky-400 bg-sky-500/10 border-sky-500/20";
  }

  return (
    <span className={`px-2 py-0.5 rounded-full border text-xxs font-mono font-medium uppercase tracking-wider ${classes}`}>
      {status.replace('_', ' ')}
    </span>
  );
}

export function SeverityBadge({ severity }: { severity: string }) {
  const normalized = severity.toLowerCase();
  let classes = "text-slate-400 bg-coal-800 border-coal-700";

  if (normalized === 'low') {
    classes = "text-sky-400 bg-sky-500/10 border-sky-500/20";
  } else if (normalized === 'medium') {
    classes = "text-amber-400 bg-amber-500/10 border-amber-500/20";
  } else if (normalized === 'high') {
    classes = "text-orange-400 bg-orange-500/10 border-orange-500/20";
  } else if (normalized === 'critical') {
    classes = "text-rose-400 bg-rose-500/10 border-rose-500/20 animate-pulse";
  }

  return (
    <span className={`px-2 py-0.5 rounded-full border text-xxs font-mono font-medium uppercase tracking-wider ${classes}`}>
      {severity}
    </span>
  );
}
