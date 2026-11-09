# References

Fontes relacionadas ao procedimento histórico de recuperação de espaço com NetWorker e Data Domain.

Esta lista separa a publicação original dos artigos complementares do fabricante. A inclusão de uma referência não significa que ela valide integralmente o procedimento ou que suas orientações sejam aplicáveis a todas as versões e ambientes.

## 1. Publicação original

### Dell Community — contribuição de RodrickNunes

- Título da discussão: How to free space on Data Domain for allready deleted save sets from NetWorker database
- Autor da contribuição documentada: Rodrigo N. S. Fernandes
- Nome de usuário: RodrickNunes
- Data exibida na publicação: 28 de novembro de 2020, às 04:00
- [Acessar o comentário original](https://www.dell.com/community/en/conversations/networker/how-to-free-space-on-data-domain-for-allready-deleted-save-sets-from-networker-database/647f6ef4f4ccf8a8dec565d6?commentId=647f8e4df4ccf8a8def23366)
- [Consultar a transcrição preservada neste repositório](original-post.md)

Essa contribuição é a fonte histórica do procedimento documentado neste repositório. Ela apresenta a seleção dos SSIDs, a preparação dos comandos no Excel, a execução dos comandos no NetWorker e o início do cleaning no Data Domain.

Embora o título da discussão mencione save sets já excluídos, a contribuição documentada começa pela seleção de save sets ainda visíveis no NetWorker.

## 2. Artigos da base de conhecimento da Dell

### KB 000054303 — Alto consumo de espaço ou baixa capacidade disponível

- Produto: Data Domain
- Idioma do link: português do Brasil
- [Acessar o artigo na Dell](https://www.dell.com/support/kbdoc/pt-br/000054303/data-domain-como-resolver-o-alto-consumo-de-espa%C3%A7o-ou-a-baixa-capacidade-dispon%C3%ADvel)

Referência complementar para consulta sobre alto consumo de espaço ou baixa capacidade disponível no Data Domain.

### KB 000015007 — Cleaning Not Recovering Disk Space

- Produto: Data Domain
- Idioma do link: inglês
- [Acessar o artigo na Dell](https://www.dell.com/support/kbdoc/en-us/000015007/71716-cleaning-not-recovering-disk-space)

Referência complementar para consulta quando o cleaning não recupera o espaço esperado.

### KB 000346279 — Zero Available Space in File System (/data)

- Produto: Data Domain
- Idioma do link: inglês
- [Acessar o artigo na Dell](https://www.dell.com/support/kbdoc/en-us/000346279/data-domain-0-available-space-in-file-system-data)

Referência complementar para o cenário de ausência de espaço disponível no sistema de arquivos `/data`.

Esse cenário deve ser distinguido do exemplo histórico deste repositório, cuja captura de tela mostra 25% de utilização e espaço disponível no Data Domain.

## 3. Documentação do repositório

| Documento | Finalidade |
|---|---|
| [README em inglês](../README.md) | Apresentação, avisos de segurança, procedimento e limitações. |
| [README em português](../README.pt-BR.md) | Versão em português da documentação principal. |
| [Publicação original](original-post.md) | Transcrição do procedimento histórico e contextualização das evidências. |
| [Changelog](../CHANGELOG.md) | Registro das alterações na documentação. |

## 4. Critérios de uso das referências

Antes de aplicar qualquer orientação:

1. Consulte a versão atual do artigo no site do fabricante.
2. Verifique a aplicabilidade às versões instaladas do NetWorker e do DD OS.
3. Diferencie o procedimento histórico dos cenários específicos tratados em cada KB.
4. Revise os impactos sobre retenção, recuperação e operações em andamento.
5. Obtenha as autorizações necessárias antes de executar comandos destrutivos.
6. Procure o suporte do fabricante quando o cenário exigir diagnóstico específico.

As capturas de tela originais demonstram a sequência de comandos e o início do cleaning. Elas não comprovam sua conclusão nem a quantidade final de espaço recuperado.

## 5. Autoria e atribuição

A contribuição original na Dell Community foi publicada por Rodrigo N. S. Fernandes, sob o nome de usuário RodrickNunes.

Os artigos da base de conhecimento são referenciados como materiais da Dell. Este repositório não reivindica autoria sobre esses artigos e não os reproduz integralmente.

A disponibilização desses links não implica afiliação, certificação ou endosso da Dell Technologies.
