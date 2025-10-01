# Sist## Estrutura de Arquivos

### Arquivos Principais (Raiz)
- `inicializar_robo.bat` - **Script principal de execução**
  - Todas as configurações internas (sem arquivos externos)
  - Sistema completo de logs com timestamp
  - Verificação Git automática (fetch + pull quando necessário) 
  - Validação robusta de configurações e arquivos
  - Execução segura com códigos de saída apropriados

- `configurar_inicializacao.bat` - **Menu interativo para inicialização automática** ⭐
  - Interface amigável para todas as operações
  - Verificação automática de privilégios de administrador
  - Gerenciamento completo da configuração

### Pasta `scripts/` (Scripts Auxiliares)
**⚠️ NÃO execute estes arquivos diretamente - use o menu .bat**
- `configurar_inicializacao.ps1` - Configuração automática via PowerShell
- `verificar_inicializacao.ps1` - Verificação e teste da configuração
- `remover_inicializacao.ps1` - Remoção completa da configuração

### Documentação
- `README.md` - Este arquivo (documentação completa)nicialização Automática de Robôs Python

Script otimizado para inicializar automaticamente aplicações Python com verificação prévia de atualizações Git. 

**Versão Atual:** Script único sem dependências externas, otimizado para simplicidade e performance.

## Arquivo Principal

- `inicializar_robo.bat` - **Script principal de execução**
  - Todas as configurações internas (sem arquivos externos)
  - Sistema completo de logs com timestamp
  - Verificação Git automática (fetch + pull quando necessário) 
  - Validação robusta de configurações e arquivos
  - Execução segura com códigos de saída apropriados

- `configurar_inicializacao.bat` - **Menu interativo para inicialização automática**
  - Interface amigável para todas as operações
  - Verificação automática de privilégios de administrador
  - Gerenciamento completo da configuração

- `scripts/` - **Scripts PowerShell auxiliares** (não executar diretamente)
  - Scripts de configuração, verificação e remoção
  - Executados automaticamente via menu .bat

## Como Usar

### 1. Configuração (OBRIGATÓRIA)

Edite o arquivo `inicializar_robo.bat` e configure as variáveis no início:

```batch
:: ============ CONFIGURAÇÕES - EDITE AQUI ============
set "PYTHON_APP_DIR=C:\caminho\para\sua\aplicacao"
set "PYTHON_SCRIPT=main.py"
set "PYTHON_EXECUTABLE=python"
set "GIT_BRANCH=main"
set "PAUSE_ON_EXIT=true"
set "VERBOSE_OUTPUT=true"
```

### 2. Execução

Execute o arquivo `inicializar_robo.bat` diretamente.

### 3. Inicialização Automática (Opcional)

Para execução automática com o Windows:

**Método Simples (Recomendado):**
1. Execute `configurar_inicializacao.bat` **como Administrador**
2. Siga o menu interativo
3. Escolha opção 1 para configurar

**Método Manual:**
- Consulte o arquivo `INICIALIZACAO_WINDOWS.md` para instruções detalhadas
- Use os scripts PowerShell individuais conforme necessidade

## Funcionalidades

### ✅ Verificação Git Automática
- Verifica se há atualizações no repositório remoto
- Executa `git pull` automaticamente se necessário
- Continua mesmo se não for um repositório Git
- Suporte a branches específicos

### ✅ Sistema de Logs Inteligente
- Logs detalhados com timestamp em `logs/inicializacao_AAAAMMDD_HHMMSS.log`
- Saída no console configurável (VERBOSE_OUTPUT)
- Registra todas as operações, sucessos e erros

### ✅ Configurações Internas
- Todas as configurações no próprio arquivo .bat (linhas 9-26)
- Validação automática de configurações obrigatórias
- Mensagens de erro claras para configurações faltantes
- Configurações opcionais com valores padrão seguros

### ✅ Execução Robusta
- Validação completa antes da execução (diretório, arquivo Python, Git)
- Preserva diretório original usando pushd/popd
- Códigos de saída apropriados para integração com outros sistemas
- Pausa configurável ao finalizar (útil para debugging ou execução automática)

## Configurações Disponíveis

### Configurações Obrigatórias
```batch
set "PYTHON_APP_DIR=C:\Projects\MeuRobo"  :: Caminho da aplicação
set "PYTHON_SCRIPT=main.py"               :: Arquivo Python principal
```

### Configurações Opcionais
```batch
set "PYTHON_EXECUTABLE=python"            :: Executável Python
set "GIT_BRANCH=main"                     :: Branch para git pull  
set "PAUSE_ON_EXIT=true"                  :: Pausar ao finalizar
set "VERBOSE_OUTPUT=true"                 :: Saída detalhada
```

### Execução Silenciosa
Para execução sem pausas e saída mínima:
```batch
set "PAUSE_ON_EXIT=false"
set "VERBOSE_OUTPUT=false"
```

## Exemplos de Configuração

### Exemplo 1: Aplicação Simples
```batch
set "PYTHON_APP_DIR=C:\Projects\MeuRobo"
set "PYTHON_SCRIPT=main.py"
set "PYTHON_EXECUTABLE=python"
set "GIT_BRANCH=main"
set "VIRTUAL_ENV_PATH="
set "PAUSE_ON_EXIT=true"
set "VERBOSE_OUTPUT=true"
```

