#!/bin/bash

###############################################################################
# Script de Setup Completo para FastAPI CRUD com PostgreSQL
# Descrição: Instala e configura toda a infraestrutura necessária no Linux
# Uso: bash setup-environment.sh
###############################################################################

set -e  # Sai em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções auxiliares
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Detecta o gerenciador de pacotes
detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt-get install -y"
        UPDATE_CMD="sudo apt-get update && sudo apt-get upgrade -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        INSTALL_CMD="sudo yum install -y"
        UPDATE_CMD="sudo yum update -y"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
        UPDATE_CMD="sudo dnf upgrade -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
        UPDATE_CMD="sudo pacman -Syu --noconfirm"
    else
        print_error "Gerenciador de pacotes não suportado"
        exit 1
    fi
    print_success "Gerenciador de pacotes detectado: $PKG_MANAGER"
}

# Atualiza pacotes do sistema
update_system() {
    print_header "Etapa 1: Atualizando Pacotes do Sistema"
    print_warning "Isso pode levar alguns minutos..."
    $UPDATE_CMD
    print_success "Pacotes do sistema atualizados"
}

# Instala Python 3 e pip
install_python() {
    print_header "Etapa 2: Instalando Python 3"
    
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        print_success "Python 3 já instalado: $PYTHON_VERSION"
    else
        if [ "$PKG_MANAGER" = "apt" ]; then
            $INSTALL_CMD python3 python3-pip python3-venv python3-dev
        elif [ "$PKG_MANAGER" = "yum" ] || [ "$PKG_MANAGER" = "dnf" ]; then
            $INSTALL_CMD python3 python3-pip python3-devel
        elif [ "$PKG_MANAGER" = "pacman" ]; then
            $INSTALL_CMD python python-pip
        fi
        print_success "Python 3 instalado com sucesso"
    fi
    
    if command -v pip3 &> /dev/null; then
        pip3 --version | head -1
        print_success "pip3 disponível"
    fi
}

# Instala PostgreSQL
install_postgresql() {
    print_header "Etapa 3: Instalando PostgreSQL"
    
    if command -v psql &> /dev/null; then
        PSQL_VERSION=$(psql --version)
        print_success "PostgreSQL já instalado: $PSQL_VERSION"
    else
        if [ "$PKG_MANAGER" = "apt" ]; then
            $INSTALL_CMD postgresql postgresql-contrib
            sudo systemctl enable postgresql
            sudo systemctl start postgresql
        elif [ "$PKG_MANAGER" = "yum" ] || [ "$PKG_MANAGER" = "dnf" ]; then
            $INSTALL_CMD postgresql-server postgresql-contrib
            sudo systemctl enable postgresql
            sudo systemctl start postgresql
        elif [ "$PKG_MANAGER" = "pacman" ]; then
            $INSTALL_CMD postgresql
            sudo systemctl enable postgresql
            sudo systemctl start postgresql
        fi
        print_success "PostgreSQL instalado e iniciado"
    fi
}

# Instala dependências do sistema
install_system_dependencies() {
    print_header "Etapa 4: Instalando Dependências do Sistema"
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD build-essential libpq-dev git curl wget
    elif [ "$PKG_MANAGER" = "yum" ] || [ "$PKG_MANAGER" = "dnf" ]; then
        $INSTALL_CMD gcc gcc-c++ make libpq-devel git curl wget
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        $INSTALL_CMD base-devel git curl wget
    fi
    print_success "Dependências do sistema instaladas"
}

# Cria ambiente virtual Python
setup_venv() {
    print_header "Etapa 5: Configurando Ambiente Virtual Python"
    
    if [ -d "venv" ]; then
        print_warning "Ambiente virtual já existe. Removendo..."
        rm -rf venv
    fi
    
    python3 -m venv venv
    source venv/bin/activate
    print_success "Ambiente virtual criado e ativado"
}

# Atualiza pip e instala dependências Python
install_python_dependencies() {
    print_header "Etapa 6: Instalando Dependências Python"
    
    source venv/bin/activate
    pip install --upgrade pip setuptools wheel
    
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
        print_success "Dependências do requirements.txt instaladas"
    else
        print_warning "Arquivo requirements.txt não encontrado"
    fi
}

