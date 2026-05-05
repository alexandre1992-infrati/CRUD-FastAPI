# CRUD FastAPI

> Projeto educacional em FastAPI para gerenciar um CRUD de cursos com SQLAlchemy assíncrono e Pydantic V2.

## 📋 Sobre o Projeto

Este projeto demonstra uma API REST básica em FastAPI para gerenciar recursos de curso (`courses`). Ele usa SQLAlchemy com execução assíncrona e validação de dados com Pydantic V2.

## 🏗️ Estrutura do Projeto

```
crud_fastapi/
├── api/
│   └── v1/
│       ├── api.py               # Roteamento principal da API
│       └── endpoints/
│           └── course.py        # Endpoints CRUD de cursos
├── core/
│   ├── configs.py               # Configurações de ambiente e banco
│   ├── database.py              # Engine e sessão SQLAlchemy assíncrona
│   └── dependency.py            # Dependência de sessão do banco
├── models/
│   ├── __all_models.py          # Import centralizado de modelos
│   └── courses_model.py         # Modelo ORM de curso
├── schemas/
│   └── course_schema.py         # Schema Pydantic para curso
├── create_table.py              # Script de criação de tabelas no banco
├── main.py                      # Ponto de entrada da aplicação
└── requirements.txt             # Dependências Python
```

## 🛠️ Tecnologias

- FastAPI
- SQLAlchemy 2.x
- Pydantic 2.x
- asyncpg
- PostgreSQL
- Uvicorn
- Python 3.13

## 📦 Pré-requisitos

- Python 3.10+
- PostgreSQL em execução
- `pip` instalado
- Ambiente virtual recomendado

## 🚀 Instalação

```bash
git clone <seu-repositorio>
cd crud_fastapi
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## ⚙️ Configuração

### Ajuste a conexão do banco

No arquivo `core/configs.py`, atualize a URL do banco de dados:

```python
DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/faculdade"
```

Ajuste `<usuario>`, `<senha>`, `<host>`, `<porta>` e `<banco>` conforme necessário.

### Criar tabelas no banco

Execute:

```bash
python create_table.py
```

## 💻 Executando a aplicação

```bash
uvicorn main:app --reload
```

A API estará disponível em `http://localhost:8000`.

## 📚 Endpoints disponíveis

A API atual expõe os seguintes endpoints:

| Método | Rota | Descrição |
|---|---|---|
| POST | `/api/v1/courses/` | Cria um novo curso |
| GET | `/api/v1/courses/` | Lista todos os cursos |
| GET | `/api/v1/courses/{course_id}` | Retorna um curso por ID |
| PUT | `/api/v1/courses/{course_id}` | Atualiza um curso existente |
| DELETE | `/api/v1/courses/{course_id}` | Remove um curso |

### Exemplo de requisição POST

```bash
curl -X POST http://127.0.0.1:8000/api/v1/courses/ \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Exemplo","aulas":10,"horas":20}'
```

### Exemplo de corpo JSON

```json
{
  "titulo": "Exemplo",
  "aulas": 10,
  "horas": 20
}
```

### Exemplo de requisição GET (lista)

```bash
curl http://127.0.0.1:8000/api/v1/courses/
```

### Exemplo de requisição GET por ID

```bash
curl http://127.0.0.1:8000/api/v1/courses/1
```

### Exemplo de requisição PUT

```bash
curl -X PUT http://127.0.0.1:8000/api/v1/courses/1 \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Curso Atualizado","aulas":12,"horas":24}'
```

### Exemplo de requisição DELETE

```bash
curl -X DELETE http://127.0.0.1:8000/api/v1/courses/1
```

## 📄 Observações

- O schema Pydantic usa `model_config = {"from_attributes": True}` para suportar mapeamento de atributos ORM.
- O campo `id` no schema é opcional e será preenchido pelo banco de dados após a criação.
- As rotas estão agrupadas em `/api/v1` conforme `settings.API_V1_STR`.

## 🧠 Como o projeto está organizado

- `main.py`: inicializa o app FastAPI e registra rotas.
- `api/v1/api.py`: define o `APIRouter` principal e inclui o router de cursos.
- `api/v1/endpoints/course.py`: implementa os endpoints CRUD.
- `core/configs.py`: configurações da aplicação e base do modelo.
- `core/database.py`: configuração do engine e da sessão assíncrona.
- `core/dependency.py`: dependency injection para obter a sessão.
- `models/courses_model.py`: classe ORM `CourseModel`.
- `schemas/course_schema.py`: schema Pydantic para entrada/saída.

## 🔧 Dicas de troubleshooting

- Verifique se o PostgreSQL está rodando e aceitando conexões.
- O banco deve existir antes de executar `create_table.py`.
- Se o `uvicorn` não estiver instalado, instale com `pip install uvicorn`.
- Se ocorrer `ModuleNotFoundError: httpx`, instale `httpx` para o teste com `fastapi.testclient`.

## 📄 Documentação automática

- Swagger: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## 📝 Licença

Projeto educacional para aprendizado em FastAPI e APIs REST.
