# Testes da API FastAPI

Este arquivo descreve o teste funcional criado para validar o comportamento da API e suas dependências.

## O que o teste cobre

O teste `tests/test.py` realiza um fluxo CRUD completo na rota de cursos:

1. Cria um curso via `POST /api/v1/courses/`
2. Lista todos os cursos via `GET /api/v1/courses/`
3. Busca o curso criado via `GET /api/v1/courses/{id}`
4. Atualiza o curso via `PUT /api/v1/courses/{id}`
5. Exclui o curso via `DELETE /api/v1/courses/{id}`
6. Verifica que o curso não existe mais com `GET /api/v1/courses/{id}` retornando `404`

## Configuração do teste

- O teste usa `TestClient` do FastAPI para simular requisições HTTP contra a aplicação.
- É criado um banco de dados SQLite temporário em disco (`test_crud_fastapi.db`) para isolar as operações.
- A dependência `get_session` é sobrescrita com `app.dependency_overrides` para usar a sessão de teste.
- A base de dados é criada antes dos testes e destruída ao final.

## Como executar

No ambiente virtual do projeto, rode:

```bash
source venv/bin/activate
pytest tests/test.py -q
```

O teste deve passar com sucesso e cobrir o funcionamento das rotas principais da API.
