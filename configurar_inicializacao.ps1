# Configurador Automático de Inicialização - Robô Python
# Execute este script como Administrador

param(
    [switch]$Teste,
    [string]$CaminhoScript = "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat",
    [int]$AtrasoMinutos = 2
)

# Verificar se está executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red
    Write-Host "   Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "🚀 Configurador de Inicialização Automática - Robô Python" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# Verificar se o arquivo existe
if (-not (Test-Path $CaminhoScript)) {
    Write-Host "❌ ERRO: Arquivo não encontrado: $CaminhoScript" -ForegroundColor Red
    Write-Host "   Verifique se o caminho está correto ou se o arquivo existe." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "✅ Arquivo encontrado: $CaminhoScript" -ForegroundColor Green

# Nome da tarefa
$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Remover tarefa existente se houver
    $tarefaExistente = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
    if ($tarefaExistente) {
        Write-Host "⚠️  Removendo tarefa existente..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false
        Write-Host "✅ Tarefa existente removida com sucesso" -ForegroundColor Green
    }

    # Criar ação da tarefa
    $acao = New-ScheduledTaskAction -Execute $CaminhoScript

    # Criar disparador (na inicialização com atraso)
    $disparador = New-ScheduledTaskTrigger -AtStartup
    $disparador.Delay = "PT$($AtrasoMinutos)M"  # Formato ISO 8601

    # Configurar principais definições
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    # Configurações da tarefa
    $configuracoes = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

    # Registrar a tarefa
    Write-Host "🔧 Criando tarefa agendada..." -ForegroundColor Blue
    Register-ScheduledTask -TaskName $NomeTarefa -Action $acao -Trigger $disparador -Principal $principal -Settings $configuracoes -Description "Executa automaticamente o robô Python na inicialização do Windows com privilégios de administrador"

    Write-Host "✅ Tarefa criada com sucesso!" -ForegroundColor Green
    Write-Host ""

    # Mostrar informações da tarefa
    Write-Host "📋 Informações da Tarefa:" -ForegroundColor Cyan
    Write-Host "   Nome: $NomeTarefa" -ForegroundColor White
    Write-Host "   Arquivo: $CaminhoScript" -ForegroundColor White
    Write-Host "   Disparador: Na inicialização (atraso: $AtrasoMinutos minutos)" -ForegroundColor White
    Write-Host "   Privilégios: Administrador (SYSTEM)" -ForegroundColor White
    Write-Host "   Reinicialização: Até 3 tentativas (intervalo: 1 minuto)" -ForegroundColor White
    Write-Host ""

    # Testar a tarefa se solicitado
    if ($Teste) {
        Write-Host "🧪 Executando teste da tarefa..." -ForegroundColor Blue
        Start-ScheduledTask -TaskName $NomeTarefa
        Start-Sleep -Seconds 2
        
        $status = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State
        Write-Host "   Status atual: $status" -ForegroundColor White
        
        if ($status -eq "Running") {
            Write-Host "✅ Tarefa está executando corretamente!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Tarefa não está executando. Verifique os logs." -ForegroundColor Yellow
        }
    }

    Write-Host "🎉 Configuração concluída com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Próximos passos:" -ForegroundColor Yellow
    Write-Host "   1. Reinicie o computador para testar" -ForegroundColor White
    Write-Host "   2. Verifique os logs em: logs/inicializacao_*.log" -ForegroundColor White  
    Write-Host "   3. Use 'verificar_inicializacao.ps1' para monitorar" -ForegroundColor White
    Write-Host ""
    Write-Host "⚙️  Para gerenciar a tarefa:" -ForegroundColor Cyan
    Write-Host "   - Abrir: taskschd.msc" -ForegroundColor White
    Write-Host "   - Procurar: $NomeTarefa" -ForegroundColor White

} catch {
    Write-Host "❌ ERRO ao configurar a tarefa:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 Possíveis soluções:" -ForegroundColor Cyan
    Write-Host "   - Verificar se está executando como Administrador" -ForegroundColor White
    Write-Host "   - Verificar se o arquivo .bat existe e é acessível" -ForegroundColor White
    Write-Host "   - Tentar executar: Get-Service -Name Schedule" -ForegroundColor White
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"