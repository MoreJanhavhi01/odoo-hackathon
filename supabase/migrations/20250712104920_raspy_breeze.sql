/*
  # Create skills table

  1. New Tables
    - `skills`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to users)
      - `skill_name` (text) - name of the skill
      - `category` (text) - skill category (e.g., Programming, Design, etc.)
      - `experience_level` (text) - Beginner, Intermediate, Expert
      - `description` (text) - detailed description of the skill
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `skills` table
    - Add policy for anyone to read skills (public directory)
    - Add policy for users to manage their own skills
*/

CREATE TABLE IF NOT EXISTS skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  skill_name text NOT NULL,
  category text NOT NULL,
  experience_level text NOT NULL CHECK (experience_level IN ('Beginner', 'Intermediate', 'Expert')),
  description text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read skills (for public directory)
CREATE POLICY "Anyone can read skills"
  ON skills
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow users to insert their own skills
CREATE POLICY "Users can insert own skills"
  ON skills
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own skills
CREATE POLICY "Users can update own skills"
  ON skills
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own skills
CREATE POLICY "Users can delete own skills"
  ON skills
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create trigger for updated_at
CREATE TRIGGER update_skills_updated_at
  BEFORE UPDATE ON skills
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS skills_user_id_idx ON skills(user_id);
CREATE INDEX IF NOT EXISTS skills_category_idx ON skills(category);
CREATE INDEX IF NOT EXISTS skills_experience_level_idx ON skills(experience_level);