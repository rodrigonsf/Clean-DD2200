#!/bin/bash
# ==============================================================================
# ROTEIRO DE VERIFICAÇÃO E RESOLUÇÃO DE ALTO CONSUMO DE ESPAÇO - DATA DOMAIN
# ==============================================================================
#
# Este script interativo se conecta ao Data Domain via SSH e executa os passos
# de diagnóstico para identificar e resolver problemas de capacidade (Active Tier).
#
# PRÉ-REQUISITOS:
# - Acesso via SSH ao Data Domain.
# - Chaves SSH configuradas (recomendado para não pedir senha a cada comando) 
#   ou o usuário precisará digitar a senha algumas vezes.
# ==============================================================================

DD_HOST=${1:-"insira_o_ip_ou_hostname_aqui"}
DD_USER=${2:-"sysadmin"}

if [ "$DD_HOST" == "insira_o_ip_ou_hostname_aqui" ]; then
    echo "Uso: $0 <IP_DO_DATA_DOMAIN> [USUARIO_SSH]"
    echo "Exemplo: $0 192.168.1.50 sysadmin"
    exit 1
fi

echo "========================================================================"
echo "Iniciando Roteiro de Troubleshooting de Espaço no DD ($DD_HOST)"
echo "========================================================================"

# Função para executar comandos no Data Domain via SSH
run_dd_cmd() {
    local cmd=$1
    echo -e "
>>> Executando no Data Domain: $cmd"
    ssh -l "$DD_USER" "$DD_HOST" "$cmd"
}

# ------------------------------------------------------------------------------
# PASSO 1: Verificar o consumo atual do Active Tier e "Cleanable GiB"
# ------------------------------------------------------------------------------
echo -e "
[PASSO 1] Verificando o espaço do File System (df)..."
echo "Objetivo: Identificar a % de uso e o tamanho estimado de dados órfãos que podem ser limpos (Cleanable GiB)."
run_dd_cmd "filesys show space"
read -p "Pressione [ENTER] para continuar para o próximo passo..."

# ------------------------------------------------------------------------------
# PASSO 2: Verificar o status e o agendamento da Limpeza (Garbage Collection)
# ------------------------------------------------------------------------------
echo -e "
[PASSO 2] Verificando o status da Limpeza (GC) e seu agendamento..."
echo "A limpeza (GC) é o único processo que recupera o espaço físico no Active Tier."
run_dd_cmd "filesys clean show schedule"
run_dd_cmd "filesys status"

echo -e "
NOTA: Se o 'Cleanable GiB' for alto ou o sistema estiver 100% cheio, a limpeza deve ser iniciada."
read -p "Deseja iniciar o processo de limpeza agora? (s/n): " start_clean
if [[ "$start_clean" =~ ^[sS]$ ]]; then
    run_dd_cmd "filesys clean start"
    echo "A limpeza foi iniciada. Você pode acompanhar pelo DD usando 'filesys clean watch'."
else
    echo "Início manual da limpeza ignorado."
fi
read -p "Pressione [ENTER] para continuar..."

# ------------------------------------------------------------------------------
# PASSO 3: Verificar contextos de replicação
# ------------------------------------------------------------------------------
echo -e "
[PASSO 3] Verificando atrasos na Replicação..."
echo "Objetivo: Contextos de replicação atrasados (lagging) podem impedir que os dados de origem sejam limpos."
echo "Verifique a data de hora do sistema:"
run_dd_cmd "date"
echo "Agora, verificando o status das replicações:"
run_dd_cmd "replication status"

echo -e "
ATENÇÃO: Se houver contextos onde este DD é a origem e o 'Sync'ed-as-of-time' for muito antigo, isso está retendo espaço."
echo "Comando para corrigir (copie e rode no DD se necessário): replication break <destino>"
read -p "Pressione [ENTER] para continuar..."

# ------------------------------------------------------------------------------
# PASSO 4: Verificar snapshots não expirados
# ------------------------------------------------------------------------------
echo -e "
[PASSO 4] Verificando Snapshots (MTree)..."
echo "Objetivo: Snapshots excessivos ou expirados incorretamente mantêm blocos de dados bloqueados."
run_dd_cmd "snapshot list"

echo -e "
ATENÇÃO: Caso encontre snapshots antigos segurando os dados, eles devem ser expirados:"
echo "Comando para corrigir: snapshot expire <nome_do_snapshot> mtree <caminho_do_mtree>"

echo -e "
========================================================================"
echo "Roteiro concluído. Revise as saídas acima para tomar as medidas corretivas."
echo "Para mais informações, consulte a KB 000054303 da Dell."
echo "========================================================================"
