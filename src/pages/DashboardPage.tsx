import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import RequestBoard from '../components/RequestBoard';
import { User, Skill, Message, Request } from '../types/database';