# Removedor de Inicialização Automática - Robô Python
# Remove completamente a configuração de inicialização automática

param(
    [switch]$Forcar,
    [switch]$Silencioso
)

if (-not $Silencioso) {
    Write-Host "🗑️  Removedor de Inicialização Automática - Robô Python" -ForegroundColor Red
    Write-Host "=" * 60 -ForegroundColor Red
    Write-Host ""
}

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

# Verificar se está executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ ERRO: Este script deve ser executado como Administrador!" -ForegroundColor Red
    Write-Host "   Clique direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    if (-not $Silencioso) {
        Read-Host "Pressione Enter para sair"
    }
    exit 1
}

try {
    # Verificar se a tarefa existe
    $tarefa = Get-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
    
    if (-not $tarefa) {
        if (-not $Silencioso) {
            Write-Host "ℹ️  Tarefa '$NomeTarefa' não encontrada" -ForegroundColor Blue
            Write-Host "   A inicialização automática já foi removida ou nunca foi configurada" -ForegroundColor White
        }
    } else {
        # Confirmar remoção se não estiver no modo forçado
        if (-not $Forcar -and -not $Silencioso) {
            Write-Host "⚠️  Tarefa encontrada: $NomeTarefa" -ForegroundColor Yellow
            Write-Host "   Esta ação irá remover completamente a inicialização automática" -ForegroundColor White
            Write-Host ""
            
            $confirmacao = Read-Host "Deseja continuar? (S/N)"
            if ($confirmacao -notmatch "^[SsYy]") {
                Write-Host "❌ Operação cancelada pelo usuário" -ForegroundColor Yellow
                Read-Host "Pressione Enter para sair"
                exit 0
            }
            Write-Host ""
        }

        # Parar a tarefa se estiver executando
        $estadoTarefa = $tarefa.State
        if ($estadoTarefa -eq "Running") {
            if (-not $Silencioso) {
                Write-Host "⏹️  Parando tarefa em execução..." -ForegroundColor Blue
            }
            Stop-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        # Remover a tarefa
        if (-not $Silencioso) {
            Write-Host "🗑️  Removendo tarefa agendada..." -ForegroundColor Red
        }
        
        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false
        
        if (-not $Silencioso) {
            Write-Host "✅ Tarefa removida com sucesso!" -ForegroundColor Green
        }
    }

    # Verificar outras configurações de inicialização automática
    if (-not $Silencioso) {
        Write-Host ""
        Write-Host "🔍 Verificando outras configurações de inicialização..." -ForegroundColor Cyan
    }

    # Verificar Registro do Windows
    $chaveRegistro = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $valoresRegistro = @("RoboPython", "RoboPythonInit", "InicializacaoRobo")
    $encontrouRegistro = $false

    foreach ($valor in $valoresRegistro) {
        $entradaRegistro = Get-ItemProperty -Path $chaveRegistro -Name $valor -ErrorAction SilentlyContinue
        if ($entradaRegistro) {
            $encontrouRegistro = $true
            if (-not $Silencioso) {
                Write-Host "   🔧 Removendo entrada do registro: $valor" -ForegroundColor Blue
            }
            Remove-ItemProperty -Path $chaveRegistro -Name $valor -ErrorAction SilentlyContinue
        }
    }

    if (-not $encontrouRegistro -and -not $Silencioso) {
        Write-Host "   ✅ Nenhuma entrada encontrada no registro" -ForegroundColor Green
    } elseif ($encontrouRegistro -and -not $Silencioso) {
        Write-Host "   ✅ Entradas do registro removidas" -ForegroundColor Green
    }

    # Verificar pasta Startup
    $pastaStartup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $arquivosStartup = Get-ChildItem $pastaStartup -Filter "*robo*" -ErrorAction SilentlyContinue
    
    if ($arquivosStartup.Count -gt 0) {
        foreach ($arquivo in $arquivosStartup) {
            if (-not $Silencioso) {
                Write-Host "   🔧 Removendo da pasta Startup: $($arquivo.Name)" -ForegroundColor Blue
            }
            Remove-Item $arquivo.FullName -Force -ErrorAction SilentlyContinue
        }
        if (-not $Silencioso) {
            Write-Host "   ✅ Arquivos da pasta Startup removidos" -ForegroundColor Green
        }
    } elseif (-not $Silencioso) {
        Write-Host "   ✅ Nenhum arquivo encontrado na pasta Startup" -ForegroundColor Green
    }

    if (-not $Silencioso) {
        Write-Host ""
        Write-Host "🎉 Remoção concluída com sucesso!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📝 O que foi feito:" -ForegroundColor Cyan
        Write-Host "   ✅ Tarefa agendada removida" -ForegroundColor White
        Write-Host "   ✅ Entradas do registro verificadas e limpas" -ForegroundColor White
        Write-Host "   ✅ Pasta Startup verificada e limpa" -ForegroundColor White
        Write-Host ""
        Write-Host "💡 Para reativar a inicialização automática:" -ForegroundColor Yellow
        Write-Host "   Execute: .\configurar_inicializacao.ps1" -ForegroundColor White
    }

} catch {
    Write-Host "❌ ERRO durante a remoção:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Yellow
    
    if (-not $Silencioso) {
        Write-Host ""
        Write-Host "💡 Possíveis soluções:" -ForegroundColor Cyan
        Write-Host "   - Verificar se está executando como Administrador" -ForegroundColor White
        Write-Host "   - Tentar novamente com -Forcar" -ForegroundColor White
        Write-Host "   - Remover manualmente via taskschd.msc" -ForegroundColor White
    }
}

if (-not $Silencioso) {
    Write-Host ""
    Read-Host "Pressione Enter para finalizar"
}