/*
  # Create testimonials table

  1. New Tables
    - `testimonials`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to users) - who the testimonial is for
      - `author_id` (uuid, foreign key to users) - who wrote the testimonial
      - `author_name` (text) - name of the person giving testimonial
      - `rating` (integer) - rating from 1 to 5
      - `message` (text) - testimonial content
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `testimonials` table
    - Add policy for anyone to read testimonials
    - Add policy for users to create testimonials for others
    - Add policy for users to update/delete testimonials they wrote
*/

CREATE TABLE IF NOT EXISTS testimonials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  author_id uuid REFERENCES users(id) ON DELETE CASCADE,
  author_name text NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  message text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read testimonials
CREATE POLICY "Anyone can read testimonials"
  ON testimonials
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow authenticated users to create testimonials
CREATE POLICY "Users can create testimonials"
  ON testimonials
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = author_id OR author_id IS NULL);

-- Allow users to update testimonials they wrote
CREATE POLICY "Users can update own testimonials"
  ON testimonials
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = author_id)
  WITH CHECK (auth.uid() = author_id);

-- Allow users to delete testimonials they wrote
CREATE POLICY "Users can delete own testimonials"
  ON testimonials
  FOR DELETE
  TO authenticated
  USING (auth.uid() = author_id);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS testimonials_user_id_idx ON testimonials(user_id);
CREATE INDEX IF NOT EXISTS testimonials_author_id_idx ON testimonials(author_id);
CREATE INDEX IF NOT EXISTS testimonials_rating_idx ON testimonials(rating);
CREATE INDEX IF NOT EXISTS testimonials_created_at_idx ON testimonials(created_at DESC);