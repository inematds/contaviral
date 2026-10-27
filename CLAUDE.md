# CLAUDE.md — contaviral

Conta/autor: `inematds <inematds@gmail.com>`, repo `inematds/contaviral`. Fluxo e agenda: README.md. Base de cada edição: `edicoes/<ed>/base.md`. Projetos irmãos (mesmo motor): `~/projetos/futviral` (de onde foi clonado), `~/projetos/advviral`, `~/projetos/saudeviral` e `~/projetos/finviral`.

- Criado em 27/10/2026 a pedido do Nei: "quero que crie outro projeto sobre [contabilidade] … e será colocado também no lives2 … publica no portal". Ele colou uma lista de 10 nomes (Fellipe Guerra, Bernard Appy, Paulo Henrique Pêgas, Eurico de Santi, Conrado Viana, Guga Ribeiro, Marcos Rebello, Charles Gularte, Leandro Ardito, Bruno Salotti); conferida com yt-dlp em `pesquisa/canais.md`: só Fellipe Guerra e Pêgas (IPECRJ TV) têm canal ativo, o resto foi completado pelos maiores canais ativos de contabilidade, tributos e MEI.
- Assuntos-alvo (Nei): novas leis e portarias, Reforma Tributária e o impacto nas empresas, sistemas fiscais (SPED, notas, obrigações), IA e automação nos escritórios, oportunidades de serviços.
- Canal: **INEMA TIA (lives2)**, por `auto/publicar.sh` (yt-pubx), e SEMPRE ao bot v3 com o link. A versão com foto (avatar falhou ou teste `SEM_AVATAR=1`) só vai ao bot e não marca vídeos como usados. O lives2 já recebe finviral (02h), saudeviral (05h) e advviral (08h).
- Influenciadores em `canais.json` (só YouTube, todos em português). O Nei inclui/exclui. Eu posso SUGERIR canal consolidado (nunca emergente, nunca quem vende curso como conteúdo principal ou "pague menos imposto"); só entra com ok dele.
- Regras do contábil (no roteiro e no `checar.py`): todo fato tem trecho literal no base.md; tudo atribuído; nada de "faça X" para o caso de quem assiste ("cada caso é um caso: fale com o seu contador"); lei, IN, portaria, alíquota, prazo e valor só como estão no transcript; proposta/projeto/regulamentação pendente NÃO é regra em vigor; política sem lado; propaganda do influenciador fora; "Não substitui orientação de um contador." obrigatório (o portão reprova sem).
- Agenda: GERAÇÃO às 10:00 (diário seg–sex, semanal sáb, domingo dom; `PUBLICAR_AS=13:00` no serviço) → o vídeo vai ao bot como PRÉVIA e fica `<ed>/PUBLICAR_PENDENTE.*`; PUBLICAÇÃO às 13:00 (`contaviral-publicar.timer` → `auto/publicar-pendente.sh`). `touch <ed>/SEGURAR` impede a publicação. Se o vídeo ficar pronto DEPOIS das 13:00 (a trava do estúdio HeyGen é compartilhada com futviral/finviral etc.), ele continua pendente e sai no timer das 13:00 do dia seguinte; para soltar antes, rode `auto/publicar-pendente.sh`.
- Transcrição: legenda do YouTube primeiro (`coleta/transcrever.sh` + `coleta/legenda_yt.py`, uma língua por pedido — várias seguidas dão 429), Whisper local só se não houver legenda. `<tx>/<id>/fonte` diz qual foi usada. TX: `~/projetos/output/contaviral/coleta/tx`.
- Avatar: HeyGen pelo ESTÚDIO (assinatura, `motor/avatar_heygen.sh`, trava compartilhada). Títulos `CONTAVIRAL-…`. Oferta de troca de plano do HeyGen: SEMPRE recusar.
- Referência de formato: `edicoes/referencia/` é do finviral (projeto irmão); trocar por uma edição do contaviral aprovada pelo Nei.

## Self-learning

When I correct you, or you catch yourself making a mistake: before continuing, add the lesson as a one-line rule under ## Lessons, so it never happens again.

## Lessons

- (Herdadas do futviral/advviral/finviral, mesmo motor.) Tratar por "você"; CTA só inema.club; números por extenso na fala; âncora `em` em palavra comum; citação literal do transcript; cadeia longa por `systemd-run --user`; não editar .sh com rodada em execução (editar cópia e trocar com `mv`); voz do HeyGen mixada a -14 LUFS.
- Sigla falada no roteiro ("cê bê ésse") precisa de equivalência nos dois lugares: `motor/narrar.py` (`_SIGLAS`, conferência da voz contra o Whisper) e `motor/gerar_cena.py` (`TELA`, legenda escrita). Sigla nova no roteiro → acrescentar nos dois. (27/10/2026)
