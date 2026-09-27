import { supabase } from './supabase';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';

async function handleResponse(response: Response) {
  if (!response.ok) {
    let errorMessage = `Error: ${response.status} ${response.statusText}`;
    try {
      const errorData = await response.json();
      errorMessage = errorData.detail || errorMessage;
    } catch (e) {
      // Not a JSON error
    }
    throw new Error(errorMessage);
  }
  return response.json();
}

async function getAuthHeaders(options: RequestInit = {}): Promise<Record<string, string>> {
  const headers: Record<string, string> = {
    ...options.headers as Record<string, string>,
  };

  const { data: { session } } = await supabase.auth.getSession();
  if (session?.access_token) {
    headers['Authorization'] = `Bearer ${session.access_token}`;
  }

  return headers;
}

export const client = {
  get: async (endpoint: string, options: RequestInit = {}) => {
    const headers = await getAuthHeaders(options);
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'GET',
      headers,
    });
    return handleResponse(response);
  },
  post: async (endpoint: string, data: any, options: RequestInit = {}) => {
    const headers = await getAuthHeaders(options);
    headers['Content-Type'] = 'application/json';
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'POST',
      headers,
      body: JSON.stringify(data),
    });
    return handleResponse(response);
  },
  put: async (endpoint: string, data: any, options: RequestInit = {}) => {
    const headers = await getAuthHeaders(options);
    headers['Content-Type'] = 'application/json';
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'PUT',
      headers,
      body: JSON.stringify(data),
    });
    return handleResponse(response);
  },
};
