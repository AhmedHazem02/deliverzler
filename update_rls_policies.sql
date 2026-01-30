-- =====================================================
-- Supabase SQL Update: Fix RLS for Firebase Auth (Anonymous Uploads)
-- =====================================================
-- Run this in the Supabase SQL Editor to switch from Authenticated to Anonymous policies.

-- 1. Drop existing Authenticated policies (if they exist)
-- =====================================================
DROP POLICY IF EXISTS "Users can upload their own documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own documents" ON storage.objects;
DROP POLICY IF EXISTS "Public read access for driver documents" ON storage.objects;


-- 2. Create Anonymous Policies (for Firebase Auth users)
-- =====================================================

-- Policy: Allow uploads with anon key (since Firebase users are 'anon' to Supabase)
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
