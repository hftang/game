-- Supabase PostgreSQL Schema for Orishas Path
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE players (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  ori_coin INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  exp INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE characters (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  class_type TEXT NOT NULL,
  level INTEGER DEFAULT 1,
  exp INTEGER DEFAULT 0,
  current_hp INTEGER NOT NULL,
  max_hp INTEGER NOT NULL,
  current_mp INTEGER NOT NULL,
  max_mp INTEGER NOT NULL,
  base_atk INTEGER NOT NULL,
  base_def INTEGER NOT NULL,
  base_spd INTEGER NOT NULL,
  base_mag INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE inventory (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  item_id TEXT NOT NULL,
  item_type TEXT NOT NULL,
  quantity INTEGER DEFAULT 1,
  equipped BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE pets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  pet_id TEXT NOT NULL,
  pet_name TEXT NOT NULL,
  level INTEGER DEFAULT 1,
  exp INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  amount INTEGER NOT NULL,
  ori_coin_amount INTEGER NOT NULL,
  status TEXT DEFAULT "PENDING",
  flutterwave_ref TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE monthly_cards (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  end_date TIMESTAMP WITH TIME ZONE NOT NULL,
  last_claim_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES players(id) ON DELETE CASCADE,
  channel TEXT NOT NULL,
  recipient_id UUID REFERENCES players(id),
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE friends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  friend_id UUID REFERENCES players(id) ON DELETE CASCADE,
  status TEXT DEFAULT "PENDING",
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(player_id, friend_id)
);

CREATE TABLE recharge_cards (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,
  value INTEGER NOT NULL,
  ori_coin_value INTEGER NOT NULL,
  is_redeemed BOOLEAN DEFAULT FALSE,
  redeemed_by UUID REFERENCES players(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_characters_player_id ON characters(player_id);
CREATE INDEX idx_inventory_player_id ON inventory(player_id);
CREATE INDEX idx_pets_player_id ON pets(player_id);
CREATE INDEX idx_transactions_player_id ON transactions(player_id);
CREATE INDEX idx_chat_messages_channel ON chat_messages(channel, created_at);
CREATE INDEX idx_friends_player_id ON friends(player_id);
CREATE INDEX idx_recharge_cards_code ON recharge_cards(code);