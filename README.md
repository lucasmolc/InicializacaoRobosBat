# Sistema de Inicialização Automática de Robôs Python

Script otimizado para inicializar automaticamente aplicações Python com verificação prévia de atualizações Git e configuração automática de inicialização do Windows.

**Versão Atual:** Sistema completo com interface gráfica de menu e automação PowerShell para Windows Task Scheduler.

## Requisitos do Sistema

### Obrigatórios
- **Windows 10/11** ou **Windows Server 2016+**
- **PowerShell 5.1+** (já incluído no Windows)  
- **Python 3.6+** instalado e no PATH do sistema
- **Privilégios de Administrador** (para configuração automática)

### Opcionais
- **Git for Windows** (para verificação automática de updates)
- **Visual Studio Code** (para edição dos arquivos)

### Verificar Requisitos
```cmd
# Verificar Python:
python --version

# Verificar PowerShell:
powershell -Command "$PSVersionTable.PSVersion"

# Verificar Git (opcional):
git --version

# Verificar privilégios de admin:
net session
```

## Estrutura de Arquivos

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
  - Gerenciamento completo da configuração automática

### Pasta `scripts/` (Scripts PowerShell Auxiliares)
**⚠️ NÃO execute estes arquivos diretamente - use o menu .bat**
- `configurar_inicializacao.ps1` - Configuração automática via PowerShell
- `verificar_inicializacao.ps1` - Verificação e teste da configuração
- `remover_inicializacao.ps1` - Remoção completa da configuração

### Documentação
- `README.md` - Este arquivo (documentação completa)

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
- ✅ Execução com privilégios de administrador (conta SYSTEM)
- ✅ Atraso de 2 minutos após boot (aguarda sistema carregar)
- ✅ Reinicialização automática em falhas (até 3 tentativas, intervalo 1 minuto)
- ✅ Execução mesmo em modo bateria
- ✅ Continuidade mesmo se desconectar da fonte
- ✅ Inicialização quando disponível (se perdeu horário agendado)
- ✅ Logs detalhados de execução no Event Viewer
- ✅ Funciona mesmo sem usuário logado

**🔧 Configurações Técnicas Aplicadas:**
- **Usuário:** SYSTEM (máximo privilégio)
- **Tipo de Logon:** ServiceAccount
- **Nível de Execução:** Highest (administrador)
- **Política de Bateria:** Permitir início e continuidade
- **Política de Falhas:** 3 tentativas com intervalo de 1 minuto
- **Nome da Tarefa:** `RoboPython_InicializacaoAutomatica`

**📋 Scripts de Gerenciamento:**
- `configurar_inicializacao.bat` - Menu interativo completo (**USE ESTE**)
- `scripts/configurar_inicializacao.ps1` - Configuração automática  
- `scripts/verificar_inicializacao.ps1` - Verificação e teste
- `scripts/remover_inicializacao.ps1` - Remoção completa

### Scripts PowerShell - Parâmetros Avançados

#### `configurar_inicializacao.ps1`
```powershell
# Parâmetros disponíveis:
-Teste                    # Executa teste após configuração
-CaminhoScript "caminho"  # Caminho personalizado do .bat (padrão: atual)
-AtrasoMinutos 5          # Atraso em minutos após boot (padrão: 2)

# Exemplos:
PowerShell -ExecutionPolicy Bypass -File scripts\configurar_inicializacao.ps1 -Teste
PowerShell -ExecutionPolicy Bypass -File scripts\configurar_inicializacao.ps1 -AtrasoMinutos 5
```

#### `verificar_inicializacao.ps1`
```powershell
# Parâmetros disponíveis:
-Detalhado               # Exibe informações completas da tarefa

# Exemplo:
PowerShell -ExecutionPolicy Bypass -File scripts\verificar_inicializacao.ps1 -Detalhado
```

#### `remover_inicializacao.ps1`
```powershell
# Parâmetros disponíveis:
-Forcado                 # Remove sem confirmação

# Exemplo:
PowerShell -ExecutionPolicy Bypass -File scripts\remover_inicializacao.ps1 -Forcado
```

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

## Monitoramento e Verificação

