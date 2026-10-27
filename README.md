# contaviral

## O que é

O contaviral faz, sozinho, vídeos curtos (9:16) com o resumo do que os 10 maiores canais de contabilidade e tributos do YouTube disseram: novas leis e portarias, Reforma Tributária (IBS, CBS, Imposto Seletivo) e o impacto nas empresas, MEI e Simples Nacional, imposto de renda, obrigações fiscais (SPED, notas), IA nos escritórios e oportunidades para contadores. Ele assiste aos vídeos por transcrição, separa os números e os fatos com a fonte de cada um e monta um vídeo com números grandes, carimbos (MUDOU A REGRA, PROPOSTA, PRAZO, ALERTA) e o Nei comentando (avatar). Proposta é tratada como proposta, política não tem lado e nada vira conselho: não substitui orientação de um contador. Roda num computador com GPU, com a assinatura do Claude Code e do HeyGen. É irmão do [futviral](https://github.com/inematds/futviral), do [advviral](https://github.com/inematds/advviral), do [saudeviral](https://github.com/inematds/saudeviral) e do [finviral](https://github.com/inematds/finviral) (mesmo motor, outro tema).

## Os 10 canais

Escolhidos em 27/10/2026 por medição própria (yt-dlp, mediana de views dos últimos 15 vídeos, canal ativo e falado), a partir da lista do Nei. Detalhes em [`pesquisa/canais.md`](pesquisa/canais.md); lista viva em `canais.json`.

Central do Microempreendedor · Sua Contadora · Flávia Holanda Gaeta · Gerando Empreendedores · Tenha Renda · Econet Editora · Receita Federal · Contabilidade Facilitada · Fellipe Guerra · Paulo Henrique Pêgas (IPECRJ TV).

## O processo, do início ao fim

| # | Passo | Comando | Quem faz |
|---|---|---|---|
| 1 | Lista os vídeos dos canais do período (só metadados) | `coleta/listar.py` (chamado pelo `auto/rodar.sh`) | ⚙️ script |
| 2 | Escolhe 1 vídeo por canal (o mais visto), sem repetir vídeo já usado | `auto/rodar.sh` + `auto/usados.py` | ⚙️ script |
| 3 | Pega a legenda do YouTube; se não houver, baixa o áudio e transcreve local (inemavox, Whisper large-v3) | `coleta/transcrever.sh` + `coleta/legenda_yt.py` | ⚙️ script |
| 4 | Escreve `base.md` (fato + trecho literal), `roteiro.json` e `legenda.txt` | `claude -p` com `auto/roteiro.md` | 🤖 `claude -p` |
| 5 | Confere trechos, números por extenso, 5+ assuntos e o aviso "Não substitui orientação de um contador"; 1 correção | `auto/checar.py` | ⚙️ script |
| 6 | Avatar do Nei no estúdio HeyGen (assinatura); se falhar, foto + voz do Nei | `motor/avatar_heygen.sh` / `motor/narrar.py` | ⚙️ script |
| 7 | Renderiza o vídeo (palco.html quadro a quadro) e compõe o avatar | `motor/gerar_cena.py` + `motor/compor_avatar.sh` | ⚙️ script |
| 8 | Geração às 10h: o vídeo vai ao bot como prévia. Às 13h publica no YouTube **INEMA TIA (lives2)** e manda o link ao bot (`touch <edição>/SEGURAR` segura) | `auto/publicar.sh` + `auto/publicar-pendente.sh` (yt-pubx) | ⚙️ timer 10:00 / 13:00 |
| 9 | Sáb/dom: longo 16:9 "A semana explicada" | `auto/roteiro-longo.md` → `auto/longo.sh` | 🤖 + ⚙️ |
| 10 | Aprovar o formato, incluir/tirar canais, ligar a agenda | `canais.json`, `systemd/` | 🧠 sessão com o Nei |

Rodada à mão (sempre por `systemd-run --user`, com `PATH` incluindo `~/.npm-global/bin` e `DISPLAY=:99`, como em `systemd/*.service`):

```bash
auto/rodar.sh diario 2026-10-27                   # rodada completa (avatar + lives2 + bot)
SEM_AVATAR=1 auto/rodar.sh diario 2026-10-27      # versão com foto, só para o bot (não marca usados)
REUSAR_ROTEIRO=1 auto/rodar.sh diario 2026-10-27  # refaz avatar/vídeo/publicação com o roteiro já aprovado
```

Agenda (`systemd/contaviral-*.timer`): geração às 10:00 (diário seg–sex, semanal no sábado, domingo no domingo) e publicação às 13:00. Instalar: `cp systemd/contaviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload && systemctl --user enable --now contaviral-diario.timer contaviral-semanal.timer contaviral-domingo.timer contaviral-publicar.timer`.

## Regras de cada vídeo

- Todo fato tem a fonte (canal, data, título) na tela e um trecho literal da transcrição no `base.md`.
- Tudo atribuído a quem disse; nada de "faça X" para o seu caso: cada caso é um caso, fale com o seu contador.
- Lei, instrução normativa, portaria, alíquota, prazo e valor só como estão na fala do influenciador.
- Proposta, projeto ou regulamentação pendente não é regra em vigor (carimbo PROPOSTA).
- Política sem lado; propaganda do influenciador (curso, mentoria, escritório) não entra; "pague menos imposto" não vira manchete.
- Fala no tom do Nei, tratando por "você", com números por extenso. Fim: pergunta para comentar e CTA do inema.club.
- HeyGen só pelo estúdio da assinatura. A oferta de troca de plano é sempre recusada.

## Licença

MIT.
