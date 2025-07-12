/*
  # Create requests table

  1. New Tables
    - `requests`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to users)
      - `title` (text) - request title
      - `description` (text) - detailed description
      - `skills_needed` (text) - required skills
      - `budget_or_offer` (text) - budget or what's offered in exchange
      - `category` (text) - request category
      - `status` (text) - 'open', 'in_progress', 'completed', 'closed'
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `requests` table
    - Add policy for anyone to read open requests
    - Add policy for users to manage their own requests
*/

CREATE TABLE IF NOT EXISTS requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  skills_needed text NOT NULL,
  budget_or_offer text NOT NULL,
  category text NOT NULL,
  status text DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'completed', 'closed')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read open requests
CREATE POLICY "Anyone can read open requests"
  ON requests
  FOR SELECT
  TO authenticated
  USING (status = 'open' OR auth.uid() = user_id);

-- Allow users to insert their own requests
CREATE POLICY "Users can insert own requests"
  ON requests
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own requests
CREATE POLICY "Users can update own requests"
  ON requests
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own requests
CREATE POLICY "Users can delete own requests"
  ON requests
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create trigger for updated_at
CREATE TRIGGER update_requests_updated_at
  BEFORE UPDATE ON requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS requests_user_id_idx ON requests(user_id);
CREATE INDEX IF NOT EXISTS requests_status_idx ON requests(status);
CREATE INDEX IF NOT EXISTS requests_category_idx ON requests(category);
CREATE INDEX IF NOT EXISTS requests_created_at_idx ON requests(created_at DESC);