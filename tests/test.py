import asyncio
import os
import sys
import tempfile
from pathlib import Path
from fastapi.testclient import TestClient
from pytest import fixture
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.configs import settings
from core.dependency import get_session
from main import app

TEST_DATABASE_FILE = os.path.join(tempfile.gettempdir(), 'test_crud_fastapi.db')
TEST_DATABASE_URL = f'sqlite+aiosqlite:///{TEST_DATABASE_FILE}'

engine = create_async_engine(
    TEST_DATABASE_URL,
    connect_args={'check_same_thread': False},
    echo=False,
)

TestSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
    autocommit=False,
)

async def init_test_db():
    async with engine.begin() as connection:
        await connection.run_sync(settings.DBBaseModel.metadata.drop_all)
        await connection.run_sync(settings.DBBaseModel.metadata.create_all)

async def shutdown_test_db():
    await engine.dispose()
    if os.path.exists(TEST_DATABASE_FILE):
        os.remove(TEST_DATABASE_FILE)

async def override_get_session():
    async with TestSessionLocal() as session:
        yield session

@fixture(scope='session', autouse=True)
def prepare_test_database():
    asyncio.run(init_test_db())
    app.dependency_overrides[get_session] = override_get_session
    yield
    app.dependency_overrides.clear()
    asyncio.run(shutdown_test_db())


def test_course_crud_flow():
    client = TestClient(app)

    payload = {
        'titulo': 'Curso de Teste',
        'aulas': 10,
        'horas': 20,
    }

    response = client.post('/api/v1/courses/', json=payload)
    assert response.status_code == 201
    course = response.json()
    assert course['id'] is not None
    assert course['titulo'] == payload['titulo']
    assert course['aulas'] == payload['aulas']
    assert course['horas'] == payload['horas']

    course_id = course['id']

    response = client.get('/api/v1/courses/')
    assert response.status_code == 200
    assert any(item['id'] == course_id for item in response.json())

    response = client.get(f'/api/v1/courses/{course_id}')
    assert response.status_code == 200
    assert response.json()['titulo'] == payload['titulo']

    updated_payload = {
        'titulo': 'Curso Atualizado',
        'aulas': 12,
        'horas': 24,
    }

    response = client.put(f'/api/v1/courses/{course_id}', json=updated_payload)
    assert response.status_code == 202
    assert response.json()['titulo'] == updated_payload['titulo']
    assert response.json()['aulas'] == updated_payload['aulas']
    assert response.json()['horas'] == updated_payload['horas']

    response = client.delete(f'/api/v1/courses/{course_id}')
    assert response.status_code == 204

    response = client.get(f'/api/v1/courses/{course_id}')
    assert response.status_code == 404
   