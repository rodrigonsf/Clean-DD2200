# Changelog

Registro das alterações na documentação deste repositório.

A data da publicação original na Dell Community é preservada como referência histórica e não representa a data de criação deste repositório.

## [Não lançado]

### Adicionado

- README.md com a documentação do procedimento em inglês.
- README.pt-BR.md com a documentação do procedimento em português.
- Descrição da sequência registrada no post original:
  - Seleção dos save sets no NetWorker.
  - Obtenção dos SSIDs e preparação dos comandos em uma planilha.
  - Execução dos comandos `nsrmm -d -S <SSID> -y`.
  - Execução de `nsrim -X`.
  - Consulta de espaço com `filesys show space` no Data Domain.
  - Início do cleaning com `filesys clean start`.
  - Acompanhamento com `filesys clean watch`.
- Avisos sobre os riscos de exclusão de backups e a necessidade de autorização e revisão prévia.
- Identificação das versões exibidas nas capturas de tela originais:
  - NetWorker Administration 19.1.0.2, Build 74.
  - Data Domain OS 6.0.2.30-606339.
- Registro dos valores de utilização e espaço apresentados no exemplo histórico.
- Referências à publicação original e aos artigos relacionados da base de conhecimento da Dell.
- Orientações para registrar medições antes e depois de novas execuções.
- Proposta de organização dos documentos e das capturas de tela no repositório.

### Esclarecido

- O procedimento documentado começa pela seleção de save sets ainda visíveis no NetWorker, apesar de o título da discussão original mencionar save sets já excluídos.
- O exemplo histórico mostra o Data Domain com 25% de utilização e não constitui um procedimento testado para um sistema de arquivos sem espaço disponível.
- O valor de 136,1 GiB em `Cleanable GiB` é uma estimativa exibida antes do cleaning, não uma comprovação do espaço efetivamente recuperado.
- As capturas de tela registram o início do cleaning, mas não sua conclusão ou uma medição posterior de espaço.
- As versões históricas não representam uma declaração de compatibilidade com outras versões.
- A documentação é uma contribuição independente e não substitui as orientações oficiais do fabricante.

## Histórico anterior ao repositório

### 2020-11-28 — Publicação original na Dell Community

- Publicação do procedimento por Rodrigo N. S. Fernandes, com o nome de usuário RodrickNunes.
- Apresentação do passo a passo com capturas de tela do NetWorker, da preparação dos comandos no Excel e das sessões SSH.
- Registro da sequência de comandos no NetWorker e do início do cleaning no Data Domain.

Essa publicação é a origem do material documentado neste repositório, não uma versão de software ou um release do projeto.
