import React from 'react';
import Layout from '../components/Layout';
import RequestBoard from '../components/RequestBoard';
import { Link } from 'react-router-dom';
import { Plus, Briefcase } from 'lucide-react';

export default function RequestBoardPage() {
  return (
    <Layout>
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 mb-2">Request Board</h1>
            <p className="text-gray-600">
              Browse open requests from people looking for skills and services
            </p>
          </div>
          <Link
            to="/post-request"
            className="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors font-medium"
          >
            <Plus className="w-5 h-5 mr-2" />
            Post Request
          </Link>
        </div>

        <div className="bg-white rounded-lg shadow-sm border p-6 mb-8">
          <div className="flex items-center mb-4">
            <Briefcase className="w-6 h-6 text-indigo-600 mr-3" />
            <h2 className="text-xl font-semibold text-gray-900">How it works</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-3">
                <span className="text-indigo-600 font-bold">1</span>
              </div>
              <h3 className="font-medium text-gray-900 mb-2">Browse Requests</h3>
              <p className="text-sm text-gray-600">
                Look through open requests that match your skills
              </p>
            </div>
            <div className="text-center">
              <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-3">
                <span className="text-indigo-600 font-bold">2</span>
              </div>
              <h3 className="font-medium text-gray-900 mb-2">Apply or Contact</h3>
              <p className="text-sm text-gray-600">
                Reach out to the requester with your proposal
              </p>
            </div>
            <div className="text-center">
              <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-3">
                <span className="text-indigo-600 font-bold">3</span>
              </div>
              <h3 className="font-medium text-gray-900 mb-2">Get Hired</h3>
              <p className="text-sm text-gray-600">
                Complete the project and build your reputation
              </p>
            </div>
          </div>
        </div>

        <RequestBoard />
      </div>
    </Layout>
  );
}