import os

os.environ["FAMILY_API_ENV"] = "test"
os.environ["FAMILY_API_SECRET_KEY"] = "test-secret-key-for-family-api-unit-tests"
os.environ["FAMILY_API_DATABASE_URL"] = "sqlite:///:memory:"

from fastapi.testclient import TestClient

from app.config import get_settings
from app.main import app

get_settings.cache_clear()

client = TestClient(app)


def _register(email: str = "parent@example.com", password: str = "correct-horse-battery") -> dict:
    response = client.post(
        "/v1/auth/register",
        json={"email": email, "password": password, "parental_consent": True},
    )
    assert response.status_code == 200, response.text
    return response.json()


def test_health():
    assert client.get("/health").json()["status"] == "ok"


def test_register_requires_parental_consent():
    response = client.post(
        "/v1/auth/register",
        json={"email": "a@example.com", "password": "correct-horse-battery", "parental_consent": False},
    )
    assert response.status_code == 400


def test_login_rejects_wrong_password():
    _register("login@example.com")
    response = client.post(
        "/v1/auth/login",
        json={"email": "login@example.com", "password": "not-the-password"},
    )
    assert response.status_code == 401
    assert "Incorrect" in response.json()["detail"]


def test_child_sync_is_parent_scoped():
    parent_a = _register("a@example.com")
    parent_b = _register("b@example.com")
    child_id = "11111111-1111-1111-1111-111111111111"
    payload = {
        "child_id": child_id,
        "profile": {"id": child_id, "nickname": "Mia", "storedAge": 7},
        "completions": [{"id": "22222222-2222-2222-2222-222222222222", "lessonTitle": "Tide Pool Count"}],
    }
    created = client.put(
        f"/v1/children/{child_id}",
        json=payload,
        headers={"Authorization": f"Bearer {parent_a['access_token']}"},
    )
    assert created.status_code == 200, created.text

    stolen = client.get(
        "/v1/me",
        headers={"Authorization": f"Bearer {parent_b['access_token']}"},
    )
    assert stolen.status_code == 200
    assert stolen.json()["children"] == []

    forbidden = client.get(
        "/v1/me",
        headers={"Authorization": f"Bearer {parent_a['access_token']}"},
    )
    assert len(forbidden.json()["children"]) == 1
    assert forbidden.json()["children"][0]["profile"]["nickname"] == "Mia"

    blocked = client.put(
        f"/v1/children/{child_id}",
        json=payload,
        headers={"Authorization": f"Bearer {parent_b['access_token']}"},
    )
    assert blocked.status_code == 404


def test_account_delete_removes_children():
    session = _register("delete-me@example.com")
    child_id = "33333333-3333-3333-3333-333333333333"
    client.put(
        f"/v1/children/{child_id}",
        json={"child_id": child_id, "profile": {"id": child_id, "nickname": "Sam"}},
        headers={"Authorization": f"Bearer {session['access_token']}"},
    )
    deleted = client.delete(
        "/v1/account",
        headers={"Authorization": f"Bearer {session['access_token']}"},
    )
    assert deleted.status_code == 204
    missing = client.get(
        "/v1/me",
        headers={"Authorization": f"Bearer {session['access_token']}"},
    )
    assert missing.status_code == 401
