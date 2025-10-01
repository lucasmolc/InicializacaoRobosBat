# Verificador de Inicializacao Automatica - Robo Python
# Verifica se a tarefa esta configurada e funcionando

param(
    [switch]$Detalhado,
    [switch]$Testar
)

Write-Host "Verificador de Inicializacao Automatica" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Verificar se a tarefa existe
    $tarefa = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
    
    if (-not $tarefa) {
        Write-Host "Tarefa nao encontrada!" -ForegroundColor Red
        Write-Host "Execute configurar_inicializacao.bat como administrador" -ForegroundColor Yellow
        Read-Host "Pressione Enter para sair"
        exit 1
    }

    Write-Host "Tarefa encontrada: $NomeTarefa" -ForegroundColor Green
    Write-Host ""

    # Informacoes da tarefa
    Write-Host "Status da Tarefa:" -ForegroundColor Cyan
    Write-Host "  Estado: $($tarefa.State)" -ForegroundColor White
    
    $info = Get-ScheduledTaskInfo -TaskName $NomeTarefa
    Write-Host "  Ultima execucao: $($info.LastRunTime)" -ForegroundColor White
    Write-Host "  Proximo agendamento: $($info.NextRunTime)" -ForegroundColor White
    Write-Host "  Resultado: $($info.LastTaskResult)" -ForegroundColor $(if($info.LastTaskResult -eq 0){'Green'} else {'Red'})
    Write-Host ""

    # Verificar arquivo
    $caminhoScript = $tarefa.Actions[0].Execute
    Write-Host "Arquivo do Script:" -ForegroundColor Cyan
    
    if (Test-Path $caminhoScript) {
        Write-Host "  Encontrado: $caminhoScript" -ForegroundColor Green
        $arquivo = Get-Item $caminhoScript
        Write-Host "  Modificado: $($arquivo.LastWriteTime)" -ForegroundColor White
    } else {
        Write-Host "  NAO ENCONTRADO: $caminhoScript" -ForegroundColor Red
    }
    Write-Host ""

    # Testar se solicitado
    if ($Testar) {
        if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Host "Para testar, execute como Administrador" -ForegroundColor Yellow
        } else {
            Write-Host "Executando teste..." -ForegroundColor Blue
            Start-ScheduledTask -TaskName $NomeTarefa
            Start-Sleep -Seconds 2
            $statusAtual = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State
            Write-Host "Status do teste: $statusAtual" -ForegroundColor White
        }
    }

    # Status geral
    Write-Host "Status Geral:" -ForegroundColor Cyan
    if ($tarefa.State -eq "Ready" -and (Test-Path $caminhoScript)) {
        Write-Host "  FUNCIONANDO" -ForegroundColor Green
    } else {
        Write-Host "  VERIFICAR CONFIGURACAO" -ForegroundColor Yellow
    }

} catch {
    Write-Host "ERRO:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"