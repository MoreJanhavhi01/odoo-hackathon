@@ .. @@
 import PostRequestPage from './pages/PostRequestPage';
 import ContactPage from './pages/ContactPage';
+import RequestBoardPage from './pages/RequestBoardPage';
 import { AuthProvider } from './contexts/AuthContext';
@@ .. @@
           <Route path="/post-request" element={<ProtectedRoute><PostRequestPage /></ProtectedRoute>} />
           <Route path="/contact" element={<ContactPage />} />
+          <Route path="/requests" element={<RequestBoardPage />} />
         </Routes>