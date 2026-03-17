from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
import bcrypt
from datetime import datetime, timedelta, timezone
from typing import Optional
import jwt
import sqlite3
import os
import json

app = FastAPI(title="WiFi Access API", version="1.0.0")

# Disable CORS. Do not remove this for full-stack development.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Security
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "wifi-access-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # 7 days

security = HTTPBearer()


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')


def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

# Database setup
DB_PATH = "/data/app.db" if os.path.exists("/data") else "app.db"


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_db()
    cursor = conn.cursor()
    cursor.executescript("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            plan TEXT DEFAULT NULL,
            devices_connected INTEGER DEFAULT 0,
            data_used TEXT DEFAULT '0 MB',
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS hotspots (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            signal TEXT NOT NULL CHECK(signal IN ('strong', 'medium', 'weak')),
            type TEXT NOT NULL CHECK(type IN ('premium', 'basic')),
            country TEXT DEFAULT 'Romania'
        );

        CREATE TABLE IF NOT EXISTS plans (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price INTEGER NOT NULL,
            currency TEXT DEFAULT 'RON',
            period TEXT DEFAULT 'lună',
            features TEXT NOT NULL,
            popular INTEGER DEFAULT 0
        );
    """)

    # Seed plans if empty
    cursor.execute("SELECT COUNT(*) FROM plans")
    if cursor.fetchone()[0] == 0:
        plans_data = [
            ("basic", "Basic", 29, "RON", "lună", json.dumps(["500 MB/zi", "Acces în 175 de țări", "Suport standard", "1 dispozitiv"]), 0),
            ("premium", "Premium", 59, "RON", "lună", json.dumps(["Date nelimitate", "Acces în 175 de țări", "Suport prioritar 24/7", "3 dispozitive", "Viteză maximă"]), 1),
            ("family", "Family", 99, "RON", "lună", json.dumps(["Date nelimitate", "Acces în 175 de țări", "Suport VIP", "5 dispozitive", "Viteză maximă", "Parental control"]), 0),
        ]
        cursor.executemany("INSERT INTO plans VALUES (?, ?, ?, ?, ?, ?, ?)", plans_data)

    # Seed hotspots if empty
    cursor.execute("SELECT COUNT(*) FROM hotspots")
    if cursor.fetchone()[0] == 0:
        hotspots_data = [
            ("Bucharest Central WiFi", 44.4268, 26.1025, "strong", "premium", "Romania"),
            ("Cluj Innovation Hub", 46.7712, 23.6236, "strong", "premium", "Romania"),
            ("Timișoara Tech Park", 45.7489, 21.2087, "medium", "basic", "Romania"),
            ("Iași University WiFi", 47.1585, 27.6014, "strong", "premium", "Romania"),
            ("Constanța Beach WiFi", 44.1598, 28.6348, "medium", "basic", "Romania"),
            ("Brașov Mountain WiFi", 45.6427, 25.5887, "weak", "basic", "Romania"),
            ("Paris Centre WiFi", 48.8566, 2.3522, "strong", "premium", "France"),
            ("London City WiFi", 51.5074, -0.1278, "strong", "premium", "UK"),
            ("Berlin Hub WiFi", 52.5200, 13.4050, "medium", "basic", "Germany"),
            ("New York Downtown", 40.7128, -74.0060, "strong", "premium", "USA"),
        ]
        cursor.executemany(
            "INSERT INTO hotspots (name, latitude, longitude, signal, type, country) VALUES (?, ?, ?, ?, ?, ?)",
            hotspots_data,
        )

    conn.commit()
    conn.close()


# Initialize DB on startup
@app.on_event("startup")
async def startup():
    init_db()


# --- Models ---

class UserRegister(BaseModel):
    name: str
    email: str
    password: str


class UserLogin(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: dict


class PlanSelect(BaseModel):
    plan_id: str


# --- Auth Helpers ---

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("user_id")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Token invalid")
        return {"user_id": user_id, "email": payload.get("email")}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirat")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token invalid")


# --- Endpoints ---

@app.get("/healthz")
async def healthz():
    return {"status": "ok"}


@app.post("/api/auth/register", response_model=TokenResponse)
async def register(user: UserRegister):
    conn = get_db()
    cursor = conn.cursor()

    # Check if email exists
    cursor.execute("SELECT id FROM users WHERE email = ?", (user.email,))
    if cursor.fetchone():
        conn.close()
        raise HTTPException(status_code=400, detail="Email-ul este deja înregistrat")

    password_hash = hash_password(user.password)
    cursor.execute(
        "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)",
        (user.name, user.email, password_hash),
    )
    conn.commit()
    user_id = cursor.lastrowid
    conn.close()

    token = create_access_token({"user_id": user_id, "email": user.email})
    return TokenResponse(
        access_token=token,
        user={"id": user_id, "name": user.name, "email": user.email, "plan": None},
    )


@app.post("/api/auth/login", response_model=TokenResponse)
async def login(user: UserLogin):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE email = ?", (user.email,))
    row = cursor.fetchone()
    conn.close()

    if not row or not verify_password(user.password, row["password_hash"]):
        raise HTTPException(status_code=401, detail="Email sau parolă incorectă")

    token = create_access_token({"user_id": row["id"], "email": row["email"]})
    return TokenResponse(
        access_token=token,
        user={
            "id": row["id"],
            "name": row["name"],
            "email": row["email"],
            "plan": row["plan"],
        },
    )


@app.get("/api/user/profile")
async def get_profile(current_user: dict = Depends(get_current_user)):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = ?", (current_user["user_id"],))
    row = cursor.fetchone()
    conn.close()

    if not row:
        raise HTTPException(status_code=404, detail="Utilizator negăsit")

    return {
        "id": row["id"],
        "name": row["name"],
        "email": row["email"],
        "plan": row["plan"],
        "devices_connected": row["devices_connected"],
        "data_used": row["data_used"],
        "created_at": row["created_at"],
    }


@app.get("/api/plans")
async def get_plans():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM plans")
    rows = cursor.fetchall()
    conn.close()

    return [
        {
            "id": row["id"],
            "name": row["name"],
            "price": row["price"],
            "currency": row["currency"],
            "period": row["period"],
            "features": json.loads(row["features"]),
            "popular": bool(row["popular"]),
        }
        for row in rows
    ]


@app.post("/api/user/select-plan")
async def select_plan(plan: PlanSelect, current_user: dict = Depends(get_current_user)):
    conn = get_db()
    cursor = conn.cursor()

    cursor.execute("SELECT id FROM plans WHERE id = ?", (plan.plan_id,))
    if not cursor.fetchone():
        conn.close()
        raise HTTPException(status_code=404, detail="Planul nu a fost găsit")

    cursor.execute(
        "UPDATE users SET plan = ? WHERE id = ?",
        (plan.plan_id, current_user["user_id"]),
    )
    conn.commit()
    conn.close()

    return {"message": f"Planul {plan.plan_id} a fost activat cu succes"}


@app.get("/api/hotspots")
async def get_hotspots(country: Optional[str] = None, type: Optional[str] = None):
    conn = get_db()
    cursor = conn.cursor()

    query = "SELECT * FROM hotspots WHERE 1=1"
    params: list = []

    if country:
        query += " AND country = ?"
        params.append(country)
    if type:
        query += " AND type = ?"
        params.append(type)

    cursor.execute(query, params)
    rows = cursor.fetchall()
    conn.close()

    return [
        {
            "id": row["id"],
            "name": row["name"],
            "latitude": row["latitude"],
            "longitude": row["longitude"],
            "signal": row["signal"],
            "type": row["type"],
            "country": row["country"],
        }
        for row in rows
    ]


@app.get("/api/hotspots/{hotspot_id}")
async def get_hotspot(hotspot_id: int):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM hotspots WHERE id = ?", (hotspot_id,))
    row = cursor.fetchone()
    conn.close()

    if not row:
        raise HTTPException(status_code=404, detail="Hotspot-ul nu a fost găsit")

    return {
        "id": row["id"],
        "name": row["name"],
        "latitude": row["latitude"],
        "longitude": row["longitude"],
        "signal": row["signal"],
        "type": row["type"],
        "country": row["country"],
    }


@app.get("/api/stats")
async def get_stats():
    conn = get_db()
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(*) FROM users")
    users_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM hotspots")
    hotspots_count = cursor.fetchone()[0]

    conn.close()

    return {
        "countries": 175,
        "users": f"{max(users_count, 50000)}+",
        "hotspots": f"{max(hotspots_count, 10000)}+",
        "uptime": "99.9%",
    }
