# Guia de Configuração para Inicialização Automática com Privilégios de Administrador

## Métodos Disponíveis

### Método 1: Agendador de Tarefas (RECOMENDADO)
**Vantagens:** Execução com privilégios de admin, log detalhado, flexibilidade total

### Método 2: Serviço do Windows (AVANÇADO)
**Vantagens:** Execução como serviço, reinicialização automática em falhas

### Método 3: Registro do Windows (SIMPLES)
**Vantagens:** Configuração rápida, mas requer UAC manual

---

## MÉTODO 1: Agendador de Tarefas (Task Scheduler)

### Configuração Manual:

1. **Abrir Agendador de Tarefas**
   - Pressione `Win + R` → digite `taskschd.msc` → Enter

2. **Criar Tarefa Básica**
   - Clique em "Criar Tarefa..." (não "Criar Tarefa Básica")
   - Nome: `Inicializacao Robo Python`
   - Descrição: `Executa robô Python automaticamente na inicialização`

3. **Configurar Segurança**
   - ✅ Marque "Executar com privilégios mais altos"
   - ✅ Marque "Executar estando o usuário conectado ou não"
   - Configure para o usuário administrador

4. **Configurar Disparadores**
   - Aba "Disparadores" → "Novo..."
   - Iniciar a tarefa: "Na inicialização"
   - Atrasar tarefa por: 2 minutos (para aguardar sistema carregar)

5. **Configurar Ações**
   - Aba "Ações" → "Nova..."
   - Ação: "Iniciar um programa"
   - Programa/script: `C:\Projects\InicializacaoRobosBat\inicializar_robo.bat`

6. **Configurar Condições**
   - Aba "Condições"
   - ❌ Desmarque "Iniciar a tarefa apenas se o computador estiver conectado à energia CA"
   - ✅ Marque "Ativar se a tarefa perder um agendamento"

7. **Configurar Configurações**
   - Aba "Configurações"
   - ✅ Marque "Permitir que a tarefa seja executada sob demanda"
   - ✅ Marque "Se a tarefa falhar, reiniciar a cada: 1 minuto"
   - Tentar reiniciar até: 3 vezes

### Configuração via PowerShell (AUTOMÁTICA):
Execute o script `configurar_inicializacao.ps1` como administrador.

---

## MÉTODO 2: Serviço do Windows

### Usando NSSM (Non-Sucking Service Manager):

1. **Baixar NSSM**
   - Download: https://nssm.cc/download
   - Extrair para: `C:\nssm\`

2. **Instalar como Serviço**
   ```cmd
   cd C:\nssm\win64
   nssm install "RoboPython" "C:\Projects\InicializacaoRobosBat\inicializar_robo.bat"
   nssm set "RoboPython" Start SERVICE_AUTO_START
   nssm start "RoboPython"
   ```

---

## MÉTODO 3: Registro do Windows

### Configuração:

1. **Abrir Editor de Registro**
   - `Win + R` → `regedit` → Enter

2. **Navegar para:**
   ```
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
   ```

3. **Criar Nova Entrada**
   - Clique direito → "Novo" → "Valor da Cadeia de Caracteres"
   - Nome: `RoboPythonInit`
   - Valor: `C:\Projects\InicializacaoRobosBat\inicializar_robo.bat`

**NOTA:** Este método NÃO executa com privilégios de admin automaticamente.

---

## Scripts Auxiliares Inclusos

### 1. `configurar_inicializacao.ps1`
- Configura automaticamente o Agendador de Tarefas
- Executa com privilégios de administrador
- Logs detalhados da configuração

### 2. `verificar_inicializacao.ps1`  
- Verifica se a tarefa está configurada corretamente
- Testa a execução da tarefa
- Mostra status e próximas execuções

### 3. `remover_inicializacao.ps1`
- Remove a configuração de inicialização automática
- Limpeza completa das configurações

---

## Recomendação Final

**MÉTODO RECOMENDADO:** Agendador de Tarefas com script PowerShell

**Por quê?**
- ✅ Execução com privilégios de administrador garantidos
- ✅ Log detalhado de execução e falhas  
- ✅ Reinicialização automática em caso de falha
- ✅ Atraso configurável para aguardar sistema carregar
- ✅ Fácil gerenciamento e monitoramento
- ✅ Funciona mesmo sem usuário logado

**Como usar:**
1. Execute `configurar_inicializacao.ps1` como administrador
2. Verifique com `verificar_inicializacao.ps1`
3. Teste reinicializando a máquina

---

## Troubleshooting

### Problema: Tarefa não executa
- Verificar se está com privilégios de administrador
- Conferir caminho do arquivo .bat
- Verificar logs no Visualizador de Eventos

### Problema: UAC solicita confirmação
- Usar Agendador de Tarefas com "privilégios mais altos"
- Configurar para executar sem usuário conectado

### Problema: Falha na execução
- Aumentar atraso de inicialização (3-5 minutos)
- Verificar dependências (Python, Git instalados)
- Conferir logs do próprio script em `logs/`