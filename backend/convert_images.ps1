# Image Conversion Script for Windows
# This script converts AVIF and WebP images to JPG format

$sourcePath = "D:\FlutterLaravelecommercial\ecommercial\backend\uploads"
$outputPath = "D:\FlutterLaravelecommercial\ecommercial\backend\uploads_converted"

# Create output directory if it doesn't exist
if (!(Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath | Out-Null
}

Write-Host "Converting images from AVIF/WebP to JPG..." -ForegroundColor Green
Write-Host "Source: $sourcePath" -ForegroundColor Cyan
Write-Host "Output: $outputPath" -ForegroundColor Cyan
Write-Host ""

# Get all AVIF and WebP files
$images = Get-ChildItem -Path $sourcePath -Include *.avif,*.webp -Recurse

if ($images.Count -eq 0) {
    Write-Host "No AVIF or WebP images found!" -ForegroundColor Yellow
    exit
}

Write-Host "Found $($images.Count) images to convert" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: This script requires one of the following:" -ForegroundColor Red
Write-Host "1. ImageMagick installed (recommended)" -ForegroundColor Yellow
Write-Host "2. Or you can use an online converter" -ForegroundColor Yellow
Write-Host ""

# Check if ImageMagick is installed
$magickPath = Get-Command magick -ErrorAction SilentlyContinue

if ($magickPath) {
    Write-Host "ImageMagick found! Converting..." -ForegroundColor Green
    
    foreach ($image in $images) {
        $outputFile = Join-Path $outputPath ($image.BaseName + ".jpg")
        Write-Host "Converting: $($image.Name) -> $($image.BaseName).jpg"
        
        & magick convert $image.FullName $outputFile
    }
    
    Write-Host ""
    Write-Host "Conversion complete! Files saved to: $outputPath" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Copy the converted JPG files back to the uploads folder" -ForegroundColor White
    Write-Host "2. Update your database to use .jpg extensions instead of .avif/.webp" -ForegroundColor White
    
} else {
    Write-Host "ImageMagick not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install ImageMagick:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://imagemagick.org/script/download.php#windows" -ForegroundColor White
    Write-Host "2. Run the installer and make sure to check 'Add to PATH'" -ForegroundColor White
    Write-Host "3. Restart PowerShell and run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "OR use an online converter:" -ForegroundColor Yellow
    Write-Host "- https://convertio.co/avif-jpg/" -ForegroundColor White
    Write-Host "- https://cloudconvert.com/avif-to-jpg" -ForegroundColor White
}
