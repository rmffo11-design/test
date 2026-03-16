import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes_questionnaire import router as questionnaire_router
from app.api.routes_results import router as results_router
from app.api.routes_test_sessions import router as test_sessions_router
from app.core.config import get_settings
from app.core.db import Base, engine
import app.models  # noqa: F401 — register all ORM models before create_all

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("app")

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        logger.info("Starting up — creating DB tables")
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
        logger.info("DB tables ready")
    except Exception as exc:
        logger.warning("DB table creation failed (tables may already exist): %s", exc)
    yield
    logger.info("Shutting down")


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    response = await call_next(request)
    duration_ms = round((time.time() - start) * 1000)
    logger.info(
        "%s %s %s %dms",
        request.method,
        request.url.path,
        response.status_code,
        duration_ms,
    )
    return response


@app.get("/")
async def root():
    return {"status": "ok"}


app.include_router(questionnaire_router)
app.include_router(test_sessions_router)
app.include_router(results_router)
