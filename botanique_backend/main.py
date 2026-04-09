from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from routes import user, plant, identification

app = FastAPI(title="Botanique")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user.router)
app.include_router(plant.router)
app.include_router(identification.router)

@app.get("/health")
def health_check():
    return {"status": "healthy"}