/*
  # Create inquiries table

  1. New Tables
    - `inquiries`
      - `id` (uuid, primary key)
      - `name` (text) - inquirer's name
      - `email` (text) - inquirer's email
      - `subject` (text) - inquiry subject
      - `message` (text) - inquiry message
      - `status` (text) - 'new', 'in_progress', 'resolved'
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `inquiries` table
    - Add policy for anyone to create inquiries
    - Add policy for admins to read all inquiries (future feature)
*/

CREATE TABLE IF NOT EXISTS inquiries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  status text DEFAULT 'new' CHECK (status IN ('new', 'in_progress', 'resolved')),
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- Allow anyone to create inquiries (contact form submissions)
CREATE POLICY "Anyone can create inquiries"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS inquiries_status_idx ON inquiries(status);
CREATE INDEX IF NOT EXISTS inquiries_created_at_idx ON inquiries(created_at DESC);