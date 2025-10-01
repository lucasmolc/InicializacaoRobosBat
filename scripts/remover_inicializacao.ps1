# Removedor da Configuracao de Inicializacao Automatica - Robo Python
# Remove completamente a tarefa agendada de inicializacao

param(
    [switch]$Forcado
)

# Verificar se esta executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Removedor de Inicializacao Automatica - Robo Python" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Verificar se a tarefa existe
    $tarefa = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue

    if ($tarefa) {
        Write-Host "Tarefa encontrada: $($tarefa.TaskName)" -ForegroundColor Yellow
        Write-Host "Status atual: $($tarefa.State)" -ForegroundColor White
        
        # Obter informacoes da acao
        $acao = $tarefa.Actions | Select-Object -First 1
        Write-Host "Arquivo: $($acao.Execute)" -ForegroundColor White
        Write-Host ""

        # Confirmar remocao
        if (-not $Forcado) {
            Write-Host "Deseja realmente remover a inicializacao automatica?" -ForegroundColor Yellow
            Write-Host "[S] Sim  [N] Nao (padrao): " -NoNewline -ForegroundColor White
            $resposta = Read-Host
            
            if ($resposta -notmatch '^[Ss]$') {
                Write-Host "Operacao cancelada pelo usuario" -ForegroundColor Gray
                Write-Host ""
                Read-Host "Pressione Enter para finalizar"
                exit 0
            }
        }

        # Parar tarefa se estiver executando
        if ($tarefa.State -eq "Running") {
            Write-Host "Parando tarefa em execucao..." -ForegroundColor Blue
            Stop-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        # Remover tarefa
        Write-Host "Removendo tarefa agendada..." -ForegroundColor Blue
        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false

        Write-Host "Tarefa removida com sucesso!" -ForegroundColor Green
        Write-Host ""
        Write-Host "A inicializacao automatica foi desabilitada." -ForegroundColor Green
        Write-Host "O robo nao sera mais executado automaticamente na inicializacao." -ForegroundColor Yellow

    } else {
        Write-Host "A tarefa '$NomeTarefa' nao foi encontrada." -ForegroundColor Yellow
        Write-Host "A inicializacao automatica ja esta desabilitada ou nunca foi configurada." -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "Para reconfigurar no futuro:" -ForegroundColor Cyan
    Write-Host "  Execute configurar_inicializacao.bat" -ForegroundColor White

} catch {
    Write-Host "ERRO ao remover:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Solucoes:" -ForegroundColor Cyan
    Write-Host "- Execute como Administrador" -ForegroundColor White
    Write-Host "- Tente novamente apos alguns segundos" -ForegroundColor White
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"
