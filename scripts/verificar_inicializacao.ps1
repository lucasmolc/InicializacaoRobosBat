# Verificador de Inicialização Automática - Robô Python
# Verifica se a tarefa está configurada e funcionando corretamente

param(
    [switch]$Detalhado,
    [switch]$Testar
)

Write-Host "🔍 Verificador de Inicialização Automática - Robô Python" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

try {
    # Verificar se a tarefa existe
    $tarefa = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
    
    if (-not $tarefa) {
        Write-Host "❌ Tarefa não encontrada!" -ForegroundColor Red
        Write-Host "   Execute 'configurar_inicializacao.ps1' como administrador para criar" -ForegroundColor Yellow
        Read-Host "Pressione Enter para sair"
        exit 1
    }

    Write-Host "✅ Tarefa encontrada: $NomeTarefa" -ForegroundColor Green
    Write-Host ""

    # Informações básicas da tarefa
    Write-Host "📋 Status da Tarefa:" -ForegroundColor Cyan
    Write-Host "   Estado: $($tarefa.State)" -ForegroundColor White
    
    $info = Get-ScheduledTaskInfo -TaskName $NomeTarefa
    Write-Host "   Última execução: $($info.LastRunTime)" -ForegroundColor White
    Write-Host "   Próxima execução: $($info.NextRunTime)" -ForegroundColor White
    Write-Host "   Último resultado: $($info.LastTaskResult) $(if($info.LastTaskResult -eq 0){'(Sucesso)'} else {'(Erro)'})" -ForegroundColor $(if($info.LastTaskResult -eq 0){'Green'} else {'Red'})
    Write-Host ""

    # Verificar configurações se solicitado
    if ($Detalhado) {
        Write-Host "🔧 Configurações Detalhadas:" -ForegroundColor Cyan
        
        # Ações
        $acoes = $tarefa.Actions
        Write-Host "   Ações configuradas:" -ForegroundColor White
        foreach ($acao in $acoes) {
            Write-Host "     - Executar: $($acao.Execute)" -ForegroundColor Gray
            if ($acao.Arguments) {
                Write-Host "       Argumentos: $($acao.Arguments)" -ForegroundColor Gray
            }
        }
        
        # Disparadores
        $disparadores = $tarefa.Triggers
        Write-Host "   Disparadores:" -ForegroundColor White
        foreach ($disparador in $disparadores) {
            Write-Host "     - Tipo: $($disparador.CimClass.CimClassName)" -ForegroundColor Gray
            if ($disparador.Delay) {
                Write-Host "       Atraso: $($disparador.Delay)" -ForegroundColor Gray
            }
        }
        
        # Principal
        Write-Host "   Execução:" -ForegroundColor White
        Write-Host "     - Usuário: $($tarefa.Principal.UserId)" -ForegroundColor Gray
        Write-Host "     - Privilégios: $(if($tarefa.Principal.RunLevel -eq 'Highest'){'Administrador'} else {'Usuário'})" -ForegroundColor Gray
        Write-Host ""
    }

    # Verificar arquivo de script
    $caminhoScript = $tarefa.Actions[0].Execute
    Write-Host "📁 Verificação do Arquivo:" -ForegroundColor Cyan
    
    if (Test-Path $caminhoScript) {
        Write-Host "   ✅ Arquivo encontrado: $caminhoScript" -ForegroundColor Green
        
        $arquivo = Get-Item $caminhoScript
        Write-Host "   📅 Última modificação: $($arquivo.LastWriteTime)" -ForegroundColor White
        Write-Host "   📏 Tamanho: $([math]::Round($arquivo.Length/1KB, 2)) KB" -ForegroundColor White
    } else {
        Write-Host "   ❌ Arquivo não encontrado: $caminhoScript" -ForegroundColor Red
        Write-Host "      A tarefa não funcionará até o arquivo ser criado!" -ForegroundColor Yellow
    }
    Write-Host ""

    # Verificar logs recentes
    $pastaLogs = Split-Path $caminhoScript -Parent | Join-Path -ChildPath "logs"
    Write-Host "📄 Verificação de Logs:" -ForegroundColor Cyan
    
    if (Test-Path $pastaLogs) {
        $logsRecentes = Get-ChildItem $pastaLogs -Filter "inicializacao_*.log" -ErrorAction SilentlyContinue | 
                       Sort-Object LastWriteTime -Descending | 
                       Select-Object -First 3
        
        if ($logsRecentes.Count -gt 0) {
            Write-Host "   ✅ Logs encontrados ($($logsRecentes.Count) arquivos recentes):" -ForegroundColor Green
            foreach ($log in $logsRecentes) {
                Write-Host "     - $($log.Name) ($($log.LastWriteTime))" -ForegroundColor Gray
            }
            
            # Mostrar últimas linhas do log mais recente
            $ultimoLog = $logsRecentes[0].FullName
            Write-Host "   📝 Últimas linhas do log mais recente:" -ForegroundColor White
            $ultimasLinhas = Get-Content $ultimoLog -Tail 5 -ErrorAction SilentlyContinue
            if ($ultimasLinhas) {
                foreach ($linha in $ultimasLinhas) {
                    Write-Host "      $linha" -ForegroundColor Gray
                }
            }
        } else {
            Write-Host "   ⚠️  Nenhum log encontrado na pasta: $pastaLogs" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ⚠️  Pasta de logs não encontrada: $pastaLogs" -ForegroundColor Yellow
    }
    Write-Host ""

    # Testar execução se solicitado
    if ($Testar) {
        Write-Host "🧪 Executando Teste da Tarefa:" -ForegroundColor Cyan
        
        # Verificar se está executando como admin para o teste
        if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Host "   ⚠️  Para testar, execute este script como Administrador" -ForegroundColor Yellow
        } else {
            Write-Host "   🚀 Iniciando tarefa..." -ForegroundColor Blue
            Start-ScheduledTask -TaskName $NomeTarefa
            
            Start-Sleep -Seconds 3
            
            $statusAtual = Get-ScheduledTask -TaskName $NomeTarefa | Select-Object -ExpandProperty State
            Write-Host "   📊 Status após início: $statusAtual" -ForegroundColor White
            
            if ($statusAtual -eq "Running") {
                Write-Host "   ✅ Tarefa executando corretamente!" -ForegroundColor Green
            } elseif ($statusAtual -eq "Ready") {
                Write-Host "   ℹ️  Tarefa finalizou rapidamente (normal para scripts)" -ForegroundColor Blue
            } else {
                Write-Host "   ⚠️  Status inesperado. Verifique os logs." -ForegroundColor Yellow
            }
        }
        Write-Host ""
    }

    # Resumo e recomendações
    Write-Host "📊 Resumo:" -ForegroundColor Cyan
    $status = "✅ Funcionando"
    $cor = "Green"
    
    if ($tarefa.State -ne "Ready") {
        $status = "⚠️  Verificar configuração"
        $cor = "Yellow"
    }
    
    if (-not (Test-Path $caminhoScript)) {
        $status = "❌ Arquivo de script ausente"
        $cor = "Red"
    }
    
    if ($info.LastTaskResult -ne 0 -and $info.LastRunTime) {
        $status = "❌ Última execução falhou"
        $cor = "Red"
    }
    
    Write-Host "   Status geral: $status" -ForegroundColor $cor
    Write-Host ""
    
    Write-Host "💡 Comandos úteis:" -ForegroundColor Yellow
    Write-Host "   - Testar agora: .\verificar_inicializacao.ps1 -Testar" -ForegroundColor White
    Write-Host "   - Ver detalhes: .\verificar_inicializacao.ps1 -Detalhado" -ForegroundColor White
    Write-Host "   - Abrir gerenciador: taskschd.msc" -ForegroundColor White
    Write-Host "   - Remover tarefa: .\remover_inicializacao.ps1" -ForegroundColor White

} catch {
    Write-Host "❌ ERRO ao verificar a tarefa:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Pressione Enter para finalizar"