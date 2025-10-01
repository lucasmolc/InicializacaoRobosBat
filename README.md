# Sistema de Inicialização Automática de Robôs Python

Script otimizado para inicializar automaticamente aplicações Python com verificação prévia de atualizações Git. 

**Versão Atual:** Script único sem dependências externas, otimizado para simplicidade e performance.

## Arquivo Principal

- `inicializar_robo.bat` - **Script único e otimizado** 
  - Todas as configurações internas (sem arquivos externos)
  - Sistema completo de logs com timestamp
  - Verificação Git automática (fetch + pull quando necessário) 
  - Validação robusta de configurações e arquivos
  - Execução segura com códigos de saída apropriados

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

### Agendamento com Task Scheduler
1. Abra o "Agendador de Tarefas" do Windows
2. Criar Tarefa Básica
3. Configure o horário desejado
4. Ação: Iniciar programa
5. Programa: `C:\Projects\InicializacaoRobosBat\inicializar_robo.bat`

### Inicialização com o Windows
1. Pressione `Win + R`, digite `shell:startup`
2. Cole um atalho do arquivo `.bat` na pasta que abrir

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