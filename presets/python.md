# Preset: Python

- Env/runner: uv.lock → `uv run`, poetry.lock → `poetry run`, Pipfile → `pipenv run`, else venv + pip.
- Test: `pytest -q`; single: `pytest path/test_x.py::test_name -q`.
- Lint/format: ruff (`ruff check . && ruff format --check .`) or black/flake8 if configured.
- Types: mypy or pyright if configured.
- Audit: `pip-audit`.
- Ignore: .venv, __pycache__, .pytest_cache, dist, *.egg-info.
- Watch for: Django (`manage.py test`), FastAPI/Flask app factories, migrations (alembic, Django) — schema changes need a migration + rollback note.
- Test rungs (see `test-scope`): T2 `pytest --testmon` (if installed) or `pytest <touched test files>`; T3 the changed package's full suite + mypy/pyright.
