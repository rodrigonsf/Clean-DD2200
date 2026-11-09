# Recuperação de espaço com NetWorker e Data Domain

Procedimento documentado para selecionar save sets no NetWorker, preparar comandos de exclusão com base nos SSIDs, executar a etapa de manutenção no NetWorker e iniciar a limpeza do sistema de arquivos no Data Domain.

Publicado originalmente por Rodrigo N. S. Fernandes, com o nome de usuário RodrickNunes, na Dell Community, em 28 de novembro de 2020.

Este repositório preserva o procedimento histórico em um formato estruturado, com exemplos de comandos, capturas de tela, cuidados operacionais e referências.

## Sumário

- [Aviso de segurança](#aviso-de-segurança)
- [Visão geral](#visão-geral)
- [Ambiente histórico](#ambiente-histórico)
- [Escopo e limitações](#escopo-e-limitações)
- [Pré-requisitos](#pré-requisitos)
- [Procedimento](#procedimento)
  - [1. Identificar os save sets](#1-identificar-os-save-sets)
  - [2. Preparar a lista de comandos com os SSIDs](#2-preparar-a-lista-de-comandos-com-os-ssids)
  - [3. Executar os comandos no NetWorker](#3-executar-os-comandos-no-networker)
  - [4. Consultar o espaço no Data Domain](#4-consultar-o-espaço-no-data-domain)
  - [5. Iniciar e acompanhar o cleaning](#5-iniciar-e-acompanhar-o-cleaning)
- [Validação e evidências registradas](#validação-e-evidências-registradas)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Referências](#referências)
- [Autor e publicação original](#autor-e-publicação-original)

## Aviso de segurança

> **ATENÇÃO:** Este procedimento inclui comandos destrutivos de exclusão de backups.
>
> Não execute os exemplos sem revisar os save sets selecionados, os requisitos de retenção, as dependências de recuperação e a documentação aplicável ao seu ambiente.

Antes de prosseguir:

- Obtenha autorização para excluir os backups selecionados.
- Confira cada SSID e sua correspondência com o backup que se pretende excluir.
- Confirme que os backups selecionados não são mais necessários para recuperação.
- Revise os requisitos aplicáveis de retenção, conformidade e proteção de dados.
- Confirme o escopo e o comportamento de cada comando nas versões instaladas.
- Verifique se outras cópias de backup ou dependências afetam a operação pretendida.
- Utilize uma janela de manutenção aprovada quando necessário.

Os exemplos incluem a opção `-y`, conforme utilizada no procedimento original. Não copie os comandos para uma sessão de produção sem revisá-los.

Este repositório documenta uma contribuição histórica da comunidade. Ele não constitui um procedimento oficial da Dell, uma garantia de compatibilidade ou um substituto para a documentação e o suporte do fabricante.

## Visão geral

O procedimento original segue esta sequência:

```text
Identificar os save sets no NetWorker
                  |
                  v
Copiar os SSIDs e preparar os comandos de exclusão
                  |
                  v
Executar os comandos nsrmm no servidor NetWorker
                  |
                  v
Executar nsrim -X
                  |
                  v
Consultar o espaço no Data Domain
                  |
                  v
Iniciar e acompanhar o cleaning
```

O procedimento documenta ações no NetWorker e no Data Domain. Ele não deve ser interpretado como uma garantia de que a exclusão de determinado volume lógico de backups recuperará a mesma quantidade de armazenamento físico.

Neste documento, o termo `cleaning` se refere à operação de limpeza do sistema de arquivos do Data Domain, preservando a nomenclatura dos comandos e do post original.

## Ambiente histórico

As capturas de tela originais mostram as seguintes versões:

| Componente | Versão exibida |
|---|---|
| NetWorker Administration | 19.1.0.2, Build 74 |
| Data Domain OS | 6.0.2.30-606339 |

Os comandos do NetWorker foram executados por meio de uma sessão SSH em um NetWorker Virtual Appliance. Os comandos do Data Domain foram executados em uma sessão SSH separada.

Esses detalhes descrevem o exemplo histórico. Eles não estabelecem suporte ou compatibilidade para outras versões ou outros tipos de implantação.

## Escopo e limitações

Este documento aborda:

- A seleção de save sets visíveis no NetWorker.
- A obtenção de seus SSIDs.
- A preparação e a execução dos comandos de exclusão utilizados no post original.
- A execução de `nsrim -X`.
- A consulta do espaço no sistema de arquivos do Data Domain.
- O início e o acompanhamento do cleaning.

Este documento não fornece:

- Um procedimento de recuperação para um Data Domain sem espaço disponível.
- Um método para localizar dados órfãos depois que os save sets já desapareceram da base de mídias do NetWorker.
- Uma garantia da quantidade de capacidade física que será recuperada.
- Instruções de diagnóstico para replicação, snapshots, bloqueios de retenção ou outras condições que possam afetar a recuperação de espaço.
- Evidências da quantidade final de espaço recuperado no exemplo original.

Embora o título da discussão original se refira a save sets já excluídos, esta contribuição específica começa pela seleção de save sets ainda visíveis no NetWorker.

A captura original do Data Domain mostra 25% de utilização do sistema de arquivos. Portanto, este exemplo não deve ser apresentado como um procedimento testado para um sistema de arquivos completamente cheio.

## Pré-requisitos

Antes de utilizar este procedimento, confirme que você possui:

- Acesso autorizado ao NetWorker Administration.
- Acesso administrativo adequado ao servidor NetWorker.
- Acesso administrativo adequado ao Data Domain.
- Uma lista aprovada de backups para exclusão.
- A documentação aplicável às versões instaladas do NetWorker e do DD OS.
- Um local para registrar as saídas dos comandos e as medições anteriores e posteriores à operação.

O procedimento original utilizou o Excel para preparar as linhas de comando. A planilha faz parte do exemplo documentado, mas não representa uma exigência de automatização da execução.

## Procedimento

### 1. Identificar os save sets

No NetWorker Administration:

1. Abra a seção `Media`.
2. Selecione `Disk Volumes`.
3. Localize o volume correspondente.
4. Abra o menu de contexto do volume e selecione `Show Save Sets`.
5. Identifique os backups que se pretende excluir.
6. Revise a coluna `SSID` e os demais detalhes dos backups.

Selecione somente os save sets abrangidos pela solicitação de exclusão aprovada.

Local sugerido para a captura de tela da seleção do volume:

```text
docs/images/01-networker-show-save-sets.jpg
```

Local sugerido para a captura de tela da seleção dos SSIDs:

```text
docs/images/02-networker-ssid-selection.jpg
```

### 2. Preparar a lista de comandos com os SSIDs

O procedimento original utilizou a seguinte abordagem:

1. Selecionar os save sets desejados.
2. Pressionar `Ctrl+C`.
3. Colar as linhas copiadas no Excel.
4. Manter a coluna que contém os SSIDs.
5. Preparar uma linha de comando para cada SSID aprovado.

Modelo do comando:

```bash
nsrmm -d -S <SSID> -y
```

Substitua `<SSID>` pelo identificador revisado. Não digite os sinais `<` e `>`.

Para documentação e conferência, a lista preparada deve seguir este formato:

```text
nsrmm -d -S <SSID_APROVADO_1> -y
nsrmm -d -S <SSID_APROVADO_2> -y
nsrmm -d -S <SSID_APROVADO_3> -y
```

Essas linhas são modelos, não comandos prontos para execução.

Antes de executar, revise a lista completa e verifique se existem:

- SSIDs incorretos.
- Entradas duplicadas.
- Dígitos ausentes ou truncados.
- Alterações inesperadas de formatação na planilha.
- Backups fora do escopo de exclusão aprovado.

Local sugerido para a captura de tela:

```text
docs/images/03-command-preparation.jpg
```

### 3. Executar os comandos no NetWorker

Abra uma sessão administrativa autorizada no servidor NetWorker correto.

No exemplo original, foi utilizada uma sessão SSH no NetWorker Virtual Appliance.

Execute os comandos `nsrmm` previamente revisados:

```bash
nsrmm -d -S <SSID> -y
```

Registre as saídas dos comandos e investigue eventuais erros antes de continuar.

Após a execução dos comandos de exclusão, o procedimento original executa:

```bash
nsrim -X
```

Esse comando está incluído aqui para preservar a sequência documentada no post original. Antes de executá-lo, revise sua finalidade, seu escopo e as orientações do fabricante aplicáveis à versão instalada.

Local sugerido para a captura de tela:

```text
docs/images/04-networker-cli.jpg
```

### 4. Consultar o espaço no Data Domain

Abra uma sessão SSH administrativa separada no Data Domain.

Execute:

```bash
filesys show space
```

Registre a saída antes de iniciar o cleaning.

A captura de tela original apresenta os seguintes valores:

| Métrica | Valor registrado |
|---|---:|
| Capacidade de `/data: post-comp` | 3757,6 GiB |
| Espaço utilizado | 952,3 GiB |
| Espaço disponível | 2805,3 GiB |
| Utilização | 25% |
| Espaço indicado em `Cleanable GiB` | 136,1 GiB |

A saída identifica o valor de `Cleanable GiB` como uma estimativa baseada no último cleaning.

Os 136,1 GiB exibidos não devem ser apresentados como a quantidade efetivamente recuperada pela operação de cleaning iniciada em seguida.

### 5. Iniciar e acompanhar o cleaning

Após concluir as revisões aplicáveis e confirmar que o cleaning é apropriado para o ambiente, inicie a operação:

```bash
filesys clean start
```

Acompanhe o andamento com:

```bash
filesys clean watch
```

A captura de tela original mostra a seguinte confirmação:

```text
Cleaning started. Use 'filesys clean watch' to monitor progress.
```

O post original informa que a conclusão pode levar algumas horas. Essa observação não deve ser tratada como uma duração garantida para outros sistemas.

Após a conclusão do cleaning, obtenha uma nova consulta de espaço:

```bash
filesys show space
```

Essa medição final é uma etapa recomendada de documentação para novas execuções. As capturas originais não incluem uma consulta de espaço após a conclusão do cleaning.

Local sugerido para a captura de tela:

```text
docs/images/05-datadomain-cleaning.jpg
```

## Validação e evidências registradas

As capturas de tela originais documentam:

- A interface de seleção do volume e dos save sets no NetWorker.
- A coluna de SSIDs utilizada para identificar os backups selecionados.
- Uma planilha com as linhas de comando preparadas.
- A execução da sequência de comandos `nsrmm`.
- O comando `nsrim -X` ao final da sequência.
- O espaço no sistema de arquivos do Data Domain antes do cleaning.
- A confirmação de que o cleaning foi iniciado.

Elas não comprovam:

- A conclusão bem-sucedida de toda a operação de cleaning.
- A quantidade exata de armazenamento físico recuperado.
- Uma comparação de espaço antes e depois da operação.
- A aplicabilidade do procedimento a um Data Domain completamente cheio.

Para uma nova execução, registre:

| Item | Antes | Depois |
|---|---|---|
| Data e hora da medição | Registrar valor | Registrar valor |
| Espaço utilizado em GiB | Registrar valor | Registrar valor |
| Espaço disponível em GiB | Registrar valor | Registrar valor |
| `Cleanable GiB` | Registrar valor | Registrar valor |
| Estado do cleaning | Registrar estado | Registrar estado |

Documente também a entrada de novos backups ou outras atividades ocorridas entre as medições. Evite atribuir todas as alterações de capacidade ao cleaning sem considerar atividades simultâneas.

## Estrutura do repositório

```text
networker-datadomain-space-reclamation/
├── README.md
├── README.pt-BR.md
├── CHANGELOG.md
└── docs/
    ├── original-post.md
    ├── references.md
    └── images/
        ├── 01-networker-show-save-sets.jpg
        ├── 02-networker-ssid-selection.jpg
        ├── 03-command-preparation.jpg
        ├── 04-networker-cli.jpg
        └── 05-datadomain-cleaning.jpg
```

Os caminhos das imagens acima são sugestões de nomes de arquivos. Adicione as capturas revisadas e sanitizadas nesses locais antes de inserir links para as imagens.

Antes da publicação, remova ou oculte identificadores internos, incluindo nomes de hosts, endereços, informações de clientes e nomes de componentes da infraestrutura.

## Referências

### Discussão original na Dell Community

[How to free space on Data Domain for already-deleted save sets from NetWorker database — contribuição original de RodrickNunes](https://www.dell.com/community/en/conversations/networker/how-to-free-space-on-data-domain-for-allready-deleted-save-sets-from-networker-database/647f6ef4f4ccf8a8dec565d6?commentId=647f8e4df4ccf8a8def23366)

### Artigos relacionados da base de conhecimento da Dell

Os artigos abaixo são fornecidos para consulta complementar. Sua inclusão não significa que todas as etapas deste procedimento histórico sejam aplicáveis a todos os cenários descritos nesses artigos.

- [Dell KB 000054303 — Data Domain: como resolver o alto consumo de espaço ou a baixa capacidade disponível](https://www.dell.com/support/kbdoc/pt-br/000054303/data-domain-como-resolver-o-alto-consumo-de-espa%C3%A7o-ou-a-baixa-capacidade-dispon%C3%ADvel)
- [Dell KB 000015007 — Data Domain: Cleaning Not Recovering Disk Space](https://www.dell.com/support/kbdoc/en-us/000015007/71716-cleaning-not-recovering-disk-space)
- [Dell KB 000346279 — Data Domain: Zero Available Space in File System (/data)](https://www.dell.com/support/kbdoc/en-us/000346279/data-domain-0-available-space-in-file-system-data)

Consulte a documentação atual do fabricante antes de aplicar o procedimento a outro ambiente.

## Autor e publicação original

- Autor: Rodrigo N. S. Fernandes
- Nome de usuário na Dell Community: RodrickNunes
- Data da publicação original: 28 de novembro de 2020
- Plataforma original: Dell Community

Este repositório organiza a contribuição original em um documento técnico reutilizável, distinguindo as evidências históricas das recomendações para novas execuções.

Os nomes NetWorker, Data Domain e Dell são utilizados para identificação dos produtos. Este projeto é independente e não possui afiliação ou endosso da Dell Technologies.
