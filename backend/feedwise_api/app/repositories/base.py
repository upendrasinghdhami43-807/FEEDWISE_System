from __future__ import annotations

from app.repositories.data_store import InMemoryStore


class BaseRepository:
    def __init__(self, store: InMemoryStore) -> None:
        self.store = store
