#!/usr/bin/env pwsh
# deploy.ps1 — Build and deploy to Firebase Hosting

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Firebase Deploy Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check .env exists
if (-not (Test-Path ".env")) {
    Write-Host "[ERROR] .env file not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run these commands to set it up:" -ForegroundColor Yellow
    Write-Host "  Copy-Item .env.example .env" -ForegroundColor White
    Write-Host "  Then edit .env with your Firebase credentials." -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "[1/4] Installing dependencies..." -ForegroundColor Green
npm install
if ($LASTEXITCODE -ne 0) { Write-Host "[ERROR] npm install failed." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "[2/4] Building production bundle..." -ForegroundColor Green
npm run build
if ($LASTEXITCODE -ne 0) { Write-Host "[ERROR] Build failed." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "[3/4] Logging in to Firebase..." -ForegroundColor Green
firebase login
if ($LASTEXITCODE -ne 0) { Write-Host "[ERROR] Firebase login failed." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "[4/4] Deploying to Firebase Hosting..." -ForegroundColor Green
firebase deploy
if ($LASTEXITCODE -ne 0) { Write-Host "[ERROR] Deploy failed." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
