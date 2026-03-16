from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.pool import NullPool

from .config import get_settings


settings = get_settings()


class Base(DeclarativeBase):
    pass


_is_supabase = "supabase" in settings.DATABASE_URL
_is_transaction_pooler = ":6543" in settings.DATABASE_URL

_connect_args: dict = {}
if _is_supabase:
    _connect_args["ssl"] = "require"
if _is_transaction_pooler:
    # asyncpg: disable prepared statement cache for Supabase Transaction Pooler
    _connect_args["statement_cache_size"] = 0

# Use NullPool with Transaction Pooler (pgBouncer already pools connections;
# SQLAlchemy's own pool causes stale-connection 500s after long idle periods)
_pool_kwargs: dict = (
    {"poolclass": NullPool}
    if _is_transaction_pooler
    else {"pool_pre_ping": True, "pool_recycle": 300}
)

engine = create_async_engine(
    settings.DATABASE_URL,
    echo=False,
    future=True,
    connect_args=_connect_args,
    **_pool_kwargs,
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        yield session
