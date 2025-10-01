@echo off
:: ========================================
:: Script de Inicialização Automática de Robô Python
:: Versão Otimizada - Sem Ambiente Virtual
:: ========================================

setlocal EnableDelayedExpansion

:: ============ CONFIGURAÇÕES - EDITE AQUI ============
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

:: Criar diretório de logs se não existir
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Iniciar log
echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Iniciando processo de verificacao e execucao >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"

if "%VERBOSE_OUTPUT%"=="true" (
    echo [INFO] Verificando atualizacoes do repositorio...
)
echo [%date% %time%] [INFO] Verificando atualizacoes do repositorio... >> "%LOG_FILE%"

:: Verificar se o diretório da aplicação existe
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

:: Navegar para o diretório da aplicação
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

:: Verificar se é um repositório git
if not exist ".git" (
    echo [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes.
    echo [%date% %time%] [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes. >> "%LOG_FILE%"
    goto :run_application
)

:: Configurar safe.directory para evitar erro de ownership quando executado como SYSTEM
echo [INFO] Configurando repositorio Git para execucao como SYSTEM...
echo [%date% %time%] [INFO] Configurando repositorio Git para execucao como SYSTEM... >> "%LOG_FILE%"
git config --global --add safe.directory "%CD%" 2>>"%LOG_FILE%"

:: Verificar status do repositório
echo [INFO] Verificando status do repositorio...
echo [%date% %time%] [INFO] Verificando status do repositorio... >> "%LOG_FILE%"
:: Script de Inicialização Automática de Robô Python
:: ========================================

setlocal EnableDelayedExpansion

:: Configurações (ajuste conforme necessário)
set "PYTHON_APP_DIR=C:\Repositorios\RaspagemInput"
set "PYTHON_SCRIPT=main.py"
set "LOG_FILE=%~dp0logs\inicializacao_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"

:: Criar diretório de logs se não existir
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Iniciar log
echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Iniciando processo de verificacao e execucao >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"

echo [INFO] Verificando atualizacoes do repositorio...
echo [%date% %time%] [INFO] Verificando atualizacoes do repositorio... >> "%LOG_FILE%"

:: Verificar se o diretório da aplicação existe
if not exist "%PYTHON_APP_DIR%" (
    echo [ERRO] Diretorio da aplicacao nao encontrado: %PYTHON_APP_DIR%
    echo [%date% %time%] [ERRO] Diretorio da aplicacao nao encontrado: %PYTHON_APP_DIR% >> "%LOG_FILE%"
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    exit /b 1
)

:: Navegar para o diretório da aplicação
pushd "%PYTHON_APP_DIR%"
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao navegar para o diretorio: %PYTHON_APP_DIR%
    echo [%date% %time%] [ERRO] Falha ao navegar para o diretorio: %PYTHON_APP_DIR% >> "%LOG_FILE%"
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    exit /b 1
)

:: Verificar se é um repositório git
if not exist ".git" (
    echo [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes.
    echo [%date% %time%] [AVISO] Este diretorio nao e um repositorio Git. Pulando verificacao de atualizacoes. >> "%LOG_FILE%"
    goto :run_application
)

:: Configurar safe.directory ANTES de qualquer operação Git para evitar erro de ownership
echo [INFO] Configurando repositorio Git para execucao como SYSTEM...
echo [%date% %time%] [INFO] Configurando repositorio Git para execucao como SYSTEM... >> "%LOG_FILE%"
git config --global --add safe.directory "%CD%" 2>>"%LOG_FILE%"

:: Verificar status do repositório
echo [INFO] Verificando status do repositorio...
echo [%date% %time%] [INFO] Verificando status do repositorio... >> "%LOG_FILE%"

::Criar arquivo temporário para capturar erro do git
set "TEMP_ERROR=%TEMP%\git_error_%RANDOM%.tmp"
git fetch origin 2>"%TEMP_ERROR%"
if %errorlevel% neq 0 (
    :: Verificar se é erro de ownership
    findstr /C:"dubious ownership" "%TEMP_ERROR%" >nul
    if %errorlevel% equ 0 (
        echo [INFO] Resolvendo problema de ownership do Git...
        echo [%date% %time%] [INFO] Resolvendo problema de ownership do Git... >> "%LOG_FILE%"
        :: Tentar novamente após configurar safe.directory
        git fetch origin 2>>"%LOG_FILE%"
        if %errorlevel% neq 0 (
            echo [AVISO] Falha ao executar git fetch mesmo apos configuracao. Continuando sem atualizacao.
            echo [%date% %time%] [AVISO] Falha ao executar git fetch mesmo apos configuracao. Continuando sem atualizacao. >> "%LOG_FILE%"
            type "%TEMP_ERROR%" >> "%LOG_FILE%"
        )
    ) else (
        echo [AVISO] Falha ao executar git fetch. Continuando sem atualizacao.
        echo [%date% %time%] [AVISO] Falha ao executar git fetch. Continuando sem atualizacao. >> "%LOG_FILE%"
        type "%TEMP_ERROR%" >> "%LOG_FILE%"
    )
    if exist "%TEMP_ERROR%" del "%TEMP_ERROR%"
    if %errorlevel% neq 0 goto :run_application
) else (
    if exist "%TEMP_ERROR%" del "%TEMP_ERROR%"
)

:: Verificar se há commits remotos para puxar
git status -uno 2>nul | findstr "Your branch is behind" >nul
if %errorlevel% equ 0 (
    echo [INFO] Atualizacoes encontradas! Executando git pull...
    echo [%date% %time%] [INFO] Atualizacoes encontradas! Executando git pull... >> "%LOG_FILE%"
    
    set "TEMP_PULL_ERROR=%TEMP%\git_pull_error_%RANDOM%.tmp"
    git pull origin 2>"%TEMP_PULL_ERROR%"
    if %errorlevel% equ 0 (
        echo [SUCESSO] Repositorio atualizado com sucesso!
        echo [%date% %time%] [SUCESSO] Repositorio atualizado com sucesso! >> "%LOG_FILE%"
        if exist "%TEMP_PULL_ERROR%" del "%TEMP_PULL_ERROR%"
    ) else (
        :: Verificar se é erro de ownership no git pull também
        findstr /C:"dubious ownership" "%TEMP_PULL_ERROR%" >nul
        if %errorlevel% equ 0 (
            echo [INFO] Resolvendo problema de ownership para git pull...
            echo [%date% %time%] [INFO] Resolvendo problema de ownership para git pull... >> "%LOG_FILE%"
            :: Tentar git pull novamente
            git pull origin 2>>"%LOG_FILE%"
            if %errorlevel% equ 0 (
                echo [SUCESSO] Repositorio atualizado com sucesso apos correcao!
                echo [%date% %time%] [SUCESSO] Repositorio atualizado com sucesso apos correcao! >> "%LOG_FILE%"
            ) else (
                echo [ERRO] Falha ao executar git pull mesmo apos configuracao. Verifique os logs.
                echo [%date% %time%] [ERRO] Falha ao executar git pull mesmo apos configuracao. Verifique os logs. >> "%LOG_FILE%"
                type "%TEMP_PULL_ERROR%" >> "%LOG_FILE%"
            )
        ) else (
            echo [ERRO] Falha ao executar git pull. Verifique os logs.
            echo [%date% %time%] [ERRO] Falha ao executar git pull. Verifique os logs. >> "%LOG_FILE%"
            type "%TEMP_PULL_ERROR%" >> "%LOG_FILE%"
        )
        if exist "%TEMP_PULL_ERROR%" del "%TEMP_PULL_ERROR%"
        echo.
        echo Pressione qualquer tecla para continuar mesmo assim...
        pause >nul
    )
) else (
    echo [INFO] Repositorio ja esta atualizado!
    echo [%date% %time%] [INFO] Repositorio ja esta atualizado! >> "%LOG_FILE%"
)

:run_application
:: Verificar se o arquivo Python existe
if not exist "%PYTHON_SCRIPT%" (
    echo [ERRO] Arquivo Python nao encontrado: %PYTHON_SCRIPT%
    echo [%date% %time%] [ERRO] Arquivo Python nao encontrado: %PYTHON_SCRIPT% >> "%LOG_FILE%"
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    popd
    exit /b 1
)

:: Verificar se Python está disponível
echo [INFO] Verificando disponibilidade do Python...
echo [%date% %time%] [INFO] Verificando disponibilidade do Python... >> "%LOG_FILE%"

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado no PATH do sistema
    echo [%date% %time%] [ERRO] Python nao encontrado no PATH do sistema >> "%LOG_FILE%"
    echo.
    echo Solucoes possiveis:
    echo 1. Instalar Python: https://python.org/downloads
    echo 2. Adicionar Python ao PATH do sistema
    echo 3. Editar PYTHON_EXECUTABLE no script para caminho completo
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    popd
    exit /b 9009
)

echo.
echo [INFO] Iniciando aplicacao Python...
echo [%date% %time%] [INFO] Iniciando aplicacao Python... >> "%LOG_FILE%"

:: Executar a aplicação Python
python "%PYTHON_SCRIPT%"
set "exit_code=%errorlevel%"

echo.
echo [%date% %time%] [INFO] Aplicacao finalizada com codigo: %exit_code% >> "%LOG_FILE%"

if %exit_code% equ 0 (
    echo [SUCESSO] Aplicacao executada com sucesso!
    echo [%date% %time%] [SUCESSO] Aplicacao executada com sucesso! >> "%LOG_FILE%"
) else (
    echo [AVISO] Aplicacao finalizada com codigo de erro: %exit_code%
    echo [%date% %time%] [AVISO] Aplicacao finalizada com codigo de erro: %exit_code% >> "%LOG_FILE%"
)

echo ========================================== >> "%LOG_FILE%"
echo [%date% %time%] Processo finalizado >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: Retornar ao diretório original
popd

echo.
echo Pressione qualquer tecla para fechar...
pause >nul

exit /b %exit_code%  echo.
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