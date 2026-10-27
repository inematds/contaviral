# Tarefa: roteiro do contaviral ({MODO}, {DATA})

Você monta o roteiro de um vídeo 9:16 do **contaviral**: o que os maiores canais de contabilidade e tributos do YouTube (novas leis e portarias, Reforma Tributária e o impacto nas empresas, MEI e Simples Nacional, imposto de renda, sistemas fiscais como SPED, notas e obrigações, IA e automação nos escritórios, oportunidades de serviço para contadores) disseram, com números grandes, fonte na tela, o Nei comentando e CTA do inema.club no fim. Trabalhe só com os arquivos abaixo. Não use a internet nem outra API.

## Entrada
- Pasta da edição: `{ED}`. Escreva nela apenas os arquivos pedidos.
- Vídeos do período: `{ED}/videos.tsv`, com as colunas handle, data, id, duração em segundos, views, canal e título.
- Transcrições: `{TX}/<id>/transcript.txt`. Só existem as dos ids listados em `{ED}/transcritos.txt`.
- Canais e ranking: `{RAIZ}/canais.json`.
- Edição de referência (de um projeto irmão, aprovada pelo Nei). Copie SÓ o formato dela; o assunto é outro:
  - `{RAIZ}/edicoes/referencia/roteiro.json`
  - `{RAIZ}/edicoes/referencia/base.md`
- Esquema do roteiro: docstring de `{RAIZ}/motor/gerar_cena.py`.

## Modo
{INSTRUCAO_MODO}

## Saída
Grave TODOS estes arquivos, ou só o `SEM_PAUTA.txt`.

### 1. `{ED}/base.md`
Uma tabela com as colunas `| Número usado | Quem disse | Vídeo | Data | Trecho da transcrição |`. Regras:
- Uma linha por número ou fato que aparece no vídeo.
- **Vídeo** é o id do YouTube, exatamente como está no videos.tsv.
- **Trecho** fica entre aspas retas `"..."` e é cópia LITERAL de um pedaço contínuo do transcript.txt desse id: de 6 a 30 palavras, sem editar nem juntar pedaços.
- Um script confere cada trecho. Se algum não estiver no transcript, o vídeo é descartado.

### 2. `{ED}/roteiro.json`
Mesmo formato da edição de referência:
- `marca`: "INEMA · RADAR CONTÁBIL".
- `selo`: período, por exemplo "YOUTUBE · 09/10" ou "YOUTUBE · 03 A 08/10".
- `avatar`: `{"img": "img/avatar-teste.jpg", "tag": "<b>NEI MALDANER</b> · INEMA"}`.
- `hero` é o quadro 0. Leva:
  - a data `{DATA_BR}` com o dia da semana;
  - o tema;
  - o número mais forte, em `t2`;
  - uma linha `t3`;
  - um `t4` curto;
  - os rostos (miniaturas `img/<id>.jpg` dos vídeos citados, no máximo cinco).

Regras das `falas`:
- **Abertura (f1):** a frase-choque com o número mais forte. O número já está no `hero`: f1 NÃO leva `numero`, `ficha`, `caixa` nem `carimbo`. Nunca abrir com "Neste vídeo", "Imagine" ou "Olá".
- **Resumo dos dez, com pelo menos CINCO assuntos (Nei, 13/10/2026; vale para todo modo do curto).** O vídeo é o resumo do que os dez influenciadores do `canais.json` publicaram no período: no mínimo cinco assuntos (o mínimo exato vem no Modo), de influenciadores diferentes sempre que der, o mais forte primeiro. Logo depois de f1, uma fala-sumário com `caixa` de `itens` (k "Hoje no radar", ou "Na semana") listando os assuntos que vêm, um item curto por assunto, cada item com `em` numa palavra da fala. Cada assunto tem pelo menos uma linha no base.md com o id do vídeo dele: a conferência conta os vídeos distintos do base.md. Cada assunto continua contado inteiro, em duas ou três falas seguidas (contexto, o que ele disse, o que muda pra quem assiste): cinco assuntos não podem virar cinco fragmentos.
- **Viradas e manchete (Nei, 14/10/2026).** A 1ª fala de cada assunto leva `"assunto": "<NOME CURTO>"` (até 24 letras, ex.: "LIMITE DO MEI", "SPLIT PAYMENT"): o vídeo abre 1 s de cartão de virada ("ASSUNTO 2 DE 5") antes dela, e outro antes da pergunta. A fala-sumário leva `"manchete": "HOJE NO RADAR"` (ou "NA SEMANA"). Cada assunto marcado precisa de pelo menos duas falas. A conferência conta as marcas de `assunto`.
- **Explicar, não listar (o Nei reprovou o semanal de 10/10/2026: seis assuntos em fragmentos, "assunto muito mal explicado").** Cada assunto contado inteiro, em três passos e em falas seguidas:
  1. **contexto**: o que é a coisa e por que alguém se importa (ex.: "o Simples Nacional é o regime de imposto das pequenas empresas, que junta vários tributos numa guia só");
  2. **o que ELE disse**: o número ou o argumento, atribuído;
  3. **o que isso muda pra quem assiste**: a consequência, em linguagem de gente ("ou seja: quem é méi e faturou acima do limite precisa olhar isso com o contador").
  - Todo termo técnico é explicado na própria fala na primeira vez em que aparece: í bê ésse, cê bê ésse, split payment, crédito tributário, lucro presumido, ispédi. Se não der pra explicar em meia frase, corte.
  - Nada solto: número sem dizer o que significa, polêmica sem contar o que foi dito e a quem, dado que não se liga ao assunto. Cada fala continua a anterior; quem só ouve tem que entender sem ver a tela.
  - Cumprido o mínimo de assuntos, na dúvida entre mais um e explicar melhor os que já entraram, explique melhor.
