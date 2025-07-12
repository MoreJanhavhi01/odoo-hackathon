import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { Request } from '../types/database';
import { Clock, DollarSign, User, Tag } from 'lucide-react';

interface RequestBoardProps {
  limit?: number;
  showUserRequests?: boolean;
  userId?: string;
}

export default function RequestBoard({ limit, showUserRequests = false, userId }: RequestBoardProps) {
  const [requests, setRequests] = useState<Request[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    fetchRequests();
  }, [filter, showUserRequests, userId]);

  const fetchRequests = async () => {
    try {
      let query = supabase
        .from('requests')
        .select(`
          *,
          users (
            name,
            profile_picture
          )
        `)
        .order('created_at', { ascending: false });

      if (showUserRequests && userId) {
        query = query.eq('user_id', userId);
      } else if (!showUserRequests) {
        query = query.eq('status', 'open');
      }

      if (filter !== 'all') {
        query = query.eq('category', filter);
      }

      if (limit) {
        query = query.limit(limit);
      }

      const { data, error } = await query;

      if (error) throw error;
      setRequests(data || []);
    } catch (error) {
      console.error('Error fetching requests:', error);
    } finally {
      setLoading(false);
    }
  };

  const categories = [
    'all',
    'Programming',
    'Design',
    'Writing',
    'Marketing',
    'Business',
    'Education',
    'Other'
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'open':
        return 'bg-green-100 text-green-800';
      case 'in_progress':
        return 'bg-yellow-100 text-yellow-800';
      case 'completed':
        return 'bg-blue-100 text-blue-800';
      case 'closed':
        return 'bg-gray-100 text-gray-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  if (loading) {
    return (
      <div className="space-y-4">
        {[...Array(3)].map((_, i) => (
          <div key={i} className="bg-white rounded-lg shadow-sm border p-6 animate-pulse">
            <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
            <div className="h-3 bg-gray-200 rounded w-1/2 mb-4"></div>
            <div className="h-3 bg-gray-200 rounded w-full mb-2"></div>
            <div className="h-3 bg-gray-200 rounded w-2/3"></div>
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {!showUserRequests && (
        <div className="flex flex-wrap gap-2">
          {categories.map((category) => (
            <button
              key={category}
              onClick={() => setFilter(category)}
              className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                filter === category
                  ? 'bg-indigo-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              {category === 'all' ? 'All Categories' : category}
            </button>
          ))}
        </div>
      )}

      <div className="space-y-4">
        {requests.length === 0 ? (
          <div className="text-center py-12">
            <div className="w-16 h-16 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
              <Tag className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">No requests found</h3>
            <p className="text-gray-500">
              {showUserRequests 
                ? "You haven't posted any requests yet." 
                : "No open requests match your criteria."}
            </p>
          </div>
        ) : (
          requests.map((request) => (
            <div key={request.id} className="bg-white rounded-lg shadow-sm border p-6 hover:shadow-md transition-shadow">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center space-x-3">
                  {request.users?.profile_picture ? (
                    <img
                      src={request.users.profile_picture}
                      alt={request.users.name}
                      className="w-10 h-10 rounded-full object-cover"
                    />
                  ) : (
                    <div className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center">
                      <User className="w-5 h-5 text-gray-400" />
                    </div>
                  )}
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900">{request.title}</h3>
                    <p className="text-sm text-gray-500">by {request.users?.name || 'Anonymous'}</p>
                  </div>
                </div>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${getStatusColor(request.status)}`}>
                  {request.status.replace('_', ' ')}
                </span>
              </div>

              <p className="text-gray-700 mb-4 line-clamp-3">{request.description}</p>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div className="flex items-center text-sm text-gray-600">
                  <Tag className="w-4 h-4 mr-2" />
                  <span className="font-medium">Skills:</span>
                  <span className="ml-1">{request.skills_needed}</span>
                </div>
                <div className="flex items-center text-sm text-gray-600">
                  <DollarSign className="w-4 h-4 mr-2" />
                  <span className="font-medium">Budget:</span>
                  <span className="ml-1">{request.budget_or_offer}</span>
                </div>
                <div className="flex items-center text-sm text-gray-600">
                  <Clock className="w-4 h-4 mr-2" />
                  <span>{new Date(request.created_at).toLocaleDateString()}</span>
                </div>
              </div>

              <div className="flex items-center justify-between">
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">
                  {request.category}
                </span>
                {!showUserRequests && request.status === 'open' && (
                  <button className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors text-sm font-medium">
                    Apply Now
                  </button>
                )}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}