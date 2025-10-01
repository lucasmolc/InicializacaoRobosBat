@echo off
:: Configurador Rápido de Inicialização Automática
:: Este arquivo facilita a execução dos scripts PowerShell

echo.
echo ===============================================
echo  Configurador de Inicializacao Automatica
echo ===============================================
echo.

:: Verificar se está executando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Este script deve ser executado como Administrador!
    echo.
    echo Como executar como administrador:
    echo 1. Clique direito neste arquivo
    echo 2. Selecione "Executar como administrador"
    echo.
    pause
    exit /b 1
)

:menu
cls
echo.
echo ===============================================
echo  Configurador de Inicializacao Automatica
echo ===============================================
echo.
echo Escolha uma opcao:
echo.
echo 1. Configurar inicializacao automatica
echo 2. Verificar configuracao atual
echo 3. Testar execucao da tarefa
echo 4. Remover inicializacao automatica
echo 5. Abrir guia de configuracao
echo 6. Sair
echo.
set /p opcao="Digite sua opcao (1-6): "

if "%opcao%"=="1" goto configurar
if "%opcao%"=="2" goto verificar
if "%opcao%"=="3" goto testar
if "%opcao%"=="4" goto remover
if "%opcao%"=="5" goto guia
if "%opcao%"=="6" goto sair
echo.
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto menu

:configurar
cls
echo.
echo [INFO] Configurando inicializacao automatica...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0configurar_inicializacao.ps1"
echo.
pause
goto menu

:verificar
cls
echo.
echo [INFO] Verificando configuracao atual...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0verificar_inicializacao.ps1" -Detalhado
echo.
pause
goto menu

:testar
cls
echo.
echo [INFO] Testando execucao da tarefa...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0verificar_inicializacao.ps1" -Testar
echo.
pause
goto menu

:remover
cls
echo.
echo [INFO] Removendo inicializacao automatica...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0remover_inicializacao.ps1"
echo.
pause
goto menu

:guia
cls
echo.
echo [INFO] Abrindo guia de configuracao...
echo.
if exist "%~dp0INICIALIZACAO_WINDOWS.md" (
    start "" "%~dp0INICIALIZACAO_WINDOWS.md"
) else (
    echo [ERRO] Arquivo de guia nao encontrado: INICIALIZACAO_WINDOWS.md
)
echo.
pause
goto menu

:sair
echo.
echo Saindo...
exit /b 0