INSERT INTO storage.buckets (id, name)
    VALUES ('files', 'files');

CREATE POLICY "Allow unauthenticated users to upload files"
    ON storage.objects
    FOR INSERT
    TO anon
    WITH CHECK (bucket_id = 'files'::text);