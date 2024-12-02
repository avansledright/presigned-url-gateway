import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3Client = new S3Client({ 
    region: process.env.AWS_REGION,
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY!,
        secretAccessKey: process.env.AWS_SECRET_KEY!
    }
});

async function handleUpload() {
    const fileInput = document.getElementById('fileInput') as HTMLInputElement;
    if (!fileInput.files?.length) {
        alert('Please select a file');
        return;
    }

    const file = fileInput.files[0];
    const key = `uploads/${Date.now()}-${file.name}`;
    
    try {
        const command = new PutObjectCommand({
            Bucket: process.env.S3_BUCKET,
            Key: key,
            Body: file,
            ContentType: file.type
        });

        await s3Client.send(command);
        alert(`File uploaded successfully. Key: ${key}`);
    } catch (error) {
        console.error('Upload error:', error);
        alert('Upload failed');
    }
}

async function handleDownload() {
    const fileKeyInput = document.getElementById('fileKey') as HTMLInputElement;
    const fileKey = fileKeyInput.value.trim();
    
    if (!fileKey) {
        alert('Please enter a file key');
        return;
    }

    try {
        const response = await fetch(`${process.env.API_ENDPOINT}/getUrl?key=${encodeURIComponent(fileKey)}`, {
            method: 'GET'
        });
        
        if (!response.ok) throw new Error('Failed to get download URL');
        
        const data = await response.json();
        
        const downloadSection = document.getElementById('downloadSection');
        if (downloadSection) {
            downloadSection.innerHTML = `
                <p>Download link (expires in ${data.expires_in} seconds):</p>
                <a href="${data.url}" target="_blank">Download File</a>
            `;
        }
    } catch (error) {
        console.error('Download error:', error);
        alert('Failed to get download link');
    }
}

(window as any).handleUpload = handleUpload;
(window as any).handleDownload = handleDownload;