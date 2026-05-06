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
├── tests/
│   └── test.py                  # Suite de testes CRUD com pytest
├── create_table.py              # Script de criação de tabelas no banco
├── main.py                      # Ponto de entrada da aplicação
├── setup-environment.sh         # Script de automação de setup (Linux)
├── requirements.txt             # Dependências Python
├── SETUP_GUIDE.md               # Guia completo de instalação
├── README_TEST.md               # Documentação dos testes
└── README.md                    # Este arquivo
```

## 🛠️ Tecnologias

- **FastAPI** 0.136.1 - Framework web moderno e rápido
- **SQLAlchemy** 2.0.49 - ORM assíncrono com suporte a async/await
- **Pydantic** 2.13.3 - Validação e serialização de dados
- **asyncpg** 0.31.0 - Driver assíncrono para PostgreSQL
- **PostgreSQL** - Banco de dados relacional
- **Uvicorn** 0.46.0 - Servidor ASGI
- **pytest** 8.4.2 - Framework de testes
- **httpx** 0.28.1 - Cliente HTTP para testes
- **Python** 3.10+

## 📦 Pré-requisitos

- **Python** 3.10+
- **PostgreSQL** instalado e rodando
- **pip** e **git** instalados
- **Privilégios sudo** para o script de automação
- Ambiente virtual Python recomendado

## ✅ Estado do Projeto

- ✓ API CRUD totalmente funcional
- ✓ Testes implementados e passando
- ✓ SQLAlchemy 2.0 corrigido (scalar_one_or_none)
- ✓ Ambiente assíncrono completo
- ✓ Script de automação para Linux
- ✓ Documentação de setup e testes
- ✓ Dependências atualizadas e testadas

## 🚀 Instalação

### ⚡ Método Rápido (Recomendado)

Use o script de automação para instalar toda a infraestrutura:

```bash
bash setup-environment.sh
```

Este script irá:
- ✓ Atualizar pacotes do sistema
- ✓ Instalar Python 3, pip e PostgreSQL
- ✓ Criar ambiente virtual e instalar dependências
- ✓ Configurar banco de dados
- ✓ Executar testes automaticamente

**Consulte [SETUP_GUIDE.md](SETUP_GUIDE.md) para detalhes completos.**

### 📘 Método Manual

Se preferir instalar manualmente:

```bash
git clone <seu-repositorio>
cd crud_fastapi
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Depois, configure o banco de dados (veja [Configuração](#-configuração) abaixo).

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

## 🧪 Testes

Execute os testes da API com:

```bash
source venv/bin/activate
pytest tests/test.py -q
```

### Resultado esperado

```
1 passed, 2 warnings in 4.24s
```

O suite de testes cobre:
- ✓ POST: Criação de novo curso
- ✓ GET: Listagem de todos os cursos
- ✓ GET: Busca de curso por ID
- ✓ PUT: Atualização de curso
- ✓ DELETE: Exclusão de curso
- ✓ Validação de retorno 404 para curso deletado

**Consulte [README_TEST.md](README_TEST.md) para detalhes completos sobre a cobertura de testes.**

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

| Problema | Solução |
|----------|----------|
| PostgreSQL não conecta | `sudo systemctl restart postgresql` |
| Banco não existe | Execute `python create_table.py` após configurar credenciais |
| Erro ao importar módulos | Verifique: `source venv/bin/activate` |
| Testes falham | Limpe o banco: `python create_table.py` e rode novamente |
| Port 8000 em uso | `lsof -i :8000` para ver processo, depois mude a porta em `main.py` |

**Para suporte completo, consulte [SETUP_GUIDE.md](SETUP_GUIDE.md#troubleshooting).**

## � Documentação

### Documentação Automática da API

- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`
- **OpenAPI**: `http://localhost:8000/openapi.json`

### Documentação do Projeto

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Guia completo de instalação e configuração
- [README_TEST.md](README_TEST.md) - Documentação detalhada dos testes
- [setup-environment.sh](setup-environment.sh) - Script de automação

## 📌 Próximas Etapas (Sugestões)

- [ ] Adicionar autenticação (JWT)
- [ ] Implementar paginação nas listagens
- [ ] Adicionar validações customizadas
- [ ] Criar mais modelos (professores, alunos, etc.)
- [ ] Implementar logging estruturado
- [ ] Adicionar CI/CD (GitHub Actions)
- [ ] Dockerizar a aplicação

## 🤝 Contribuições

Sugestões e melhorias são bem-vindas! Este é um projeto educacional.

## 📝 Licença

Projeto educacional para aprendizado em FastAPI e APIs REST.