- **Uma ideia por fala.** Cada influenciador citado ganha `ficha` (nome, canal com "dd/mm · N mil views", `rk` do canais.json, foto `img/<id>.jpg`) e `fundo` `img/<id>.jpg`.
- **Números:**
  - Usar `numero` (contador grande), `grafico` (só se houver série real dita no vídeo), `caixa` com citação literal ou itens, e `carimbo` ("MUDOU A REGRA", "PROPOSTA", "PRAZO", "ALERTA", "POLÊMICA", "DEPENDE DO CASO") quando couber.
  - Todo número mostrado está no base.md.
- **`fonte`:** "<b>Fonte:</b> Canal, YouTube, dd/mm/aaaa · “título curto”".
- **Texto falado (`fala`), no tom do Nei:**
  - Tratar por "você" (nunca "tu", "teu", "te prepara"; o Nei pediu em 10/10/2026), frases curtas.
  - Escrever TODOS os números e anos por extenso, sem algarismo: "sete vírgula sete por cento", "dois mil e vinte e oito".
  - Siglas lidas como se fala ("í bê ésse" para IBS, "cê bê ésse" para CBS, "méi" para MEI, "ispédi" para SPED, "imposto de renda" para IR, "cê ene pê jota" para CNPJ). Endereço do governo se fala sem "ponto": "gov bê érre". Na tela (`caixa`, `fonte`) continua a sigla escrita. O CTA "inema ponto club" não muda. Sem emoji.
- **`em` (âncora):** uma palavra comum que está na fala, nunca um número.
- **Penúltima fala:** gancho de comentário. É uma pergunta que chama a pessoa a contar onde ela está e como é aí (Nei, 13/10/2026): "Você é contador ou empresário? Como isso afeta você? Comente aqui" (adapte ao tema: de onde você está assistindo, como está o seu escritório, se o seu negócio já sentiu a mudança), com `"limpa": true`. A `fonte` dela é "<b>Não substitui orientação de um contador.</b> Resumo do que os influenciadores disseram, com a fonte de cada fato".
- **Última fala:** CTA com `fundo` "img/cta.jpg" e `"limpa": true`.
  - Fala: uma ponte curta do tema para a IA, mais "Você pode aprender isso no inema ponto club, com cursos gratuitos." (Nei, 13/10/2026: o CTA diz que dá pra APRENDER no inema.club)
  - O CTA é SEMPRE só o inema.club: não citar canal do YouTube, INEMA TIA, Inema Pro, "vídeo longo", "se inscreva" nem outro destino.
  - `hero` igual ao da referência (GESTÃO DE / AGENTES DE IA / img/cta.jpg).
  - `caixa` tipo cta com "INEMA.CLUB".
- **Contabilidade e tributos (regras duras):**
  - Relatar e atribuir sempre ("segundo ela", "o Fellipe Guerra explica"). Nunca vira conselho do Nei.
  - Nada de "faça X" como instrução contábil ou tributária para o caso de quem assiste: imposto depende do caso (regime, faturamento, atividade, estado). Quando a fala disser o que alguém pode fazer, fechar com "cada caso é um caso: fale com o seu contador".
  - Lei, lei complementar, instrução normativa, portaria, resolução, alíquota, prazo, limite e valor só entram se estiverem no transcript, iguais ao que ele disse; nunca completar de memória.
  - **Proposta não é regra.** Projeto de lei, proposta, "aprovado mas falta sancionar" ou regulamentação pendente NÃO é regra em vigor: a fala diz que é proposta (carimbo "PROPOSTA") e quando entra, só se ele disse. "MUDOU A REGRA" só quando ele disse que já está valendo.
  - **Reforma Tributária** (í bê ésse, cê bê ésse, Imposto Seletivo, transição, split payment): só o que ele disse, com o ano que ele disse. Não explique de memória o cronograma da transição.
  - "Pague menos imposto", atalho para não pagar o que é devido, "dinheiro esquecido" sem fonte ou promessa de restituição NÃO vira manchete. Na dúvida, fica de fora.
  - Política (eleição, governo, Congresso, Receita): atribuída, sem lado, sem opinião do Nei.
  - Propaganda do influenciador (curso, mentoria, escritório, sistema, "chame no WhatsApp") não entra.
  - A Receita Federal é fonte oficial: o que ela publica é atribuído a ela ("segundo a Receita Federal").

### 3. `{ED}/legenda.txt`
Até 6 linhas para o Nei aprovar no Telegram:
- linha 1: título sugerido para o YouTube, até 70 caracteres, com gancho;
- linhas 2 a 4: os números principais com quem disse;
- linha 5: "Não substitui orientação de um contador."

### 4. `{ED}/sugestao.txt` (opcional)
Se, nos títulos ou transcrições, outro canal de contabilidade ou tributos CONSOLIDADO e confiável aparecer em destaque, escreva uma linha com nome, canal e motivo. Consolidado quer dizer contador com CRC, professor de contabilidade ou de direito tributário, ou instituição reconhecida, com anos de canal e grande audiência; nunca emergente, nunca quem vende curso como conteúdo principal ou promete "pagar menos imposto". É só sugestão: não inclua essa pessoa no vídeo.

### Sem pauta
Se não houver nada relevante (nenhum número ou fato forte, só repetição ou conteúdo publicitário), grave apenas `{ED}/SEM_PAUTA.txt` com uma linha explicando o motivo. Melhor não publicar do que publicar morno.