### Exemplo 2: Execução Automática (Sem Interação)
```batch
set "PYTHON_APP_DIR=C:\Projects\MeuRobo"
set "PYTHON_SCRIPT=orquestrador_fila.py"
set "PYTHON_EXECUTABLE=python"
set "GIT_BRANCH=master"
set "PAUSE_ON_EXIT=false"
set "VERBOSE_OUTPUT=false"
```

### Exemplo 3: Projeto com Branch Específico
```batch
set "PYTHON_APP_DIR=C:\Projects\RaspagemInput"
set "PYTHON_SCRIPT=main.py"
set "PYTHON_EXECUTABLE=python"
set "GIT_BRANCH=development"
set "PAUSE_ON_EXIT=true"
set "VERBOSE_OUTPUT=true"
```

## Automatização

### Inicialização Automática com o Windows

**🚀 Método Automático (Recomendado):**
1. Execute `configurar_inicializacao.bat` como Administrador
2. Escolha a opção de configuração no menu
3. Reinicie para testar

**⚙️ Recursos da Inicialização Automática:**
- ✅ Execução com privilégios de administrador
- ✅ Atraso de 2 minutos após boot (aguarda sistema carregar)
- ✅ Reinicialização automática em falhas (até 3 tentativas)
- ✅ Logs detalhados de execução
- ✅ Funciona mesmo sem usuário logado

**📋 Scripts de Gerenciamento:**
- `configurar_inicializacao.bat` - Menu interativo completo (**USE ESTE**)
- `scripts/configurar_inicializacao.ps1` - Configuração automática  
- `scripts/verificar_inicializacao.ps1` - Verificação e teste
- `scripts/remover_inicializacao.ps1` - Remoção completa

### Agendamento Manual com Task Scheduler

#### Configuração Passo-a-Passo:

1. **Abrir Agendador de Tarefas**
   - Pressione `Win + R` → digite `taskschd.msc` → Enter

2. **Criar Tarefa**
   - Clique em "Criar Tarefa..." (não "Criar Tarefa Básica")
   - Nome: `Inicializacao Robo Python`
   - ✅ Marque "Executar com privilégios mais altos"
   - ✅ Marque "Executar estando o usuário conectado ou não"

3. **Configurar Disparadores**
   - Aba "Disparadores" → "Novo..."
   - Iniciar a tarefa: "Na inicialização"
   - Atrasar tarefa por: 2 minutos

4. **Configurar Ações**
   - Aba "Ações" → "Nova..."
   - Programa/script: `C:\Projects\InicializacaoRobosBat\inicializar_robo.bat`

5. **Configurar Configurações**
   - ✅ "Permitir que a tarefa seja executada sob demanda"
   - ✅ "Se a tarefa falhar, reiniciar a cada: 1 minuto" (até 3 vezes)

## Métodos Alternativos de Inicialização

### Método 1: Serviço do Windows (NSSM)
```cmd
# Baixar NSSM de https://nssm.cc/download
cd C:\nssm\win64
nssm install "RoboPython" "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat"
nssm set "RoboPython" Start SERVICE_AUTO_START
nssm start "RoboPython"
```

### Método 2: Registro do Windows
1. `Win + R` → `regedit` → Enter
2. Navegar: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
3. Criar entrada: Nome=`RoboPythonInit`, Valor=caminho do .bat

⚠️ **Nota:** Registro não executa com privilégios de admin automaticamente

## Troubleshooting

### Problema: "Diretório não encontrado"
- Verifique se o caminho em `PYTHON_APP_DIR` está correto
- Use barras invertidas `\` no Windows

### Problema: "Git não encontrado"
- Instale o Git for Windows
- Ou adicione o Git ao PATH do sistema

### Problema: "Python não encontrado"
- Instale o Python e adicione ao PATH
- Ou especifique o caminho completo: `set "PYTHON_EXECUTABLE=C:\Python39\python.exe"`

### Problema: Encoding nos logs
- Os logs são salvos em formato Windows (ANSI)
- Use Notepad++, VS Code ou similar para melhor visualização

### Problema: Script não executa
- Verifique se você editou `PYTHON_APP_DIR` corretamente
- Execute como administrador se houver problemas de permissão
- Verifique se o Git está instalado e no PATH do sistema

## Logs

Os logs são salvos automaticamente em:
```
logs/inicializacao_AAAAMMDD_HHMMSS.log
```

Exemplo de log:
```
[01/10/2025 14:30:15] [INFO] ==========================================
[01/10/2025 14:30:15] [INFO] Iniciando Sistema de Inicialização v2.0  
[01/10/2025 14:30:15] [INFO] ==========================================
[01/10/2025 14:30:15] [INFO] Navegado para: C:\Projects\RaspagemInput
[01/10/2025 14:30:16] [INFO] Verificando atualizações do repositório Git
[01/10/2025 14:30:16] [INFO] Repositório já esta atualizado
[01/10/2025 14:30:16] [INFO] Iniciando aplicacao: python main.py
[01/10/2025 14:30:20] [INFO] Aplicacao finalizada com codigo: 0
[01/10/2025 14:30:20] [SUCESSO] Aplicacao executada com sucesso
[01/10/2025 14:30:20] [INFO] ==========================================
[01/10/2025 14:30:20] [INFO] Processo finalizado
[01/10/2025 14:30:20] [INFO] ==========================================
```