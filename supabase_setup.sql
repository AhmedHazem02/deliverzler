-- =====================================================
-- Supabase SQL Setup for Driver Documents Storage
-- =====================================================
-- Run this in the Supabase SQL Editor
-- Project Settings > Database > SQL Editor

-- 1. Create Storage Bucket for Driver Documents
-- =====================================================
-- Go to Storage in Supabase Dashboard and create bucket manually
-- OR run this if you have admin access:

INSERT INTO storage.buckets (id, name, public)
VALUES ('driver-documents', 'driver-documents', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 2. Storage Policies - Allow authenticated users to upload
-- =====================================================

-- Policy: Allow authenticated users to upload their own documents
CREATE POLICY "Users can upload their own documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'driver-documents' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy: Allow users to update their own documents
CREATE POLICY "Users can update their own documents"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'driver-documents' 
  AND (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
  bucket_id = 'driver-documents' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy: Allow users to delete their own documents
CREATE POLICY "Users can delete their own documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'driver-documents' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy: Allow public read access to all documents
CREATE POLICY "Public read access for driver documents"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'driver-documents');

-- =====================================================
-- Alternative: If using anon key (no Supabase Auth)
-- =====================================================
-- Use these policies instead if drivers use Firebase Auth

-- Policy: Allow anyone to upload (with anon key)
CREATE POLICY "Allow uploads with anon key"
ON storage.objects FOR INSERT
TO anon
WITH CHECK (bucket_id = 'driver-documents');

-- Policy: Allow anyone to read
CREATE POLICY "Allow public reads"
ON storage.objects FOR SELECT
TO anon
USING (bucket_id = 'driver-documents');

-- Policy: Allow updates with anon key
CREATE POLICY "Allow updates with anon key"
ON storage.objects FOR UPDATE
TO anon
USING (bucket_id = 'driver-documents')
WITH CHECK (bucket_id = 'driver-documents');

-- Policy: Allow deletes with anon key
CREATE POLICY "Allow deletes with anon key"
ON storage.objects FOR DELETE
TO anon
USING (bucket_id = 'driver-documents');

-- =====================================================
-- IMPORTANT NOTES:
-- =====================================================
-- 
-- 1. Create the bucket first via Dashboard:
--    Storage > New Bucket > Name: "driver-documents" > Public: ON
--
-- 2. Choose ONE set of policies:
--    - If using Supabase Auth: Use the authenticated policies
--    - If using Firebase Auth (anon key): Use the anon policies
--
-- 3. To verify setup, try uploading a test image:
--    - Use the Supabase Dashboard > Storage > driver-documents
--    - Upload a test file
--
-- 4. Get your Supabase URL and Anon Key from:
--    Project Settings > API > Project URL
--    Project Settings > API > Project API keys > anon public
--
-- 5. Add to configs/dev.json:
--    "SUPABASE_URL": "https://xxxxx.supabase.co",
--    "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIs..."
--
-- =====================================================

-- Optional: Create a table to track uploads (for admin dashboard)
-- =====================================================

CREATE TABLE IF NOT EXISTS public.document_uploads (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  document_type TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_url TEXT NOT NULL,
  file_size BIGINT,
  content_type TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.document_uploads ENABLE ROW LEVEL SECURITY;

-- Policy: Users can see their own uploads
CREATE POLICY "Users can view own uploads"
ON public.document_uploads FOR SELECT
TO anon, authenticated
USING (true);

-- Policy: Users can insert their uploads
CREATE POLICY "Users can insert uploads"
ON public.document_uploads FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Index for faster queries
CREATE INDEX IF NOT EXISTS idx_document_uploads_user_id 
ON public.document_uploads(user_id);

CREATE INDEX IF NOT EXISTS idx_document_uploads_document_type 
ON public.document_uploads(document_type);
