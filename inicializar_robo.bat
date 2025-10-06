@echo off
:: ========================================
:: Script de Inicializacao Automatica de Robo Python
:: Versao Otimizada - Sem Ambiente Virtual
:: ========================================

:: Configurar console
title Automação Python

setlocal EnableDelayedExpansion

:: ============ CONFIGURACOES - EDITE AQUI ============
:: Detectar automaticamente o diretorio da aplicacao
set "CURRENT_DIR=%~dp0"
for /f "tokens=1,2,3 delims=\" %%a in ("%CURRENT_DIR%") do (
    if /i "%%b"=="Projects" (
        set "BASE_DIR=%%a\%%b"
    ) else if /i "%%b"=="Repositorios" (
        set "BASE_DIR=%%a\%%b"
    )
)
:: Se não encontrou Projects ou Repositorios, usar diretório pai do script
if not defined BASE_DIR (
    for %%i in ("%CURRENT_DIR%..") do set "BASE_DIR=%%~fi"
)
set "PYTHON_APP_DIR=%BASE_DIR%\RaspagemInput"

set "PYTHON_SCRIPT=main.py"
set "PYTHON_EXECUTABLE=python"
set "ENVIRONMENT_PARAM=PRD"
set "VENV_NAME=venv"
set "REQUIREMENTS_FILE=requirements.txt"
set "GIT_BRANCH=main"
set "PAUSE_ON_EXIT=true"
set "VERBOSE_OUTPUT=true"
set "AUTO_INSTALL_REQUIREMENTS=true"
:: ===================================================

:: Configurar arquivo de log com timestamp
set "LOG_FILE=%~dp0logs\inicializacao_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"

:: Criar diretorio de logs se nao existir
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Iniciar log
echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Iniciando processo de verificacao e execucao >> "%LOG_FILE%"
echo [%date% %time%] Diretorio detectado automaticamente: %PYTHON_APP_DIR% >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"

if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Diretorio detectado: %PYTHON_APP_DIR%
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

:: ========================================
:: CONFIGURACAO DO AMBIENTE VIRTUAL (VENV)
:: ========================================

:: Definir caminhos do ambiente virtual
set "VENV_PATH=%CD%\%VENV_NAME%"
set "VENV_PYTHON=%VENV_PATH%\Scripts\python.exe"
set "VENV_PIP=%VENV_PATH%\Scripts\pip.exe"
set "VENV_ACTIVATE=%VENV_PATH%\Scripts\activate.bat"

:: Verificar se ambiente virtual existe
if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Verificando ambiente virtual...
)
echo [%date% %time%] [INFO] Verificando ambiente virtual em: %VENV_PATH% >> "%LOG_FILE%"

if not exist "%VENV_PATH%" (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [INFO] Ambiente virtual nao encontrado. Criando...
    )
    echo [%date% %time%] [INFO] Criando ambiente virtual: %VENV_NAME% >> "%LOG_FILE%"
    
    %PYTHON_EXECUTABLE% -m venv "%VENV_PATH%" 2>>"%LOG_FILE%"
    if %errorlevel% neq 0 (
        echo [ERRO] Falha ao criar ambiente virtual
        echo [%date% %time%] [ERRO] Falha ao criar ambiente virtual >> "%LOG_FILE%"
        if "%PAUSE_ON_EXIT%"=="true" (
            echo.
            echo Pressione qualquer tecla para continuar...
            pause >nul
        )
        popd
        exit /b 1
    )
    
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [SUCESSO] Ambiente virtual criado com sucesso!
    )
    echo [%date% %time%] [SUCESSO] Ambiente virtual criado: %VENV_PATH% >> "%LOG_FILE%"
) else (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [INFO] Ambiente virtual encontrado: %VENV_NAME%
    )
    echo [%date% %time%] [INFO] Ambiente virtual existente encontrado >> "%LOG_FILE%"
)

:: Verificar se o ambiente virtual esta funcionando
if not exist "%VENV_PYTHON%" (
    echo [ERRO] Ambiente virtual corrompido - Python nao encontrado
    echo [%date% %time%] [ERRO] Ambiente virtual corrompido em: %VENV_PATH% >> "%LOG_FILE%"
    if "%PAUSE_ON_EXIT%"=="true" (
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    popd
    exit /b 1
)

:: Atualizar PYTHON_EXECUTABLE para usar o ambiente virtual
set "PYTHON_EXECUTABLE=%VENV_PYTHON%"

if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Usando Python do ambiente virtual: %VENV_NAME%
)
echo [%date% %time%] [INFO] Python configurado para ambiente virtual >> "%LOG_FILE%"

:: ========================================
:: INSTALACAO DE DEPENDENCIAS
:: ========================================

if "%AUTO_INSTALL_REQUIREMENTS%"=="true" (
    if exist "%REQUIREMENTS_FILE%" (
        if "%VERBOSE_OUTPUT%"=="true" (
            echo [INFO] Verificando e instalando dependencias...
        )
        echo [%date% %time%] [INFO] Verificando requirements.txt >> "%LOG_FILE%"
        
        :: Atualizar pip primeiro
        if "%VERBOSE_OUTPUT%"=="true" (
            echo [INFO] Atualizando pip...
        )
        echo [%date% %time%] [INFO] Atualizando pip no ambiente virtual >> "%LOG_FILE%"
        "%VENV_PYTHON%" -m pip install --upgrade pip >>"%LOG_FILE%" 2>&1
        
        :: Instalar dependencias
        if "%VERBOSE_OUTPUT%"=="true" (
            echo [INFO] Instalando dependencias do requirements.txt...
        )
        echo [%date% %time%] [INFO] Instalando dependencias: %REQUIREMENTS_FILE% >> "%LOG_FILE%"
        
        "%VENV_PYTHON%" -m pip install -r "%REQUIREMENTS_FILE%" >>"%LOG_FILE%" 2>&1
        if %errorlevel% equ 0 (
            if "%VERBOSE_OUTPUT%"=="true" (
                echo [SUCESSO] Dependencias instaladas com sucesso!
            )
            echo [%date% %time%] [SUCESSO] Todas as dependencias foram instaladas >> "%LOG_FILE%"
        ) else (
            echo [AVISO] Algumas dependencias podem ter falhado na instalacao
            echo [%date% %time%] [AVISO] Verificar logs - algumas dependencias falharam >> "%LOG_FILE%"
        )
    ) else (
        if "%VERBOSE_OUTPUT%"=="true" (
            echo [AVISO] Arquivo requirements.txt nao encontrado
        )
        echo [%date% %time%] [AVISO] requirements.txt nao encontrado em: %CD% >> "%LOG_FILE%"
    )
) else (
    if "%VERBOSE_OUTPUT%"=="true" (
        echo [INFO] Instalacao automatica de dependencias desabilitada
    )
    echo [%date% %time%] [INFO] AUTO_INSTALL_REQUIREMENTS=false - pulando dependencias >> "%LOG_FILE%"
)

if "%VERBOSE_OUTPUT%"=="true" (
    echo.
    echo [INFO] Iniciando aplicacao Python com parametro: %ENVIRONMENT_PARAM%
)
echo [%date% %time%] [INFO] Iniciando aplicacao Python com parametro: %ENVIRONMENT_PARAM% >> "%LOG_FILE%"

:: Executar a aplicacao Python com parametro de ambiente
%PYTHON_EXECUTABLE% "%PYTHON_SCRIPT%" %ENVIRONMENT_PARAM%
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
