# Dell Data Domain: Space Troubleshooting Script 🛠️💾

Um script Bash interativo projetado para auxiliar administradores de infraestrutura e backup na identificação e resolução de problemas de **alto consumo de espaço** (Active Tier) em sistemas Dell EMC Data Domain.

Este projeto é totalmente baseado no roteiro de diagnóstico oficial da **DellEMC**.

## 📋 Funcionalidades

O script automatiza a execução de comandos via SSH no DD OS, dividindo a análise em 4 etapas guiadas:

1. **Análise de Consumo:** Verifica o uso do *Active Tier* e o espaço estimável para limpeza (*Cleanable GiB*).
2. **Garbage Collection (GC):** Checa o status e o agendamento da limpeza do file system, com opção de iniciá-la diretamente pelo script.
3. **Auditoria de Replicação:** Identifica atrasos (*lagging*) em contextos de replicação que podem estar retendo dados expirados na origem.
4. **Verificação de Snapshots:** Lista snapshots antigos de MTrees que continuam alocando blocos no disco de forma não intencional.

## ⚙️ Pré-requisitos

Para rodar este script, você precisará de:
- Um terminal Linux, macOS ou WSL (Windows Subsystem for Linux).
- Cliente `ssh` instalado.
- Conectividade de rede com o IP/Hostname do Data Domain (Porta 22).
- Credenciais de administrador do Data Domain (padrão: `sysadmin`).

> **💡 Dica Pro:** Recomenda-se configurar a autenticação por **Chaves SSH (Public Key)** entre a sua máquina e o Data Domain para que a senha não seja solicitada a cada passo do script.

## 🚀 Como usar

1. **Faça o download ou clone o arquivo:**
   Baixe o arquivo `dd_space_troubleshooting.sh` para a sua máquina.

2. **Dê permissão de execução:**
   ```bash
   chmod +x dd_space_troubleshooting.sh
