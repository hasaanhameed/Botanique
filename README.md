# Botanique

**Your Premium Plant Identification Companion**

Botanique is a full-stack mobile application that leverages AI-powered image recognition to identify plants and provide detailed care instructions. Whether you're a gardening enthusiast, a casual plant parent, or a botanist, Botanique transforms plant identification from a guessing game into an intelligent, instant experience.

---

## Features

### Core Capabilities

- **AI-Powered Plant Identification**: Upload a photo of any plant to instantly identify it using advanced image recognition powered by PlantNet API.
- **Intelligent Care Instructions**: Get detailed, AI-generated care recommendations including watering schedules, lighting requirements, temperature conditions, and seasonal guidance via Groq LLM.
- **User Authentication**: Secure email/password authentication with JWT-based access tokens through Supabase.
- **Identification History**: View and track all past plant identifications with timestamps and images.
- **Rate Limiting**: Fair usage enforcement with 5 identifications per hour per user to optimize API costs.
- **Redis Caching**: Intelligent caching of plant details with a 7-day TTL to reduce redundant API calls and improve response times.
- **Dark/Light Theme**: Customizable theme support with a beautiful dark green aesthetic as the default.
- **User Profile Management**: Track identification statistics, manage account settings, and update security credentials.

---

## Technology Stack

### Frontend
- **Framework**: Flutter
- **Language**: Dart
- **Key Dependencies**:
  - `http` - HTTP client for API communication
  - `image_picker` - Camera and gallery access
  - `lottie` - Smooth animations
  - `dotted_border` - UI enhancements

### Backend
- **Framework**: FastAPI 
- **Key Dependencies**:
  - `supabase` - Database and authentication
  - `httpx` - Async HTTP requests
  - `redis` - Caching and rate limiting
  - `bcrypt` - Password hashing

### Infrastructure
- **Database**: Supabase (PostgreSQL + Auth)
- **Cache/Rate Limiting**: Redis
- **Authentication**: JWT tokens via Supabase Auth
- **External AI Services**:
  - PlantNet API v2 - Plant image recognition
  - Groq LLM (llama-3.3-70b-versatile) - Care instruction generation
- **Container Runtime**: Docker & Docker Compose

---

## Project Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Frontend                          │
│  (Dashboard → Image Selection → Identification Results)     │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP/HTTPS
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   FastAPI Backend                            │
│  (Authentication, Plant Identification, History)            │
└────┬────────────────┬────────────────┬─────────────────────┘
     │                │                │
     ▼                ▼                ▼
  Supabase         Redis Cache      PlantNet + Groq
  (Database)    (Cache/Rate Limit)  (AI Services)
```

### Backend Route Structure

| Route | Method | Purpose |
|-------|--------|---------|
| `/health` | GET | Health check endpoint |
| `/user/signup` | POST | User registration |
| `/user/signin` | POST | User login |
| `/user/profile` | GET | Fetch user profile (authenticated) |
| `/user/update-password` | POST | Change password (authenticated) |
| `/user/delete` | DELETE | Account deletion (authenticated) |
| `/plant/identify` | POST | Identify plant from image |
| `/identification/history` | GET | Get user's identification history (authenticated) |

---

## Getting Started

### Prerequisites

**Backend Requirements:**
- Python 3.10+
- Redis server (or Docker)
- Supabase account with project credentials
- PlantNet API key
- Groq API key
- Docker and Docker Compose (for containerized deployment)

**Frontend Requirements:**
- Flutter SDK (3.11.0 or higher)
- Dart SDK (included with Flutter)
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- A connected device or emulator

### Backend Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/botanique.git
   cd botanique/botanique_backend
   ```

2. **Create a Python virtual environment:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Create a `.env` file** in the `botanique_backend` directory:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_anon_key
   SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
   PLANTNET_API_KEY=your_plantnet_api_key
   GROQ_API_KEY=your_groq_api_key
   REDIS_URL=redis://localhost:6379
   ```

5. **Start Redis** (if not using Docker):
   ```bash
   redis-server
   ```

6. **Run the backend server:**
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```
   The API will be available at `http://localhost:8000`. Swagger UI documentation is at `http://localhost:8000/docs`.

