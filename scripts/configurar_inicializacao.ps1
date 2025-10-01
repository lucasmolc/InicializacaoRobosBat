# Configurador Automatico de Inicializacao - Robo Python
# Execute este script como Administrador

param(
    [switch]$Teste,
    [string]$CaminhoScript = "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat",
    [int]$AtrasoMinutos = 2
)

# Verificar se esta executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Configurador de Inicializacao Automatica - Robo Python" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o arquivo existe
if (-not (Test-Path $CaminhoScript)) {
    Write-Host "ERRO: Arquivo nao encontrado: $CaminhoScript" -ForegroundColor Red
    Write-Host "Verifique se o caminho esta correto." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Arquivo encontrado: $CaminhoScript" -ForegroundColor Green

# Nome da tarefa
$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Remover tarefa existente se houver
    $tarefaExistente = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
    if ($tarefaExistente) {
        Write-Host "Removendo tarefa existente..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false
        Write-Host "Tarefa existente removida" -ForegroundColor Green
    }

    # Criar acao da tarefa
    $acao = New-ScheduledTaskAction -Execute $CaminhoScript

    # Criar disparador
    $disparador = New-ScheduledTaskTrigger -AtStartup
    $disparador.Delay = "PT$($AtrasoMinutos)M"

    # Configurar principais definicoes
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    # Configuracoes da tarefa
    $configuracoes = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

    # Registrar a tarefa
    Write-Host "Criando tarefa agendada..." -ForegroundColor Blue
    Register-ScheduledTask -TaskName $NomeTarefa -Action $acao -Trigger $disparador -Principal $principal -Settings $configuracoes -Description "Executa automaticamente o robo Python na inicializacao"

    Write-Host "Tarefa criada com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Informacoes da Tarefa:" -ForegroundColor Cyan
    Write-Host "  Nome: $NomeTarefa" -ForegroundColor White
    Write-Host "  Arquivo: $CaminhoScript" -ForegroundColor White
    Write-Host "  Atraso: $AtrasoMinutos minutos apos boot" -ForegroundColor White
    Write-Host ""

    # Testar se solicitado
    if ($Teste) {
        Write-Host "Testando tarefa..." -ForegroundColor Blue
        Start-ScheduledTask -TaskName $NomeTarefa
        Start-Sleep -Seconds 2
        $status = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State
        Write-Host "Status: $status" -ForegroundColor White
    }

    Write-Host "Configuracao concluida!" -ForegroundColor Green
    Write-Host "Reinicie o computador para testar" -ForegroundColor Yellow

} catch {
    Write-Host "ERRO ao configurar:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Solucoes:" -ForegroundColor Cyan
    Write-Host "- Execute como Administrador" -ForegroundColor White
    Write-Host "- Verifique se o arquivo .bat existe" -ForegroundColor White
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"
