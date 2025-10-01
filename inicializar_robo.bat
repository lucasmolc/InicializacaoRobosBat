@echo off
:: ========================================
:: Script de Inicialização Automática de Robô Python
:: Versão Otimizada - Sem Ambiente Virtual
:: ========================================

setlocal EnableDelayedExpansion

:: ============ CONFIGURAÇÕES - EDITE AQUI ============
:: Caminho para a aplicação Python (obrigatório)
set "PYTHON_APP_DIR=C:\caminho\para\sua\aplicacao"

:: Nome do arquivo Python principal
set "PYTHON_SCRIPT=main.py"

:: Executável Python (python, python3, ou caminho completo)
set "PYTHON_EXECUTABLE=python"

:: Branch Git para atualização (geralmente 'main' ou 'master')
set "GIT_BRANCH=main"

:: Aguardar tecla ao finalizar (true/false)
set "PAUSE_ON_EXIT=true"

:: Mostrar saída detalhada (true/false)
set "VERBOSE_OUTPUT=true"
:: ==================================================

:: Configurações internas do sistema
set "LOG_FILE=%~dp0logs\inicializacao_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"

:: Criar diretório de logs se não existir
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Função para log com timestamp
call :log_message "INFO" "=========================================="
call :log_message "INFO" "Iniciando Sistema de Inicialização v2.0"
call :log_message "INFO" "=========================================="

if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Sistema de Inicializacao de Robos Python v2.0
    echo [INFO] Data/Hora: %date% %time%
    echo.
)

:: Validar configurações obrigatórias
if "%PYTHON_APP_DIR%"=="C:\caminho\para\sua\aplicacao" (
    call :log_message "ERRO" "PYTHON_APP_DIR nao foi configurado!"
    echo [ERRO] Por favor, configure PYTHON_APP_DIR no inicio do script
    echo        Edite a linha: set "PYTHON_APP_DIR=C:\caminho\para\sua\aplicacao"
    echo.
    goto :exit_script
)

if "%PYTHON_APP_DIR%"=="" (
    call :log_message "ERRO" "PYTHON_APP_DIR nao pode estar vazio!"
    echo [ERRO] PYTHON_APP_DIR nao pode estar vazio!
    goto :exit_script
)

:: Verificar se o diretório da aplicação existe
if not exist "%PYTHON_APP_DIR%" (
    call :log_message "ERRO" "Diretorio da aplicacao nao encontrado: %PYTHON_APP_DIR%"
    echo [ERRO] Diretorio nao encontrado: %PYTHON_APP_DIR%
    goto :exit_script
)

:: Navegar para o diretório da aplicação
pushd "%PYTHON_APP_DIR%"
if %errorlevel% neq 0 (
    call :log_message "ERRO" "Falha ao navegar para: %PYTHON_APP_DIR%"
    echo [ERRO] Falha ao navegar para: %PYTHON_APP_DIR%
    goto :exit_script
)

call :log_message "INFO" "Navegado para: %PYTHON_APP_DIR%"
if "%VERBOSE_OUTPUT%"=="true" echo [INFO] Diretorio: %PYTHON_APP_DIR%

:: ============ VERIFICAÇÃO GIT ============
if not exist ".git" (
    call :log_message "AVISO" "Nao e um repositorio Git - pulando verificacao"
    if "%VERBOSE_OUTPUT%"=="true" echo [AVISO] Nao e um repositorio Git - pulando atualizacao
    goto :run_application
)

if "%VERBOSE_OUTPUT%"=="true" echo [INFO] Verificando atualizacoes Git...
call :log_message "INFO" "Verificando atualizacoes do repositorio Git"

:: Git fetch
git fetch origin >nul 2>>"%LOG_FILE%"
if %errorlevel% neq 0 (
    call :log_message "AVISO" "Falha no git fetch - continuando sem atualizacao"
    if "%VERBOSE_OUTPUT%"=="true" echo [AVISO] Falha no git fetch - continuando
    goto :run_application
)

:: Verificar se há atualizações
git status -uno 2>nul | findstr "Your branch is behind" >nul
if %errorlevel% equ 0 (
    if "%VERBOSE_OUTPUT%"=="true" echo [INFO] Atualizacoes encontradas - executando git pull...
    call :log_message "INFO" "Atualizacoes encontradas - executando git pull"
    
    git pull origin %GIT_BRANCH% >nul 2>>"%LOG_FILE%"
    if %errorlevel% equ 0 (
        call :log_message "SUCESSO" "Repositorio atualizado com sucesso"
        if "%VERBOSE_OUTPUT%"=="true" echo [SUCESSO] Repositorio atualizado!
    ) else (
        call :log_message "ERRO" "Falha no git pull"
        if "%VERBOSE_OUTPUT%"=="true" echo [ERRO] Falha no git pull - continuando mesmo assim
    )
) else (
    call :log_message "INFO" "Repositorio ja esta atualizado"
    if "%VERBOSE_OUTPUT%"=="true" echo [INFO] Repositorio ja esta atualizado
)

:: ============ EXECUÇÃO DA APLICAÇÃO ============
:run_application
if not exist "%PYTHON_SCRIPT%" (
    call :log_message "ERRO" "Arquivo Python nao encontrado: %PYTHON_SCRIPT%"
    echo [ERRO] Arquivo nao encontrado: %PYTHON_SCRIPT%
    popd
    goto :exit_script
)

if "%VERBOSE_OUTPUT%"=="true" (
    echo.
    echo [INFO] Iniciando aplicacao Python...
    echo [INFO] Comando: %PYTHON_EXECUTABLE% %PYTHON_SCRIPT%
    echo ==========================================
    echo.
)

call :log_message "INFO" "Iniciando aplicacao: %PYTHON_EXECUTABLE% %PYTHON_SCRIPT%"

:: Executar a aplicação Python
%PYTHON_EXECUTABLE% "%PYTHON_SCRIPT%"
set "exit_code=%errorlevel%"

echo.
call :log_message "INFO" "Aplicacao finalizada com codigo: %exit_code%"

if %exit_code% equ 0 (
    call :log_message "SUCESSO" "Aplicacao executada com sucesso"
    if "%VERBOSE_OUTPUT%"=="true" echo [SUCESSO] Aplicacao executada com sucesso!
) else (
    call :log_message "AVISO" "Aplicacao finalizada com codigo de erro: %exit_code%"
    if "%VERBOSE_OUTPUT%"=="true" echo [AVISO] Aplicacao finalizada com erro (codigo: %exit_code%)
)

:: Retornar ao diretório original
popd

call :log_message "INFO" "=========================================="
call :log_message "INFO" "Processo finalizado"
call :log_message "INFO" "=========================================="

goto :exit_script

:: ============ FUNÇÕES AUXILIARES ============
:log_message
echo [%date% %time%] [%~1] %~2 >> "%LOG_FILE%"
exit /b

:exit_script
if "%PAUSE_ON_EXIT%"=="true" (
    echo.
    echo Pressione qualquer tecla para fechar...
    pause >nul
)
exit /b %exit_code%