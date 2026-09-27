import React, { useState } from 'react';
import { supabase } from '../../api/supabase';
import { Shield, Lock, Mail, AlertCircle, RefreshCw } from 'lucide-react';

export const Login: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      setError('Please fill in all fields.');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const { error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (authError) {
        throw authError;
      }
    } catch (err: any) {
      setError(err.message || 'Authentication failed. Please check your credentials.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-coal-950 text-slate-100 flex items-center justify-center font-sans p-4 select-none">
      <div className="w-full max-w-md bg-coal-900 border border-coal-800 rounded-2xl shadow-2xl overflow-hidden shadow-black/50">
        <div className="p-8 border-b border-coal-800 bg-coal-950/50 flex flex-col items-center">
          <div className="bg-amber-500 text-coal-950 p-3 rounded-xl font-bold flex items-center justify-center shadow-lg shadow-amber-500/20 mb-4 animate-pulse">
            <Shield className="w-6 h-6" />
          </div>
          <h1 className="text-xl font-black tracking-tight text-white text-center">
            COALNEXUS <span className="text-xs bg-coal-800 text-amber-500 border border-coal-700 px-2 py-0.5 rounded font-mono font-medium ml-1">SECURE ACCESS</span>
          </h1>
          <p className="text-xs text-slate-400 mt-1 text-center">SIH National Enterprise Mining Safety & Telemetry Stack</p>
        </div>

        <form onSubmit={handleSubmit} className="p-8 space-y-5">
          {error && (
            <div className="bg-rose-500/10 border border-rose-500/20 rounded-xl p-3 flex items-start gap-2 text-rose-400 text-xs font-mono">
              <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
              <span>{error}</span>
            </div>
          )}

          <div className="space-y-1.5">
            <label className="text-xxs font-bold text-slate-400 tracking-wider uppercase flex items-center gap-1">
              <Mail className="w-3 h-3" /> Enterprise Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="username@coalnexus.gov.in"
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-4 py-2.5 text-xs font-mono text-slate-200 focus:outline-none focus:border-amber-500/50 transition-colors"
              required
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-xxs font-bold text-slate-400 tracking-wider uppercase flex items-center gap-1">
              <Lock className="w-3 h-3" /> Security Passphrase
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••••••"
              className="w-full bg-coal-950 border border-coal-800 rounded-lg px-4 py-2.5 text-xs font-mono text-slate-200 focus:outline-none focus:border-amber-500/50 transition-colors"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 bg-amber-500 hover:bg-amber-600 disabled:bg-coal-800 text-coal-950 disabled:text-slate-500 rounded-lg text-xs font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-amber-500/10 border border-amber-400/20 mt-2 cursor-pointer"
          >
            {loading ? (
              <>
                <RefreshCw className="w-4 h-4 animate-spin" />
                Verifying Credentials...
              </>
            ) : (
              'Establish Secure Session'
            )}
          </button>
        </form>

        <div className="px-8 pb-6 text-center">
          <p className="text-xxs font-mono text-slate-500 uppercase tracking-widest">
            Authorized Personnel Only
          </p>
        </div>
      </div>
    </div>
  );
};
