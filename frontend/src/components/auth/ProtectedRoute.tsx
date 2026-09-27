import React from 'react';
import { useAuth } from '../../hooks/useAuth';
import { Login } from './Login';
import { LoadingState } from '../common';

interface ProtectedRouteProps {
  children: React.ReactNode;
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-coal-950 text-slate-100 flex items-center justify-center font-mono">
        <LoadingState message="Synchronizing secure session..." />
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Login />;
  }

  return <>{children}</>;
};
