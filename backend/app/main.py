from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes_questionnaire import router as questionnaire_router
from app.api.routes_results import router as results_router
from app.api.routes_test_sessions import router as test_sessions_router
from app.core.config import get_settings
from app.core.db import Base, engine
import app.models  # noqa: F401 — register all ORM models before create_all


settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {"status": "ok"}


app.include_router(questionnaire_router)
app.include_router(test_sessions_router)
app.include_router(results_router)