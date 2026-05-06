# Guia de Setup Completo - FastAPI CRUD

Este guia fornece instruções para instalar e configurar a infraestrutura completa do projeto no Linux usando o script de automação.

## Pré-requisitos

- Sistema operacional Linux (Ubuntu, Debian, CentOS, Fedora, Arch, etc.)
- Acesso a privilégios `sudo`
- Conexão com a internet
- Git (opcional, para clonar o repositório)

## Métodos de Instalação

### Método 1: Script de Automação (Recomendado)

Este é o método mais rápido e fácil. O script `setup-environment.sh` automatiza todas as etapas.

#### Passo 1: Clonar ou Acessar o Repositório

```bash
cd /path/to/crud_fastapi
```

#### Passo 2: Executar o Script de Setup

```bash
bash setup-environment.sh
```

O script solicitará confirmação antes de prosseguir. Digite `s` ou `S` para continuar.

#### Passo 3: Seguir as Instruções

O script irá:
1. ✓ Atualizar pacotes do sistema operacional
2. ✓ Instalar Python 3 e pip
3. ✓ Instalar PostgreSQL
4. ✓ Instalar dependências do sistema
5. ✓ Criar ambiente virtual Python
6. ✓ Instalar dependências Python do projeto
7. ✓ Configurar banco de dados PostgreSQL
8. ✓ Verificar conectividade com o banco
9. ✓ Criar tabelas do banco de dados
10. ✓ Executar testes da API

### Método 2: Instalação Manual

Se preferir fazer passo a passo:

#### 1. Atualizar Sistema

**Ubuntu/Debian:**
```bash
sudo apt-get update && sudo apt-get upgrade -y
```

**CentOS/RHEL:**
```bash
sudo yum update -y
```

**Fedora:**
```bash
sudo dnf upgrade -y
```

#### 2. Instalar Python 3

**Ubuntu/Debian:**
```bash
sudo apt-get install -y python3 python3-pip python3-venv python3-dev
```

**CentOS/RHEL:**
```bash
sudo yum install -y python3 python3-pip python3-devel
```

**Fedora:**
```bash
sudo dnf install -y python3 python3-pip python3-devel
```

#### 3. Instalar PostgreSQL

**Ubuntu/Debian:**
```bash
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

**CentOS/RHEL:**
```bash
sudo yum install -y postgresql-server postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

**Fedora:**
```bash
sudo dnf install -y postgresql-server postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

#### 4. Instalar Dependências do Sistema

**Ubuntu/Debian:**
```bash
sudo apt-get install -y build-essential libpq-dev git curl
```

**CentOS/RHEL/Fedora:**
```bash
sudo yum install -y gcc gcc-c++ make libpq-devel git curl
# ou
sudo dnf install -y gcc gcc-c++ make libpq-devel git curl
```

#### 5. Criar Ambiente Virtual

```bash
python3 -m venv venv
source venv/bin/activate
```

#### 6. Instalar Dependências Python

```bash
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

#### 7. Configurar Banco de Dados

```bash
sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'postgres';"
sudo -u postgres psql -c "ALTER USER postgres WITH SUPERUSER;"
sudo -u postgres psql -c "CREATE DATABASE faculdade OWNER postgres;"
```

#### 8. Criar Tabelas

```bash
python create_table.py
```

#### 9. Executar Testes

```bash
pytest tests/test.py -q
```

## Configuração Padrão

O script cria as seguintes configurações padrão:

| Componente | Valor |
|-----------|-------|
| **Usuário PostgreSQL** | postgres |
| **Senha PostgreSQL** | postgres |
| **Banco de Dados** | faculdade |
| **Host PostgreSQL** | localhost |
| **Porta PostgreSQL** | 5432 |
| **Porta FastAPI** | 8000 |

### Alterar Credenciais (Opcional)

Para alterações de segurança, edite o arquivo `core/configs.py`:

```python
class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql+asyncpg://seu_usuario:sua_senha@localhost:5432/seu_banco"
```

## Executando a Aplicação

Após a instalação bem-sucedida:

```bash
# Ativar ambiente virtual
source venv/bin/activate

# Executar servidor
python main.py
```

A aplicação estará disponível em:
- **Aplicação**: http://localhost:8000
- **Documentação Swagger**: http://localhost:8000/docs
- **Documentação ReDoc**: http://localhost:8000/redoc

## Verificações de Conectividade

### Testar Conexão com PostgreSQL

```bash
PGPASSWORD=postgres psql -h localhost -U postgres -d faculdade -c "SELECT version();"
```

### Testar Rotas da API

```bash
# Listar cursos
curl http://localhost:8000/api/v1/courses/

# Criar um curso
curl -X POST http://localhost:8000/api/v1/courses/ \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Python Avançado","aulas":40,"horas":80}'
```

## Troubleshooting

### PostgreSQL não inicia

```bash
sudo systemctl status postgresql
sudo systemctl restart postgresql
```

### Erro de conexão ao banco de dados

Verifique se o PostgreSQL está rodando:
```bash
sudo systemctl is-active postgresql
```

Verifique as credenciais em `core/configs.py`.

### Ambiente virtual não ativa

```bash
python3 -m venv venv
source venv/bin/activate
```

### Testes falham

Verifique se o banco de dados foi criado:
```bash
sudo -u postgres psql -l | grep faculdade
```

Recrie o banco se necessário:
```bash
python create_table.py
```

## Próximas Etapas

1. Explore a documentação da API em http://localhost:8000/docs
2. Revise o arquivo `README.md` para entender a estrutura do projeto
3. Consulte `README_TEST.md` para detalhes sobre os testes
4. Implemente suas próprias rotas e modelos conforme necessário

## Suporte

Para problemas adicionais, consulte:
- Documentação FastAPI: https://fastapi.tiangolo.com/
- Documentação SQLAlchemy: https://docs.sqlalchemy.org/
- Documentação PostgreSQL: https://www.postgresql.org/docs/
