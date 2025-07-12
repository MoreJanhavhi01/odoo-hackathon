/*
  # Insert sample data for development

  1. Sample Data
    - Sample skill categories
    - Sample testimonials
    - Sample requests

  Note: This is optional sample data for development/demo purposes
*/

-- Insert sample skill categories (this could be a separate categories table in production)
-- For now, we'll just ensure consistent category names through the application

-- Insert some sample testimonials for demo purposes
-- Note: These will reference actual users once they sign up

-- You can uncomment and modify these once you have real users in your system:

/*
INSERT INTO testimonials (user_id, author_name, rating, message) VALUES
  ('user-uuid-here', 'Sarah Johnson', 5, 'Excellent web developer! Delivered my project on time and exceeded expectations.'),
  ('user-uuid-here', 'Mike Chen', 4, 'Great communication and solid technical skills. Would definitely work with again.'),
  ('user-uuid-here', 'Emily Davis', 5, 'Amazing designer with a keen eye for detail. Transformed my brand completely!');
*/

-- Create a view for user statistics (optional)
CREATE OR REPLACE VIEW user_stats AS
SELECT 
  u.id,
  u.name,
  u.email,
  COUNT(DISTINCT s.id) as skills_count,
  COUNT(DISTINCT t.id) as testimonials_count,
  COUNT(DISTINCT r.id) as requests_count,
  AVG(t.rating) as average_rating
FROM users u
LEFT JOIN skills s ON u.id = s.user_id
LEFT JOIN testimonials t ON u.id = t.user_id
LEFT JOIN requests r ON u.id = r.user_id
GROUP BY u.id, u.name, u.email;