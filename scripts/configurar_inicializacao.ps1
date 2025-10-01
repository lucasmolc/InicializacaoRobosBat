# Configurador Automatico de Inicializacao - Robo Python# Configurador Automatico de Inicializacao - Robo Python# Configurador Automático de Inicialização - Robô Python

# Execute este script como Administrador

# Execute este script como Administrador# Execute este script como Administrador

param(

    [switch]$Teste,

    [string]$CaminhoScript = "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat",

    [int]$AtrasoMinutos = 2param(param(

)

    [switch]$Teste,    [switch]$Teste,

# Verificar se esta executando como administrador

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {    [string]$CaminhoScript = "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat",    [string]$CaminhoScript = "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat",

    Write-Host "ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red

    Write-Host "Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow    [int]$AtrasoMinutos = 2    [int]$AtrasoMinutos = 2

    Read-Host "Pressione Enter para sair"

    exit 1))

}



Write-Host "Configurador de Inicializacao Automatica - Robo Python" -ForegroundColor Cyan

Write-Host "========================================" -ForegroundColor Cyan# Verificar se esta executando como administrador# Verificar se está executando como administrador

Write-Host ""

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

# Verificar se o arquivo existe

if (-not (Test-Path $CaminhoScript)) {    Write-Host "ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red    Write-Host "❌ ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red

    Write-Host "ERRO: Arquivo nao encontrado: $CaminhoScript" -ForegroundColor Red

    Write-Host "Verifique se o caminho esta correto." -ForegroundColor Yellow    Write-Host "   Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow    Write-Host "   Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow

    Read-Host "Pressione Enter para sair"

    exit 1    Read-Host "Pressione Enter para sair"    Read-Host "Pressione Enter para sair"

}

    exit 1    exit 1

Write-Host "Arquivo encontrado: $CaminhoScript" -ForegroundColor Green

}}

# Nome da tarefa

$NomeTarefa = "RoboPython_InicializacaoAutomatica"



try {Write-Host "Configurador de Inicializacao Automatica - Robo Python" -ForegroundColor CyanWrite-Host "🚀 Configurador de Inicialização Automática - Robô Python" -ForegroundColor Cyan

    # Remover tarefa existente se houver

    $tarefaExistente = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinueWrite-Host "=" * 60 -ForegroundColor CyanWrite-Host "=" * 60 -ForegroundColor Cyan

    if ($tarefaExistente) {

        Write-Host "Removendo tarefa existente..." -ForegroundColor YellowWrite-Host ""Write-Host ""

        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false

        Write-Host "Tarefa existente removida" -ForegroundColor Green

    }

# Verificar se o arquivo existe# Verificar se o arquivo existe

    # Criar acao da tarefa

    $acao = New-ScheduledTaskAction -Execute $CaminhoScriptif (-not (Test-Path $CaminhoScript)) {if (-not (Test-Path $CaminhoScript)) {



    # Criar disparador    Write-Host "ERRO: Arquivo nao encontrado: $CaminhoScript" -ForegroundColor Red    Write-Host "❌ ERRO: Arquivo não encontrado: $CaminhoScript" -ForegroundColor Red

    $disparador = New-ScheduledTaskTrigger -AtStartup

    $disparador.Delay = "PT$($AtrasoMinutos)M"    Write-Host "   Verifique se o caminho esta correto ou se o arquivo existe." -ForegroundColor Yellow    Write-Host "   Verifique se o caminho está correto ou se o arquivo existe." -ForegroundColor Yellow



    # Configurar principais definicoes    Read-Host "Pressione Enter para sair"    Read-Host "Pressione Enter para sair"

    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    exit 1    exit 1

    # Configuracoes da tarefa

    $configuracoes = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)}}



    # Registrar a tarefa

    Write-Host "Criando tarefa agendada..." -ForegroundColor Blue

    Register-ScheduledTask -TaskName $NomeTarefa -Action $acao -Trigger $disparador -Principal $principal -Settings $configuracoes -Description "Executa automaticamente o robo Python na inicializacao"Write-Host "Arquivo encontrado: $CaminhoScript" -ForegroundColor GreenWrite-Host "✅ Arquivo encontrado: $CaminhoScript" -ForegroundColor Green



    Write-Host "Tarefa criada com sucesso!" -ForegroundColor Green

    Write-Host ""

    Write-Host "Informacoes da Tarefa:" -ForegroundColor Cyan# Nome da tarefa# Nome da tarefa

    Write-Host "  Nome: $NomeTarefa" -ForegroundColor White

    Write-Host "  Arquivo: $CaminhoScript" -ForegroundColor White$NomeTarefa = "RoboPython_InicializacaoAutomatica"$NomeTarefa = "RoboPython_InicializacaoAutomatica"

    Write-Host "  Atraso: $AtrasoMinutos minutos apos boot" -ForegroundColor White

    Write-Host ""



    # Testar se solicitadotry {try {

    if ($Teste) {

        Write-Host "Testando tarefa..." -ForegroundColor Blue    # Remover tarefa existente se houver    # Remover tarefa existente se houver

        Start-ScheduledTask -TaskName $NomeTarefa

        Start-Sleep -Seconds 2    $tarefaExistente = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue    $tarefaExistente = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue

        $status = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State

        Write-Host "Status: $status" -ForegroundColor White    if ($tarefaExistente) {    if ($tarefaExistente) {

    }

        Write-Host "Removendo tarefa existente..." -ForegroundColor Yellow        Write-Host "⚠️  Removendo tarefa existente..." -ForegroundColor Yellow

    Write-Host "Configuracao concluida!" -ForegroundColor Green

    Write-Host "Reinicie o computador para testar" -ForegroundColor Yellow        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false



} catch {        Write-Host "Tarefa existente removida com sucesso" -ForegroundColor Green        Write-Host "✅ Tarefa existente removida com sucesso" -ForegroundColor Green

    Write-Host "ERRO ao configurar:" -ForegroundColor Red

    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow    }    }

    Write-Host ""

    Write-Host "Solucoes:" -ForegroundColor Cyan

    Write-Host "- Execute como Administrador" -ForegroundColor White

    Write-Host "- Verifique se o arquivo .bat existe" -ForegroundColor White    # Criar acao da tarefa    # Criar ação da tarefa

}

    $acao = New-ScheduledTaskAction -Execute $CaminhoScript    $acao = New-ScheduledTaskAction -Execute $CaminhoScript

