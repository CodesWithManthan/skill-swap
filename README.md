# SkillSwap 🎯

### Learn from your peers. Share what you know. Grow together.

SkillSwap is a peer-to-peer skill exchange platform designed to connect college students with people from similar academic backgrounds, fields, and age groups so they can learn from one another through collaborative sessions.

Instead of relying only on traditional courses, SkillSwap encourages students to discover skills, connect with fellow learners, and exchange practical knowledge.

> **Project Type:** Academic End-Semester Project | MVP

---

## 📌 Overview

Learning a new skill is easier when you have someone to learn with.

Students often have valuable skills but lack an easy way to find peers who can teach them something new in return. SkillSwap aims to bridge this gap by creating a platform where students can explore skills, discover other learners, and initiate skill exchange sessions.

The goal is simple: **everyone has something to teach, and everyone has something to learn.**

## ✨ Features

- **🔐 User Authentication**  
  Sign up and sign in using Firebase Authentication.

- **🔎 Explore Skills**  
  Browse available skills and discover learning opportunities.

- **🗂️ Skill Categories**  
  Explore skills through organized categories.

- **👤 User Profiles**  
  View profiles and learn about other users and their skills.

- **🤝 Skill Exchange Requests**  
  Initiate requests to learn from or exchange skills with other users.

- **⚡ Quick Sessions**  
  Provide a quick way to initiate a learning interaction.

- **📋 Request Management**  
  View sent requests, received requests, and active sessions or requests.

*Note: Features and workflows may differ between the current MVP and the planned final product. See the implementation and project setup for the current state.*

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application |
| Dart | Frontend development |
| Firebase Authentication | User authentication |
| Cloud Firestore / Firebase Storage | Firebase services used by the app, where configured |
| Backend API | Application logic and data access |
| PostgreSQL | Relational database |
| Cloudflare Tunnel | Exposing the local API for development and testing |

**Backend framework:** To be confirmed.

## 🏗️ Architecture

The application uses a frontend, backend, and database architecture.

```text
┌─────────────────────────┐
│     Flutter App         │
│     (Dart / UI)         │
└────────────┬────────────┘
             │
             │ HTTP API Requests
             ▼
┌─────────────────────────┐
│   Cloudflare Tunnel     │
│   (Development Access)  │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      Backend API        │
│   localhost:5000        │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      PostgreSQL         │
│       Database          │
└─────────────────────────┘
```

Cloudflare Tunnel is used to expose the locally running backend API when remote access is needed. It does not host the backend or database itself.

Firebase Authentication is used separately for the app's authentication flow.

## 📁 Project Structure

The repository contains the Flutter application and its backend in one place.

```text
SkillSwap/
├── android/              # Android platform configuration
├── assets/               # Application assets, if present
├── lib/                  # Flutter application source
├── test/                 # Application tests, if present
├── backend/              # Backend API source
├── pubspec.yaml          # Flutter dependencies
├── .gitignore
└── README.md
```

*Folder names are illustrative. Update this tree to match the actual repository.*

## 🚀 Getting Started

### Prerequisites

Install the following tools before running the project:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [Git](https://git-scm.com/)
- [PostgreSQL](https://www.postgresql.org/download/)
- The runtime and dependencies required by the backend
- A configured Firebase project

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/SkillSwap.git
cd SkillSwap
```

Replace `YOUR_USERNAME` with the repository owner's GitHub username.

### 2. Set Up the Flutter Application

Install the Flutter dependencies:

```bash
flutter pub get
```

Configure the Firebase project using the appropriate Firebase configuration for the application.

Open the project in Android Studio, connect an emulator or Android device, and run:

```bash
flutter run
```

### 3. Set Up the Backend

Navigate to the backend directory:

```bash
cd backend
```

Install the dependencies using the package manager appropriate to the backend framework.

Configure the required environment variables, including the database connection settings. Use a local `.env` file if that is how the backend is configured.

Start PostgreSQL and ensure the required database and schema are available.

**Backend framework, dependency installation command, database initialization instructions, and startup command must be documented here once confirmed.**

The backend is expected to be accessible locally at:

```text
http://localhost:5000
```

This address is the backend's local development endpoint, not a permanent public URL.

### 4. Configure Cloudflare Tunnel (Optional)

For remote device testing, a Cloudflare Quick Tunnel can expose the locally running backend.

Start the backend first, then run:

```bash
cloudflared tunnel --url http://localhost:5000
```

Cloudflare will provide a temporary public URL.

Configure the Flutter application's API base URL to use that URL when remote access is required.

**Important:** Quick Tunnel URLs are temporary and may change when a new tunnel is started. Do not hardcode a temporary URL as the production endpoint.

For local testing, configure the app to use the appropriate local development address for the device or emulator.

## 🔌 API Endpoints

The following routes have been used during development. Confirm the current backend implementation before treating this list as the final API contract.

| Endpoint | Purpose |
|---|---|
| `GET /api/v1/skills` | Retrieve available skills |
| `GET /api/v1/users/1` | Retrieve a user by ID |
| `GET /api/v1/requests/sent/1` | Retrieve sent requests |
| `GET /api/v1/requests/incoming/1` | Retrieve incoming requests |
| `GET /api/v1/requests/active/1` | Retrieve active requests |

The example user ID `1` is illustrative of the development routes. Replace it with the appropriate ID when testing other users.

Document the remaining request methods, payloads, responses, and authentication requirements alongside the final API implementation.

## 🔒 Security Notes

- Never commit real database credentials, private API keys, or secret environment files.
- Keep local environment variables out of version control.
- Use appropriate Firebase security rules.
- Validate and authorize requests on the backend.
- Use a stable, appropriately secured deployment for production rather than relying on a development tunnel.
- Avoid publishing real user data or private database exports.

## 🗺️ Future Improvements

Potential improvements for future versions include:

- Smarter matching between learners and skill providers.
- Session scheduling and availability management.
- In-app messaging and notifications.
- More detailed profiles and skill verification.
- Improved request lifecycle management.
- Production deployment and API security improvements.

These are possible future enhancements, not claims about features already implemented.

## 🎓 Project Information

**Project:** SkillSwap  
**Type:** Academic End-Semester Project  
**Domain:** Mobile Application Development / Peer-to-Peer Learning

## 👨‍💻 Author

**[Your Name]**

Built as an academic project exploring mobile application development, backend integration, database management, and peer-to-peer learning.

## 📄 License

A license has not yet been selected. Add an appropriate license file if you intend to distribute the project under explicit open-source terms.