### Verificar Status da Configuração
```cmd
# Via menu interativo (recomendado):
configurar_inicializacao.bat
# → Escolha opção 2: "Verificar configuração atual"

# Via PowerShell direto:
PowerShell -ExecutionPolicy Bypass -File scripts\verificar_inicializacao.ps1

# Com detalhes completos:
PowerShell -ExecutionPolicy Bypass -File scripts\verificar_inicializacao.ps1 -Detalhado
```

### Testar Execução Manual
```cmd
# Testar tarefa agendada:
schtasks /run /tn "RoboPython_InicializacaoAutomatica"

# Verificar status:
schtasks /query /tn "RoboPython_InicializacaoAutomatica" /fo LIST /v
```

### Logs do Windows Task Scheduler
1. Abrir **Event Viewer** (`eventvwr.msc`)
2. Navegar: **Windows Logs** → **Applications and Services Logs** → **Microsoft** → **Windows** → **TaskScheduler** → **Operational**
3. Filtrar por Task Name: `RoboPython_InicializacaoAutomatica`

### Localização dos Logs da Aplicação
```
C:\Projects\InicializacaoRobosBat\logs\
├── inicializacao_AAAAMMDD_HHMMSS.log
└── [outros logs de execução]
```

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

### Problemas de Inicialização Automática

#### Problema: Configuração não funciona
```cmd
# Verificar se tem privilégios de admin:
whoami /priv | findstr "SeDebugPrivilege"

# Reconfigurar como admin:
# Clique direito no PowerShell → "Executar como administrador"
configurar_inicializacao.bat
```

#### Problema: Tarefa não executa no boot
```cmd
# Verificar se tarefa existe:
schtasks /query /tn "RoboPython_InicializacaoAutomatica"

# Verificar último resultado:
schtasks /query /tn "RoboPython_InicializacaoAutomatica" /fo LIST /v | findstr "Last Result"

# Resultado 0x0 = Sucesso
# Outros códigos = Erro (consultar documentação Microsoft)
```

#### Problema: Execução Policy do PowerShell
```cmd
# Se erro de ExecutionPolicy, usar bypass:
PowerShell -ExecutionPolicy Bypass -File scripts\configurar_inicializacao.ps1

# Ou alterar política global (permanente):
PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Force"
```

#### Problema: Tarefa executa mas script falha
- Verificar logs em `logs/inicializacao_*.log`
- Testar script manualmente: executar `inicializar_robo.bat`  
- Verificar se caminhos são absolutos (não relativos)
- Garantir que conta SYSTEM tem acesso aos arquivos

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

## Segurança e Melhores Práticas

### Considerações de Segurança
- Scripts executam com privilégios SYSTEM (máximo nível)
- Sempre revise configurações antes de aplicar
- Use caminhos absolutos para evitar problemas de contexto
- Mantenha logs para auditoria de execuções

### Melhores Práticas
- ✅ Execute `configurar_inicializacao.bat` sempre como Administrador
- ✅ Teste manualmente antes de configurar inicialização automática  
- ✅ Configure `PAUSE_ON_EXIT=false` para execução automática
- ✅ Use `VERBOSE_OUTPUT=false` para logs mais limpos em produção
- ✅ Monitore logs regularmente para detectar falhas
- ✅ Mantenha backup das configurações importantes

## Versionamento e Updates

### Histórico de Versões
- **v2.0** (Atual): Sistema completo com menu interativo e PowerShell
- **v1.x**: Script básico sem automação de inicialização

### Atualizações Futuras
Para manter o sistema atualizado:
```cmd
cd C:\Projects\InicializacaoRobosBat
git pull origin main
```

### Contribuições
- Issues e sugestões são bem-vindos
- Fork do projeto para contribuições
- Siga as convenções de commit do Git

## Suporte

### Documentação Adicional
- Consulte comentários nos arquivos `.bat` e `.ps1`
- Logs detalhados em `logs/`
- Event Viewer do Windows para logs do sistema

### Contato
- **Repositório:** [GitHub - InicializacaoRobosBat](https://github.com/lucasmolc/ImportacaoCSV)
- **Issues:** Use o sistema de issues do GitHub
- **Documentação:** Este arquivo README.md

---

**Última Atualização:** Outubro 2025  
**Compatibilidade:** Windows 10/11, PowerShell 5.1+, Python 3.6+