Write-Host ""

Read-Host "Pressione Enter para finalizar"

    # Criar disparador (na inicializacao com atraso)    # Criar disparador (na inicialização com atraso)

    $disparador = New-ScheduledTaskTrigger -AtStartup    $disparador = New-ScheduledTaskTrigger -AtStartup

    $disparador.Delay = "PT$($AtrasoMinutos)M"  # Formato ISO 8601    $disparador.Delay = "PT$($AtrasoMinutos)M"  # Formato ISO 8601



    # Configurar principais definicoes    # Configurar principais definições

    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest



    # Configuracoes da tarefa    # Configurações da tarefa

    $configuracoes = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)    $configuracoes = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)



    # Registrar a tarefa    # Registrar a tarefa

    Write-Host "Criando tarefa agendada..." -ForegroundColor Blue    Write-Host "🔧 Criando tarefa agendada..." -ForegroundColor Blue

    Register-ScheduledTask -TaskName $NomeTarefa -Action $acao -Trigger $disparador -Principal $principal -Settings $configuracoes -Description "Executa automaticamente o robo Python na inicializacao do Windows com privilegios de administrador"    Register-ScheduledTask -TaskName $NomeTarefa -Action $acao -Trigger $disparador -Principal $principal -Settings $configuracoes -Description "Executa automaticamente o robô Python na inicialização do Windows com privilégios de administrador"



    Write-Host "Tarefa criada com sucesso!" -ForegroundColor Green    Write-Host "✅ Tarefa criada com sucesso!" -ForegroundColor Green

    Write-Host ""    Write-Host ""



    # Mostrar informacoes da tarefa    # Mostrar informações da tarefa

    Write-Host "Informacoes da Tarefa:" -ForegroundColor Cyan    Write-Host "📋 Informações da Tarefa:" -ForegroundColor Cyan

    Write-Host "   Nome: $NomeTarefa" -ForegroundColor White    Write-Host "   Nome: $NomeTarefa" -ForegroundColor White

    Write-Host "   Arquivo: $CaminhoScript" -ForegroundColor White    Write-Host "   Arquivo: $CaminhoScript" -ForegroundColor White

    Write-Host "   Disparador: Na inicializacao (atraso: $AtrasoMinutos minutos)" -ForegroundColor White    Write-Host "   Disparador: Na inicialização (atraso: $AtrasoMinutos minutos)" -ForegroundColor White

    Write-Host "   Privilegios: Administrador (SYSTEM)" -ForegroundColor White    Write-Host "   Privilégios: Administrador (SYSTEM)" -ForegroundColor White

    Write-Host "   Reinicializacao: Ate 3 tentativas (intervalo: 1 minuto)" -ForegroundColor White    Write-Host "   Reinicialização: Até 3 tentativas (intervalo: 1 minuto)" -ForegroundColor White

    Write-Host ""    Write-Host ""



    # Testar a tarefa se solicitado    # Testar a tarefa se solicitado

    if ($Teste) {    if ($Teste) {

        Write-Host "Executando teste da tarefa..." -ForegroundColor Blue        Write-Host "🧪 Executando teste da tarefa..." -ForegroundColor Blue

        Start-ScheduledTask -TaskName $NomeTarefa        Start-ScheduledTask -TaskName $NomeTarefa

        Start-Sleep -Seconds 2        Start-Sleep -Seconds 2

                

        $status = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State        $status = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State

        Write-Host "   Status atual: $status" -ForegroundColor White        Write-Host "   Status atual: $status" -ForegroundColor White

                

        if ($status -eq "Running") {        if ($status -eq "Running") {

            Write-Host "Tarefa esta executando corretamente!" -ForegroundColor Green            Write-Host "✅ Tarefa está executando corretamente!" -ForegroundColor Green

        } else {        } else {

            Write-Host "Tarefa nao esta executando. Verifique os logs." -ForegroundColor Yellow            Write-Host "⚠️  Tarefa não está executando. Verifique os logs." -ForegroundColor Yellow

        }        }

    }    }



    Write-Host "Configuracao concluida com sucesso!" -ForegroundColor Green    Write-Host "🎉 Configuração concluída com sucesso!" -ForegroundColor Green

    Write-Host ""    Write-Host ""

    Write-Host "Proximos passos:" -ForegroundColor Yellow    Write-Host "📝 Próximos passos:" -ForegroundColor Yellow

    Write-Host "   1. Reinicie o computador para testar" -ForegroundColor White    Write-Host "   1. Reinicie o computador para testar" -ForegroundColor White

    Write-Host "   2. Verifique os logs em: logs/inicializacao_*.log" -ForegroundColor White      Write-Host "   2. Verifique os logs em: logs/inicializacao_*.log" -ForegroundColor White  

    Write-Host "   3. Use 'verificar_inicializacao.ps1' para monitorar" -ForegroundColor White    Write-Host "   3. Use 'verificar_inicializacao.ps1' para monitorar" -ForegroundColor White

    Write-Host ""    Write-Host ""

    Write-Host "Para gerenciar a tarefa:" -ForegroundColor Cyan    Write-Host "⚙️  Para gerenciar a tarefa:" -ForegroundColor Cyan

    Write-Host "   - Abrir: taskschd.msc" -ForegroundColor White    Write-Host "   - Abrir: taskschd.msc" -ForegroundColor White

    Write-Host "   - Procurar: $NomeTarefa" -ForegroundColor White    Write-Host "   - Procurar: $NomeTarefa" -ForegroundColor White



} catch {} catch {

    Write-Host "ERRO ao configurar a tarefa:" -ForegroundColor Red    Write-Host "❌ ERRO ao configurar a tarefa:" -ForegroundColor Red

    Write-Host "   $($_.Exception.Message)" -ForegroundColor Yellow    Write-Host "   $($_.Exception.Message)" -ForegroundColor Yellow

    Write-Host ""    Write-Host ""

    Write-Host "Possiveis solucoes:" -ForegroundColor Cyan    Write-Host "💡 Possíveis soluções:" -ForegroundColor Cyan

    Write-Host "   - Verificar se esta executando como Administrador" -ForegroundColor White    Write-Host "   - Verificar se está executando como Administrador" -ForegroundColor White

    Write-Host "   - Verificar se o arquivo .bat existe e e acessivel" -ForegroundColor White    Write-Host "   - Verificar se o arquivo .bat existe e é acessível" -ForegroundColor White

    Write-Host "   - Tentar executar: Get-Service -Name Schedule" -ForegroundColor White    Write-Host "   - Tentar executar: Get-Service -Name Schedule" -ForegroundColor White

}}



Write-Host ""Write-Host ""

Read-Host "Pressione Enter para finalizar"Read-Host "Pressione Enter para finalizar"