/*
  # Create portfolio table

  1. New Tables
    - `portfolio`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to users)
      - `title` (text) - portfolio item title
      - `description` (text) - detailed description
      - `media_url` (text) - URL to image/video/file
      - `external_link` (text) - link to live project/website
      - `tags` (text) - comma-separated tags
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `portfolio` table
    - Add policy for anyone to read portfolio items
    - Add policy for users to manage their own portfolio
*/

CREATE TABLE IF NOT EXISTS portfolio (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  media_url text DEFAULT '',
  external_link text DEFAULT '',
  tags text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE portfolio ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read portfolio items
CREATE POLICY "Anyone can read portfolio"
  ON portfolio
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow users to insert their own portfolio items
CREATE POLICY "Users can insert own portfolio"
  ON portfolio
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own portfolio items
CREATE POLICY "Users can update own portfolio"
  ON portfolio
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own portfolio items
CREATE POLICY "Users can delete own portfolio"
  ON portfolio
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create trigger for updated_at
CREATE TRIGGER update_portfolio_updated_at
  BEFORE UPDATE ON portfolio
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS portfolio_user_id_idx ON portfolio(user_id);
CREATE INDEX IF NOT EXISTS portfolio_created_at_idx ON portfolio(created_at DESC);