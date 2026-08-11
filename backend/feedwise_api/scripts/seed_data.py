from app.repositories.data_store import InMemoryStore


if __name__ == "__main__":
    store = InMemoryStore.with_seed_data()
    print(f"Seeded users: {len(store.users)}")
    print(f"Seeded scenarios: {len(store.scenarios)}")
    print(f"Seeded modules: {len(store.academy_modules)}")
