import React, { useState } from 'react';
import { X, Save, CheckCircle2 } from 'lucide-react';
import { CorrectiveAction } from '../../types';
import { correctiveActionsApi } from '../../api/correctiveActions';

interface EditCorrectiveActionModalProps {
  action: CorrectiveAction;
  onClose: () => void;
  onSuccess: () => void;
}

export function EditCorrectiveActionModal({ action, onClose, onSuccess }: EditCorrectiveActionModalProps) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    ...action,
    status: action.status,
    local_version: (action as any).local_version || 1,
    operation_id: `op_upd_${Date.now()}`
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const updatePayload = {
        ...formData,
        local_version: formData.local_version + 1
      };
      await correctiveActionsApi.update(action.id, updatePayload);
      onSuccess();
      onClose();
    } catch (err: any) {
      setError(err.message || 'Failed to update corrective action');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-coal-900 border border-coal-800 rounded-xl shadow-2xl w-full max-w-md overflow-hidden animate-in fade-in zoom-in duration-200">
        <div className="px-6 py-4 border-b border-coal-800 flex justify-between items-center">
          <h3 className="text-lg font-bold text-white flex items-center gap-2">
            <CheckCircle2 className="w-5 h-5 text-amber-500" /> Update Corrective Action
          </h3>
          <button onClick={onClose} className="text-slate-400 hover:text-white transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div className="bg-coal-950 p-3 rounded-lg border border-coal-800 mb-4">
            <p className="text-xxs font-bold text-amber-500 uppercase mb-1">Action Context</p>
            <p className="text-sm font-semibold text-white">{action.title}</p>
            <p className="text-xs text-slate-400 mt-1 line-clamp-2">{action.description}</p>
          </div>

          {error && (
            <div className="p-3 bg-rose-500/10 border border-rose-500/20 rounded-lg text-rose-400 text-xs font-mono">
              {error}
            </div>
          )}

          <div className="space-y-1">
            <label className="text-xxs font-bold text-slate-500 uppercase tracking-widest">Update Status</label>
            <select
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value })}
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-amber-500/50"
              required
            >
              <option value="assigned">Assigned</option>
              <option value="inProgress">In Progress</option>
              <option value="submitted">Submitted</option>
              <option value="verification">Verification</option>
              <option value="verified">Verified</option>
              <option value="rejected">Rejected</option>
              <option value="closed">Closed</option>
            </select>
          </div>

          <div className="space-y-1">
            <label className="text-xxs font-bold text-slate-500 uppercase tracking-widest">Evidence / Comments</label>
            <textarea
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-amber-500/50 h-24 resize-none"
              placeholder="Detail work performed or evidence links..."
              value={formData.evidence || ''}
              onChange={(e) => setFormData({ ...formData, evidence: e.target.value })}
            />
          </div>

          <div className="grid grid-cols-2 gap-4 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 bg-coal-800 hover:bg-coal-700 text-slate-300 border border-coal-700 rounded-lg text-sm font-medium transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-4 py-2 bg-amber-500 hover:bg-amber-600 text-coal-950 rounded-lg text-sm font-bold flex items-center justify-center gap-2 transition-colors disabled:opacity-50"
            >
              {loading ? 'Updating...' : (
                <>
                  <Save className="w-4 h-4" />
                  Save Changes
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