### Frontend Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/botanique.git
   cd botanique/botanique_frontend
   ```

2. **Get Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure the API endpoint** in `lib/constants/api_constants.dart`:
   ```dart
   // Development
   static const String baseUrl = 'http://127.0.0.1:8000';
   
   // Production
   static const String baseUrl = 'https://api.botanique.app';
   ```
   For mobile testing, use ADB reverse port forwarding:
   ```bash
   adb reverse tcp:8000 tcp:8000
   ```

4. **Run on your target platform:**
   ```bash
   flutter run -d <device_id>
   ```
   Or run on a specific platform:
   ```bash
   flutter run -d chrome           # Web
   flutter run -d emulator-5554    # Android Emulator
   flutter run -d iPhone           # iOS Simulator
   ```

---

## Authentication

Botanique uses **JWT-based authentication** via Supabase Auth:

1. **Signup/Login**: User creates account via Supabase Auth, receives JWT access token
2. **Token Storage**: Frontend stores token in memory/secure storage
3. **Request Headers**: All authenticated requests include `Authorization: Bearer <token>`
4. **Token Validation**: Backend extracts and validates token with Supabase
5. **Expiry**: Tokens follow Supabase's default expiry (typically 1 hour)

**Implementation:**
- Backend: `auth_token/current_user.py` - Validates JWT from incoming requests
- Frontend: `services/auth_service.dart` - Manages login, token storage, and authenticated requests

---

## Caching Strategy

### Plant Details Cache

- **Purpose**: Reduce redundant calls to Groq LLM for common plants
- **Storage**: Redis
- **Key Format**: `plant_details:{plant_name}`
- **TTL**: 7 days
- **Hit Rate Benefit**: First user identifies a common plant (e.g., "Rose"), backend calls Groq. Subsequent users get instant cached response.

### Rate Limiting Cache

- **Purpose**: Enforce fair usage (5 identifications per hour per user)
- **Storage**: Redis
- **Key Format**: `rate_limit:{user_id}`
- **Window**: 1-hour sliding window
- **Behavior**: If limit exceeded, returns 429 status code with message
- **Fallback**: If Redis is unavailable, requests are allowed to maintain availability (fail-open strategy)

---

## Deployment

### Docker Compose Setup

The project includes a `docker-compose.yml` for easy containerized deployment:

```yaml
services:
  backend:
    image: ghcr.io/hasaanhameed/botanique-backend:latest
    ports:
      - "8000:8000"
    environment:
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_KEY=${SUPABASE_KEY}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
      - PLANTNET_API_KEY=${PLANTNET_API_KEY}
      - GROQ_API_KEY=${GROQ_API_KEY}
    depends_on:
      - redis
    restart: always

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    restart: always
```

### Deployment Steps

1. **Build and push the Docker image:**
   ```bash
   docker build -f botanique_backend/Dockerfile -t ghcr.io/yourusername/botanique-backend:latest .
   docker push ghcr.io/yourusername/botanique-backend:latest
   ```

2. **Set environment variables** on your deployment platform (e.g., GitHub Secrets, environment file)

3. **Deploy with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

4. **For Flutter frontend**: Build platform-specific releases:
   ```bash
   flutter build android --release      # Android APK/AAB
   flutter build ios --release          # iOS IPA
   flutter build web --release          # Web
   ```

---

## Project Structure

```
botanique/
├── botanique_backend/
│   ├── main.py                      # FastAPI app initialization
│   ├── requirements.txt             # Python dependencies
│   ├── Dockerfile                   # Container image
│   ├── auth_token/
│   │   └── current_user.py         # JWT validation
│   ├── database/
│   │   ├── database.py             # Supabase client
│   │   └── redis_client.py         # Redis connection
│   ├── routes/
│   │   ├── user.py                 # /user endpoints
│   │   ├── plant.py                # /plant endpoints
│   │   └── identification.py       # /identification endpoints
│   ├── schemas/
│   │   ├── user.py                 # User Pydantic models
│   │   ├── plant.py                # Plant models
│   │   └── identification.py       # Identification models
│   └── services/
│       ├── auth_service.py         # (if using local auth)
│       ├── plant_service.py        # PlantNet + Groq integration
│       ├── identification_service.py # Save/fetch identifications
│       ├── cache_service.py        # Redis caching
│       └── rate_limit_service.py   # Rate limiting logic
│
├── botanique_frontend/
│   ├── lib/
│   │   ├── main.dart               # App entry point
│   │   ├── constants/
│   │   │   └── api_constants.dart  # API configuration
│   │   ├── pages/                  # Screens (login, dashboard, etc.)
│   │   ├── services/               # API service classes
│   │   ├── notifiers/              # State management
│   │   ├── widgets/                # Reusable UI components
│   │   └── schemas/                # Data models
│   ├── pubspec.yaml                # Flutter dependencies
│   ├── assets/
│   │   ├── animations/             # Lottie JSON files
│   │   ├── images/                 # App images
│   │   └── fonts/                  # Custom fonts
│   └── [platform-specific]/        # Android, iOS, Web, Linux, macOS, Windows
│
├── docker-compose.yml              # Multi-container orchestration
└── README.md                        # This file
```

---

## Development

### Backend Development

1. **Run with auto-reload:**
   ```bash
   uvicorn botanique_backend.main:app --reload --host 0.0.0.0 --port 8000
   ```

2. **API Documentation:** Visit `http://localhost:8000/docs` for Swagger UI

3. **Linting and formatting (optional, if configured):**
   ```bash
   black botanique_backend/
   pylint botanique_backend/
   ```

### Frontend Development

1. **Run on connected device/emulator:**
   ```bash
   flutter run
   ```

2. **Enable widget inspection (for debugging UI):**
   ```bash
   flutter run -v
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

4. **Build for specific platform:**
   ```bash
   flutter build web --release
   ```

---

## Future Enhancements

- **Premium Tier**: Higher rate limits and priority support
- **Push Notifications**: Plant care reminders and watering schedules
- **Plant Collection**: Save and organize favorite plants
- **Social Features**: Share identifications with friends, community forums
- **Offline Identification**: On-device ML model for internet-free identification
- **AR Visualization**: Augmented reality plant visualization and placement preview
- **Plant Nursery Integration**: Direct purchasing links to buy identified plants
- **Multi-Language Support**: Internationalization for global users
- **Advanced Analytics**: Detailed plant care statistics and seasonal recommendations

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Support

For issues, questions, or suggestions, please open an issue on the GitHub repository or reach out through our contact channels.

**Built with Flutter and FastAPI**

