# SkillSwap 🎯

### Learn from your peers. Share what you know. Grow together.

SkillSwap is a peer-to-peer skill exchange platform designed to help college students connect with fellow learners from similar academic backgrounds, fields, and age groups to share knowledge and learn practical skills from one another.

Instead of relying only on traditional courses, SkillSwap encourages students to discover skills, explore other learners' profiles, and initiate collaborative learning sessions.

**Project Type:** Academic End-Semester Project · MVP

---

## 📌 Overview

Everyone has something to teach, and everyone has something to learn.

Students often develop useful skills but struggle to find peers who can help them learn something new. SkillSwap aims to make peer learning easier by providing a platform where students can explore skills, discover other learners, and exchange knowledge.

The goal is to build a community where learning is collaborative rather than one-sided.

## ✨ Features

- **User Authentication:** Sign up and sign in using Firebase Authentication with email and password.
- **Explore Skills:** Browse available skills and discover learning opportunities.
- **Skill Categories:** Explore skills through organized categories.
- **User Profiles:** View other learners' profiles and skills.
- **Skill Exchange Requests:** Initiate requests to exchange skills with other users.
- **Quick Sessions:** Access a quick way to initiate a learning interaction.
- **Request Management:** View sent requests, received requests, and active requests or sessions.

*The project is an MVP. Feature availability depends on the current implementation.*

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Mobile app programming language |
| Firebase Authentication | Email/password authentication |
| Node.js | Backend runtime |
| Express.js | Backend API framework |
| PostgreSQL | Relational database |
| Cloudflare Tunnel | Temporary remote access to the local API |
| Git and GitHub | Version control and project hosting |

Other Firebase services, if any, should be added after confirming their use in the current implementation.

## 🏗️ System Architecture

```text
┌─────────────────────────────┐
│        Flutter App          │
│        (Dart / UI)           │
└──────────────┬──────────────┘
               │
               │ HTTP API Requests
               ▼
┌─────────────────────────────┐
│      Cloudflare Tunnel      │
│   (Optional Development)    │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       Express.js API        │
│       Node.js Runtime       │
│       Local Port: 5000      │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│         PostgreSQL          │
└─────────────────────────────┘

Firebase Authentication
provides the app's authentication flow.
```

The Flutter frontend communicates with the backend through HTTP API requests. The backend uses PostgreSQL for relational data storage.

Cloudflare Tunnel can expose the locally running API for remote development and testing. It is optional and is not a permanent production hosting solution.

## 📁 Project Structure

The repository contains the Flutter frontend and backend in one project.

```text
SkillSwap/
├── lib/                 # Flutter application source
├── android/             # Android platform configuration
├── assets/              # Application assets, if present
├── test/                # Flutter tests, if present
├── backend/             # Node.js / Express backend
├── pubspec.yaml         # Flutter dependencies
├── .gitignore
└── README.md
```

This is a representative structure. Adjust folder names to match the actual repository.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio
- Node.js and npm
- PostgreSQL
- A configured Firebase project
- Cloudflare Tunnel, if remote backend access is needed

### 1. Clone the Repository

```bash
git clone https://github.com/CodesWithManthan/skill-swap
cd SkillSwap
```

### 2. Set Up the Flutter Frontend

Install Flutter dependencies:

```bash
flutter pub get
```

Configure Firebase using the configuration required by the project.

Start an Android emulator or connect a compatible device, then run:

```bash
flutter run
```

Ensure the app's API base URL points to the correct backend address for your environment.

### 3. Set Up the Backend

Open a terminal in the backend directory:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

If the repository contains a valid `package-lock.json`, you can use `npm ci` for a clean, reproducible dependency installation.

Configure the environment variables required by the backend. For example, database connection settings may be supplied through a local `.env` file if the application is configured to use one.

Do not commit real credentials or secret environment files.

Ensure PostgreSQL is running and the required database and schema have been configured.

### 4. Start the Backend

Run:

```bash
npm run dev
```

This command runs the `dev` script defined in the backend's `package.json`.

For example, the script might use `nodemon` to restart the server when source files change. The actual command depends on the project's configuration.

The backend is expected to run locally on port `5000` in the current development setup.

**Note:** The exact entry-point file, database initialization command, and required environment variables depend on the backend implementation.

### 5. Expose the Backend Using Cloudflare Tunnel (Optional)

For remote device testing, first start the backend, then open a separate terminal and run:

```bash
cloudflared tunnel --url http://localhost:5000
```

Cloudflare Tunnel will provide a temporary public URL that can forward requests to the local API.

Use the generated URL as the Flutter app's API base URL when remote access is required.

Quick Tunnel URLs can change when a new tunnel is started. Do not treat a temporary development URL as a permanent production endpoint.

For local Android emulator testing, ensure the app uses an address that can reach the host machine. The emulator's `localhost` is not the same as your computer's `localhost`.

## 🔌 API Endpoints

The following routes have been used during development. Confirm the current Express route definitions before treating this table as a complete API specification.

| Endpoint | Purpose |
|---|---|
| `GET /api/v1/skills` | Retrieve available skills |
| `GET /api/v1/users/1` | Retrieve a user by ID |
| `GET /api/v1/requests/sent/1` | Retrieve sent requests |
| `GET /api/v1/requests/incoming/1` | Retrieve incoming requests |
| `GET /api/v1/requests/active/1` | Retrieve active requests |

The user ID `1` in these examples is illustrative of the development routes. Request methods, response formats, and authentication requirements should be documented according to the actual backend implementation.

## 🔐 Security

- Never commit database passwords, secret environment files, or private keys.
- Keep sensitive configuration in environment variables.
- Configure Firebase security rules appropriately.
- Validate input and enforce authorization on the backend.
- Avoid publishing private user information or database dumps.
- Use an appropriately secured deployment for production rather than relying on a development tunnel.

## 🛣️ Future Improvements

Potential areas for future development include:

- Better matching between learners and skill providers.
- Session scheduling and availability management.
- In-app messaging and notifications.
- Improved profiles and skill verification.
- More complete session lifecycle management.
- Production deployment and stronger API security.

These are potential enhancements, not claims that they are already implemented.

## 🎓 Project Information

**Project Name:** SkillSwap  
**Project Type:** Academic End-Semester Project  
**Domain:** Mobile Application Development · Peer-to-Peer Learning

## 👨‍💻 Author

**Challa Manthan**

Developed as an academic project exploring mobile application development, backend API integration, relational database management, and collaborative learning.
