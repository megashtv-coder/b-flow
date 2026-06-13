-- B-Flow Database Schema Setup
-- Create all necessary tables for B-Flow application

-- Organizations table
CREATE TABLE IF NOT EXISTS organizations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  shortName TEXT,
  description TEXT,
  plan TEXT DEFAULT 'free',
  status TEXT DEFAULT 'active',
  createdAt TEXT,
  color TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  username TEXT UNIQUE,
  password TEXT,
  email TEXT,
  role TEXT DEFAULT 'editor',
  orgId TEXT REFERENCES organizations(id),
  isSuperAdmin BOOLEAN DEFAULT false,
  active BOOLEAN DEFAULT true,
  createdAt TEXT,
  color TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Profiles table (Supabase auth)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE,
  name TEXT,
  role TEXT DEFAULT 'editor',
  orgId TEXT REFERENCES organizations(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  country TEXT,
  city TEXT,
  address TEXT,
  type TEXT,
  appId TEXT,
  macId TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Items table
CREATE TABLE IF NOT EXISTS items (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC,
  category TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Invoices table
CREATE TABLE IF NOT EXISTS invoices (
  id TEXT PRIMARY KEY,
  customer TEXT NOT NULL,
  country TEXT,
  email TEXT,
  amount NUMERIC NOT NULL,
  status TEXT DEFAULT 'pending',
  date TEXT,
  due TEXT,
  type TEXT,
  subscriptionExpiry TEXT,
  notifyDate TEXT,
  comments JSONB DEFAULT '[]'::jsonb,
  items JSONB DEFAULT '[]'::jsonb,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Payments table
CREATE TABLE IF NOT EXISTS payments (
  id TEXT PRIMARY KEY,
  invoiceId TEXT,
  customer TEXT,
  amount NUMERIC NOT NULL,
  mode TEXT,
  date TEXT,
  account TEXT,
  depositedTo TEXT,
  reference TEXT,
  notes TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id TEXT PRIMARY KEY,
  vendor TEXT,
  vendorId TEXT,
  amount NUMERIC NOT NULL,
  category TEXT,
  description TEXT,
  date TEXT,
  type TEXT,
  reference TEXT,
  notes TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Vendors table
CREATE TABLE IF NOT EXISTS vendors (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  country TEXT,
  city TEXT,
  address TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Transfers table
CREATE TABLE IF NOT EXISTS transfers (
  id TEXT PRIMARY KEY,
  fromAccount TEXT,
  toAccount TEXT,
  amount NUMERIC NOT NULL,
  date TEXT,
  reference TEXT,
  notes TEXT,
  orgId TEXT REFERENCES organizations(id),
  createdAt TEXT,
  updatedAt TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Activities table (for logging)
CREATE TABLE IF NOT EXISTS activities (
  id TEXT PRIMARY KEY,
  userId TEXT REFERENCES users(id),
  action TEXT NOT NULL,
  resource TEXT,
  resourceId TEXT,
  changes JSONB,
  timestamp TEXT,
  orgId TEXT REFERENCES organizations(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Settings table
CREATE TABLE IF NOT EXISTS app_settings (
  id TEXT PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value TEXT,
  orgId TEXT REFERENCES organizations(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_orgId ON users(orgId);
CREATE INDEX IF NOT EXISTS idx_customers_orgId ON customers(orgId);
CREATE INDEX IF NOT EXISTS idx_invoices_orgId ON invoices(orgId);
CREATE INDEX IF NOT EXISTS idx_invoices_customer ON invoices(customer);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON invoices(status);
CREATE INDEX IF NOT EXISTS idx_payments_orgId ON payments(orgId);
CREATE INDEX IF NOT EXISTS idx_expenses_orgId ON expenses(orgId);
CREATE INDEX IF NOT EXISTS idx_vendors_orgId ON vendors(orgId);
CREATE INDEX IF NOT EXISTS idx_transfers_orgId ON transfers(orgId);
CREATE INDEX IF NOT EXISTS idx_activities_orgId ON activities(orgId);
CREATE INDEX IF NOT EXISTS idx_activities_userId ON activities(userId);
CREATE INDEX IF NOT EXISTS idx_activities_timestamp ON activities(timestamp);
