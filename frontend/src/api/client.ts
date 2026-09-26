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

export const client = {
  get: async (endpoint: string, options: RequestInit = {}) => {
    const token = localStorage.getItem('coalnexus_token') || '';
    const headers: Record<string, string> = {
      ...options.headers as Record<string, string>,
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'GET',
      headers,
    });
    return handleResponse(response);
  },
  post: async (endpoint: string, data: any, options: RequestInit = {}) => {
    const token = localStorage.getItem('coalnexus_token') || '';
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...options.headers as Record<string, string>,
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'POST',
      headers,
      body: JSON.stringify(data),
    });
    return handleResponse(response);
  },
  put: async (endpoint: string, data: any, options: RequestInit = {}) => {
    const token = localStorage.getItem('coalnexus_token') || '';
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...options.headers as Record<string, string>,
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    const response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      method: 'PUT',
      headers,
      body: JSON.stringify(data),
    });
    return handleResponse(response);
  },
};
