# Removedor de Inicializacao Automatica - Robo Python
# Remove a configuracao de inicializacao automatica

param(
    [switch]$Forcar,
    [switch]$Silencioso
)

if (-not $Silencioso) {
    Write-Host "Removedor de Inicializacao Automatica" -ForegroundColor Red
    Write-Host "=====================================" -ForegroundColor Red
    Write-Host ""
}

$NomeTarefa = "RoboPython_InicializacaoAutomatica"

# Verificar admin
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERRO: Execute como Administrador!" -ForegroundColor Red
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
            Write-Host "Tarefa nao encontrada - ja foi removida" -ForegroundColor Blue
        }
    } else {
        # Confirmar se nao forcado
        if (-not $Forcar -and -not $Silencioso) {
            Write-Host "Tarefa encontrada: $NomeTarefa" -ForegroundColor Yellow
            Write-Host "Isso ira remover a inicializacao automatica" -ForegroundColor White
            $confirmacao = Read-Host "Continuar? (S/N)"
            if ($confirmacao -notmatch "^[SsYy]") {
                Write-Host "Cancelado" -ForegroundColor Yellow
                exit 0
            }
        }

        # Parar se executando
        if ($tarefa.State -eq "Running") {
            if (-not $Silencioso) {
                Write-Host "Parando tarefa..." -ForegroundColor Blue
            }
            Stop-ScheduledTask -TaskName $NomeTarefa -ErrorAction SilentlyContinue
        }

        # Remover tarefa
        if (-not $Silencioso) {
            Write-Host "Removendo tarefa..." -ForegroundColor Red
        }
        Unregister-ScheduledTask -TaskName $NomeTarefa -Confirm:$false
        
        if (-not $Silencioso) {
            Write-Host "Tarefa removida com sucesso!" -ForegroundColor Green
        }
    }

    # Limpar outras configuracoes
    if (-not $Silencioso) {
        Write-Host "Verificando outras configuracoes..." -ForegroundColor Cyan
    }

    # Registry
    $chaveReg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $valores = @("RoboPython", "RoboPythonInit", "InicializacaoRobo")
    
    foreach ($valor in $valores) {
        $entrada = Get-ItemProperty -Path $chaveReg -Name $valor -ErrorAction SilentlyContinue
        if ($entrada) {
            if (-not $Silencioso) {
                Write-Host "Removendo do registry: $valor" -ForegroundColor Blue
            }
            Remove-ItemProperty -Path $chaveReg -Name $valor -ErrorAction SilentlyContinue
        }
    }

    if (-not $Silencioso) {
        Write-Host ""
        Write-Host "Remocao concluida!" -ForegroundColor Green
        Write-Host "Para reativar, execute configurar_inicializacao.bat" -ForegroundColor Yellow
    }

} catch {
    Write-Host "ERRO:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Yellow
}

if (-not $Silencioso) {
    Write-Host ""
    Read-Host "Pressione Enter para finalizar"
}