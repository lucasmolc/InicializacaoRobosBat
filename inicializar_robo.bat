@echo off
:: ========================================
:: Script de Inicializacao Automatica de Robo Python
:: Versao Otimizada - Sem Ambiente Virtual
:: ========================================

setlocal EnableDelayedExpansion

:: ============ CONFIGURACOES - EDITE AQUI ============
set "PYTHON_APP_DIR=C:\Repositorios\RaspagemInput"
set "PYTHON_SCRIPT=main.py"
set "PYTHON_EXECUTABLE=python"
set "GIT_BRANCH=main"
set "PAUSE_ON_EXIT=true"
set "VERBOSE_OUTPUT=true"
:: ===================================================

:: Configurar arquivo de log com timestamp
set "LOG_FILE=%~dp0logs\inicializacao_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"

:: Criar diretorio de logs se nao existir
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Iniciar log
echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Iniciando processo de verificacao e execucao >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"

if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Verificando atualizacoes do repositorio...
)
echo [%date% %time%] [INFO] Verificando atualizacoes do repositorio... >> "%LOG_FILE%"

:: Verificar se o diretorio da aplicacao existe
if not exist "%PYTHON_APP_DIR%" (
    echo [ERRO] Diretorio da aplicacao nao encontrado: %PYTHON_APP_DIR%
    echo [%date% %time%] [ERRO] Diretorio da aplicacao nao encontrado: %PYTHON_APP_DIR% >> "%LOG_FILE%"
    if "%PAUSE_ON_EXIT%"=="true" (
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    exit /b 1
)

:: Navegar para o diretorio da aplicacao
pushd "%PYTHON_APP_DIR%"
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao navegar para o diretorio: %PYTHON_APP_DIR%
    echo [%date% %time%] [ERRO] Falha ao navegar para o diretorio: %PYTHON_APP_DIR% >> "%LOG_FILE%"
    if "%PAUSE_ON_EXIT%"=="true" (
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    exit /b 1
)

:: Verificar se e um repositorio git
if not exist ".git" (
    echo [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes.
    echo [%date% %time%] [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes. >> "%LOG_FILE%"
    goto :run_application
)

:: Configurar safe.directory ANTES de qualquer operacao Git para evitar erro de ownership
if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Configurando repositorio Git para execucao como SYSTEM...
)
echo [%date% %time%] [INFO] Configurando repositorio Git para execucao como SYSTEM... >> "%LOG_FILE%"
git config --global --add safe.directory "%CD%" 2>>"%LOG_FILE%"

:: Verificar status do repositorio
if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Verificando status do repositorio...
)
echo [%date% %time%] [INFO] Verificando status do repositorio... >> "%LOG_FILE%"

:: Executar git fetch
git fetch origin 2>>"%LOG_FILE%"
if %errorlevel% neq 0 (
    echo [AVISO] Falha ao executar git fetch. Continuando sem atualizacao.
    echo [%date% %time%] [AVISO] Falha ao executar git fetch. Continuando sem atualizacao. >> "%LOG_FILE%"
    goto :run_application
)

:: Verificar se ha commits remotos para puxar
git status -uno 2>nul | findstr "Your branch is behind" >nul
if %errorlevel% equ 0 (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [INFO] Atualizacoes encontradas! Executando git pull...
    )
    echo [%date% %time%] [INFO] Atualizacoes encontradas! Executando git pull... >> "%LOG_FILE%"
    
    git pull origin 2>>"%LOG_FILE%"
    if %errorlevel% equ 0 (
        if "%VERBOSE_OUTPUT%"=="true" (
            echo [SUCESSO] Repositorio atualizado com sucesso!
        )
        echo [%date% %time%] [SUCESSO] Repositorio atualizado com sucesso! >> "%LOG_FILE%"
    ) else (
        echo [ERRO] Falha ao executar git pull. Verifique os logs.
        echo [%date% %time%] [ERRO] Falha ao executar git pull. Verifique os logs. >> "%LOG_FILE%"
        if "%PAUSE_ON_EXIT%"=="true" (
            echo.
            echo Pressione qualquer tecla para continuar mesmo assim...
            pause >nul
        )
    )
) else (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [INFO] Repositorio ja esta atualizado!
    )
    echo [%date% %time%] [INFO] Repositorio ja esta atualizado! >> "%LOG_FILE%"
)

:run_application
:: Verificar se o arquivo Python existe
if not exist "%PYTHON_SCRIPT%" (
    echo [ERRO] Arquivo Python nao encontrado: %PYTHON_SCRIPT%
    echo [%date% %time%] [ERRO] Arquivo Python nao encontrado: %PYTHON_SCRIPT% >> "%LOG_FILE%"
    if "%PAUSE_ON_EXIT%"=="true" (
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    popd
    exit /b 1
)

:: Verificar se Python esta disponivel
if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Verificando disponibilidade do Python...
)
echo [%date% %time%] [INFO] Verificando disponibilidade do Python... >> "%LOG_FILE%"

%PYTHON_EXECUTABLE% --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado no PATH do sistema
    echo [%date% %time%] [ERRO] Python nao encontrado no PATH do sistema >> "%LOG_FILE%"
    if "%VERBOSE_OUTPUT%"=="true" (
        echo.
        echo Solucoes possiveis:
        echo 1. Instalar Python: https://python.org/downloads
        echo 2. Adicionar Python ao PATH do sistema
        echo 3. Editar PYTHON_EXECUTABLE no script para caminho completo
    )
    if "%PAUSE_ON_EXIT%"=="true" (
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    popd
    exit /b 9009
)

if "%VERBOSE_OUTPUT%"=="true" (
    echo.
    echo [INFO] Iniciando aplicacao Python...
)
echo [%date% %time%] [INFO] Iniciando aplicacao Python... >> "%LOG_FILE%"

:: Executar a aplicacao Python
%PYTHON_EXECUTABLE% "%PYTHON_SCRIPT%"
set "exit_code=%errorlevel%"

echo.
echo [%date% %time%] [INFO] Aplicacao finalizada com codigo: %exit_code% >> "%LOG_FILE%"

if %exit_code% equ 0 (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [SUCESSO] Aplicacao executada com sucesso!
    )
    echo [%date% %time%] [SUCESSO] Aplicacao executada com sucesso! >> "%LOG_FILE%"
) else (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [AVISO] Aplicacao finalizada com codigo de erro: %exit_code%
    )
    echo [%date% %time%] [AVISO] Aplicacao finalizada com codigo de erro: %exit_code% >> "%LOG_FILE%"
)

echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Processo finalizado >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: Retornar ao diretorio original
popd

if "%PAUSE_ON_EXIT%"=="true" (
    echo.
    echo Pressione qualquer tecla para finalizar...
    pause >nul
)

exit /b %exit_code%
