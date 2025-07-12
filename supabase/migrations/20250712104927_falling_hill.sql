/*
  # Create messages table

  1. New Tables
    - `messages`
      - `id` (uuid, primary key)
      - `sender_id` (uuid, foreign key to users)
      - `receiver_id` (uuid, foreign key to users)
      - `subject` (text) - message subject/title
      - `message_text` (text) - message content
      - `message_type` (text) - 'hire_request', 'skill_swap', 'general'
      - `read_status` (boolean) - whether message has been read
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `messages` table
    - Add policy for users to read their own messages (sent or received)
    - Add policy for users to send messages
    - Add policy for users to update read status of received messages
*/

CREATE TABLE IF NOT EXISTS messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  receiver_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  subject text NOT NULL,
  message_text text NOT NULL,
  message_type text DEFAULT 'general' CHECK (message_type IN ('hire_request', 'skill_swap', 'general')),
  read_status boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Allow users to read messages they sent or received
CREATE POLICY "Users can read own messages"
  ON messages
  FOR SELECT
  TO authenticated
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Allow users to send messages
CREATE POLICY "Users can send messages"
  ON messages
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = sender_id);

-- Allow users to update read status of messages they received
CREATE POLICY "Users can update received messages"
  ON messages
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = receiver_id)
  WITH CHECK (auth.uid() = receiver_id);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS messages_sender_id_idx ON messages(sender_id);
CREATE INDEX IF NOT EXISTS messages_receiver_id_idx ON messages(receiver_id);
CREATE INDEX IF NOT EXISTS messages_created_at_idx ON messages(created_at DESC);