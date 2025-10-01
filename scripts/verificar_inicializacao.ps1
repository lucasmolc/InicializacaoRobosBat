# Verificador de Status da Inicializacao Automatica - Robo Python
# Verifica se a tarefa agendada esta configurada corretamente

param(
    [switch]$Detalhado
)

Write-Host "Verificador de Inicializacao Automatica - Robo Python" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Verificar se a tarefa existe
    $tarefa = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue

    if ($tarefa) {
        Write-Host "STATUS: CONFIGURADO" -ForegroundColor Green
        Write-Host ""
        
        # Informacoes basicas
        Write-Host "Informacoes da Tarefa:" -ForegroundColor Cyan
        Write-Host "  Nome: $($tarefa.TaskName)" -ForegroundColor White
        Write-Host "  Status: $($tarefa.State)" -ForegroundColor White
        
        # Obter detalhes da acao
        $acao = $tarefa.Actions | Select-Object -First 1
        Write-Host "  Arquivo: $($acao.Execute)" -ForegroundColor White
        
        # Verificar se o arquivo existe
        if (Test-Path $acao.Execute) {
            Write-Host "  Arquivo encontrado: SIM" -ForegroundColor Green
        } else {
            Write-Host "  Arquivo encontrado: NAO" -ForegroundColor Red
        }

        # Informacoes do disparador
        $disparador = $tarefa.Triggers | Select-Object -First 1
        Write-Host "  Tipo: Inicializacao do sistema" -ForegroundColor White
        
        if ($disparador.Delay) {
            $atraso = [System.Xml.XmlConvert]::ToTimeSpan($disparador.Delay)
            Write-Host "  Atraso: $($atraso.TotalMinutes) minutos" -ForegroundColor White
        }

        # Obter historico de execucoes
        Write-Host ""
        Write-Host "Historico de Execucoes (ultimas 5):" -ForegroundColor Cyan
        
        $eventos = Get-WinEvent -FilterHashtable @{LogName="Microsoft-Windows-TaskScheduler/Operational"; ID=200,201} -MaxEvents 5 -ErrorAction SilentlyContinue | Where-Object {$_.Message -like "*$NomeTarefa*"}
        
        if ($eventos) {
            foreach ($evento in $eventos) {
                $status = if ($evento.Id -eq 200) { "INICIADO" } else { "CONCLUIDO" }
                Write-Host "  $($evento.TimeCreated.ToString('dd/MM/yyyy HH:mm:ss')) - $status" -ForegroundColor White
            }
        } else {
            Write-Host "  Nenhuma execucao registrada ainda" -ForegroundColor Yellow
        }

        # Informacoes detalhadas
        if ($Detalhado) {
            Write-Host ""
            Write-Host "Informacoes Detalhadas:" -ForegroundColor Cyan
            Write-Host "  Usuario: $($tarefa.Principal.UserId)" -ForegroundColor White
            Write-Host "  Privilegio: $($tarefa.Principal.RunLevel)" -ForegroundColor White
            Write-Host "  Tipo de Logon: $($tarefa.Principal.LogonType)" -ForegroundColor White
            
            if ($tarefa.Settings) {
                Write-Host "  Permitir bateria: $($tarefa.Settings.AllowStartIfOnBatteries)" -ForegroundColor White
                Write-Host "  Continuar na bateria: $($tarefa.Settings.DontStopIfGoingOnBatteries)" -ForegroundColor White
                Write-Host "  Iniciar quando disponivel: $($tarefa.Settings.StartWhenAvailable)" -ForegroundColor White
                Write-Host "  Tentativas de reinicio: $($tarefa.Settings.RestartCount)" -ForegroundColor White
            }
        }

        Write-Host ""
        Write-Host "Para testar manualmente:" -ForegroundColor Yellow
        Write-Host "  Start-ScheduledTask -TaskName '$NomeTarefa'" -ForegroundColor White

    } else {
        Write-Host "STATUS: NAO CONFIGURADO" -ForegroundColor Red
        Write-Host ""
        Write-Host "A tarefa '$NomeTarefa' nao foi encontrada." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Para configurar:" -ForegroundColor Cyan
        Write-Host "  Execute configurar_inicializacao.bat" -ForegroundColor White
        Write-Host "  ou" -ForegroundColor Gray
        Write-Host "  PowerShell -ExecutionPolicy Bypass -File scripts\\configurar_inicializacao.ps1" -ForegroundColor White
    }

} catch {
    Write-Host "ERRO ao verificar:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"
