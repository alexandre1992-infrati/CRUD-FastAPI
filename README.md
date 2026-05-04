# CRUD FastAPI

> Um projeto de estudos sobre o framework **FastAPI** e desenvolvimento web com Python.

## 📋 Sobre o Projeto

Este é um projeto educacional desenvolvido para aprender os conceitos fundamentais do FastAPI, um framework moderno e rápido para construir APIs REST com Python. O projeto implementa um CRUD (Create, Read, Update, Delete) simples para gerenciar cursos, com foco em boas práticas de desenvolvimento e estrutura de código.

## 🏗️ Estrutura do Projeto

```
crud_fastapi/
├── core/
│   ├── configs.py          # Configurações da aplicação (database, API versioning)
│   ├── database.py         # Setup do SQLAlchemy com AsyncSQL
│   └── dependency.py       # Injeção de dependências
├── models/
│   ├── __all_models.py     # Importação centralizada de modelos
│   └── courses_model.py    # Modelo de Cursos (ORM)
├── schemas/
│   └── course_schema.py    # Schema Pydantic para validação de Cursos
├── api/                    # Rotas/endpoints (em desenvolvimento)
├── main.py                 # Ponto de entrada da aplicação
├── create_table.py         # Script para criar tabelas no banco
└── requeriments.txt        # Dependências do projeto
```

## 🛠️ Tecnologias

- **FastAPI** - Framework web assíncrono
- **Pydantic** - Validação de dados e configuração
- **SQLAlchemy** - ORM (Object-Relational Mapping)
- **AsyncPG** - Driver assíncrono para PostgreSQL
- **PostgreSQL** - Banco de dados relacional
- **Python 3.13** - Linguagem de programação

## 📦 Pré-requisitos

- Python 3.10+
- PostgreSQL instalado e configurado
- pip ou pip3
- Ambiente virtual (recomendado)

## 🚀 Instalação

### 1. Clone o repositório

```bash
git clone <seu-repositorio>
cd crud_fastapi
```

### 2. Crie um ambiente virtual

```bash
python -m venv venv
```

### 3. Ative o ambiente virtual

**Linux/macOS:**
```bash
source venv/bin/activate
```

**Windows:**
```bash
venv\Scripts\activate
```

### 4. Instale as dependências

```bash
pip install -r requeriments.txt
```

## ⚙️ Configuração

### Banco de Dados

Edite o arquivo `core/configs.py` e ajuste a `DATABASE_URL` conforme suas credenciais do PostgreSQL:

```python
DATABASE_URL: str = "postgresql+asyncpg://<usuario>:<senha>@<host>:<porta>/<banco>"
```

Exemplo:
```python
DATABASE_URL: str = "postgresql+asyncpg://postgres:senha123@localhost:5432/faculdade"
```

### Criar as Tabelas

Execute o script para criar as tabelas no banco de dados:

```bash
python create_table.py
```

## 💻 Como Usar

### Iniciar a Aplicação

```bash
uvicorn main:app --reload
```

A API estará disponível em: `http://localhost:8000`

### Documentação Interativa

- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`

## 📚 Conceitos Aprendidos

Este projeto cobre:

- ✅ Configuração de aplicações FastAPI
- ✅ Integração com bancos de dados assíncrono
- ✅ Validação de dados com Pydantic
- ✅ Modelos SQLAlchemy (ORM)
- ✅ Injeção de dependências
- ✅ Migração do Pydantic v1 → v2 (BaseSettings)
- ⏳ Endpoints CRUD (em desenvolvimento)
- ⏳ Tratamento de erros e exceções
- ⏳ Testes unitários

## 📝 Status do Projeto

- [x] Estrutura inicial do projeto
- [x] Configuração do banco de dados
- [x] Modelos e schemas
- [x] Correção compatibilidade Pydantic v2
- [ ] Implementação dos endpoints CRUD
- [ ] Testes unitários
- [ ] Documentação da API
- [ ] Deploy

## 🔧 Troubleshooting

### Erro: `BaseSettings` has been moved to `pydantic-settings`

**Solução**: Instale o pacote `pydantic-settings`:

```bash
pip install pydantic-settings
```

### Erro: Falha na autenticação do PostgreSQL

**Solução**: Verifique as credenciais no `core/configs.py` e certifique-se que o PostgreSQL está rodando.

## 📄 Licença

Este projeto é de uso educacional. Sinta-se livre para usar, modificar e compartilhar.

## 👤 Autor

Desenvolvido como projeto de estudos em FastAPI e Python Web Development.