# Cria banco de dados PostgreSQL
setup_database() {
    print_header "Etapa 7: Configurando Banco de Dados PostgreSQL"
    
    sudo -u postgres psql -c "DROP DATABASE IF EXISTS faculdade;" 2>/dev/null || true
    sudo -u postgres psql -c "DROP USER IF EXISTS postgres WITH PASSWORD 'postgres';" 2>/dev/null || true
    
    sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'postgres';" 2>/dev/null || true
    sudo -u postgres psql -c "ALTER USER postgres WITH SUPERUSER;" 2>/dev/null || true
    sudo -u postgres psql -c "CREATE DATABASE faculdade OWNER postgres;" 2>/dev/null || true
    
    print_success "Banco de dados 'faculdade' criado"
}

# Executa verificações de conectividade
verify_connectivity() {
    print_header "Etapa 8: Verificando Conectividade com PostgreSQL"
    
    source venv/bin/activate
    
    PGPASSWORD=postgres psql -h localhost -U postgres -d faculdade -c "SELECT version();" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        print_success "Conexão com PostgreSQL estabelecida"
    else
        print_error "Falha ao conectar com PostgreSQL"
        print_warning "Verifique se PostgreSQL está rodando: sudo systemctl start postgresql"
    fi
}

# Cria tabelas
create_tables() {
    print_header "Etapa 9: Criando Tabelas do Banco de Dados"
    
    source venv/bin/activate
    
    if [ -f "create_table.py" ]; then
        python3 create_table.py
        print_success "Tabelas criadas com sucesso"
    else
        print_warning "Arquivo create_table.py não encontrado"
    fi
}

# Executa testes
run_tests() {
    print_header "Etapa 10: Executando Testes"
    
    source venv/bin/activate
    
    if [ -f "tests/test.py" ]; then
        pytest tests/test.py -q --tb=short
        if [ $? -eq 0 ]; then
            print_success "Todos os testes passaram!"
        else
            print_error "Alguns testes falharam"
            return 1
        fi
    else
        print_warning "Arquivo tests/test.py não encontrado"
    fi
}

# Exibe informações finais
print_final_info() {
    print_header "Setup Concluído com Sucesso!"
    
    echo -e "${GREEN}Próximos passos:${NC}"
    echo "1. Ativar o ambiente virtual:"
    echo "   ${BLUE}source venv/bin/activate${NC}"
    echo ""
    echo "2. Executar a aplicação:"
    echo "   ${BLUE}python main.py${NC}"
    echo ""
    echo "3. Acessar a aplicação:"
    echo "   ${BLUE}http://localhost:8000${NC}"
    echo ""
    echo "4. Documentação interativa:"
    echo "   ${BLUE}http://localhost:8000/docs${NC}"
    echo ""
    echo -e "${GREEN}Informações úteis:${NC}"
    echo "- Usuário PostgreSQL: postgres"
    echo "- Senha PostgreSQL: postgres"
    echo "- Banco de dados: faculdade"
    echo "- Host PostgreSQL: localhost"
    echo "- Porta PostgreSQL: 5432"
}

# Função principal
main() {
    print_header "FastAPI CRUD Setup - Instalação Completa"
    
    echo -e "${YELLOW}Este script irá:${NC}"
    echo "1. Atualizar pacotes do sistema"
    echo "2. Instalar Python 3 e pip"
    echo "3. Instalar PostgreSQL"
    echo "4. Instalar dependências do sistema"
    echo "5. Criar ambiente virtual Python"
    echo "6. Instalar dependências Python"
    echo "7. Configurar banco de dados PostgreSQL"
    echo "8. Verificar conectividade"
    echo "9. Criar tabelas"
    echo "10. Executar testes"
    echo ""
    
    read -p "Deseja continuar? (s/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Instalação cancelada"
        exit 0
    fi
    
    # Detecta gerenciador de pacotes
    detect_package_manager
    
    # Executa etapas
    update_system
    install_python
    install_system_dependencies
    install_postgresql
    setup_venv
    install_python_dependencies
    setup_database
    verify_connectivity
    create_tables
    run_tests
    
    # Informações finais
    print_final_info
}

# Executa script
main "$@"
