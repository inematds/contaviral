# contaviral

[![contaviral — accounting radar](guia/assets/banner-en.jpg)](https://inematds.github.io/contaviral/guia/en/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## What it is

contaviral makes, on its own, short videos (9:16) summing up what the 10 biggest accounting and tax channels on YouTube said: new laws and ordinances, Brazil's Tax Reform (IBS, CBS and the Imposto Seletivo — the new consumption taxes and the selective excise tax) and its impact on companies, MEI (Brazil's individual micro-entrepreneur regime) and Simples Nacional (the simplified tax regime for small businesses), income tax, tax obligations (SPED, invoices), AI in accounting firms and opportunities for accountants. It watches the videos through their transcripts, pulls out the numbers and facts with the source of each one, and builds a video with big numbers, stamps (MUDOU A REGRA, PROPOSTA, PRAZO, ALERTA — rule changed, proposal, deadline, alert) and Nei commenting (avatar). A proposal is treated as a proposal, politics takes no side and nothing becomes advice: it does not replace guidance from an accountant. It runs on a computer with a GPU, using the Claude Code and HeyGen subscriptions. It is a sibling of [futviral](https://github.com/inematds/futviral), [advviral](https://github.com/inematds/advviral), [saudeviral](https://github.com/inematds/saudeviral) and [finviral](https://github.com/inematds/finviral) (same engine, different topic).

## 📖 User guide

Full guide (landing + step by step): **https://inematds.github.io/contaviral/guia/en/**

## The 10 channels

Chosen on 10/27/2026 by our own measurement (yt-dlp, median views of the last 15 videos, active channel with spoken content), from Nei's list. Details in [`pesquisa/canais.md`](pesquisa/canais.md) (in Portuguese); live list in `canais.json`.

Central do Microempreendedor · Sua Contadora · Flávia Holanda Gaeta · Gerando Empreendedores · Tenha Renda · Econet Editora · Receita Federal · Contabilidade Facilitada · Fellipe Guerra · Paulo Henrique Pêgas (IPECRJ TV).

## The process, start to finish

| # | Step | Command | Who does it |
|---|---|---|---|
| 1 | Lists the channels' videos for the period (metadata only) | `coleta/listar.py` (called by `auto/rodar.sh`) | ⚙️ script |
| 2 | Picks 1 video per channel (the most viewed), never repeating a video already used | `auto/rodar.sh` + `auto/usados.py` | ⚙️ script |
| 3 | Takes the YouTube caption; if there isn't one, downloads the audio and transcribes locally (inemavox, Whisper large-v3) | `coleta/transcrever.sh` + `coleta/legenda_yt.py` | ⚙️ script |
| 4 | Writes `base.md` (fact + literal excerpt), `roteiro.json` and `legenda.txt` | `claude -p` with `auto/roteiro.md` | 🤖 `claude -p` |
| 5 | Checks excerpts, numbers spelled out, 5+ topics and the notice "Não substitui orientação de um contador" (It does not replace guidance from an accountant); 1 correction | `auto/checar.py` | ⚙️ script |
| 6 | Nei's avatar in the HeyGen studio (subscription); if it fails, Nei's photo + voice | `motor/avatar_heygen.sh` / `motor/narrar.py` | ⚙️ script |
| 7 | Renders the video (palco.html frame by frame) and composites the avatar | `motor/gerar_cena.py` + `motor/compor_avatar.sh` | ⚙️ script |
| 8 | Generation at 10 am: the video goes to the bot as a preview. At 1 pm it publishes to YouTube **INEMA TIA (lives2)** and sends the link to the bot (`touch <edition>/SEGURAR` holds it) | `auto/publicar.sh` + `auto/publicar-pendente.sh` (yt-pubx) | ⚙️ timer 10:00 / 13:00 |
| 9 | Sat/Sun: long 16:9 "A semana explicada" (The week explained) | `auto/roteiro-longo.md` → `auto/longo.sh` | 🤖 + ⚙️ |
| 10 | Approve the format, add/remove channels, turn on the schedule | `canais.json`, `systemd/` | 🧠 session with Nei |

Run by hand (always through `systemd-run --user`, with `PATH` including `~/.npm-global/bin` and `DISPLAY=:99`, as in `systemd/*.service`):

```bash
auto/rodar.sh diario 2026-10-27                   # full run (avatar + lives2 + bot)
SEM_AVATAR=1 auto/rodar.sh diario 2026-10-27      # photo version, bot only (doesn't mark videos as used)
REUSAR_ROTEIRO=1 auto/rodar.sh diario 2026-10-27  # redo avatar/video/publishing with the script already approved
```

Schedule (`systemd/contaviral-*.timer`): generation at 10:00 (diario Mon–Fri, semanal on Saturday, domingo on Sunday) and publishing at 13:00. Install: `cp systemd/contaviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload && systemctl --user enable --now contaviral-diario.timer contaviral-semanal.timer contaviral-domingo.timer contaviral-publicar.timer`.

## Rules for every video

- Every fact has its source (channel, date, title) on screen and a literal excerpt from the transcript in `base.md`.
- Everything is attributed to whoever said it; no "do X" for your case: every case is different, talk to your accountant.
- Laws, normative instructions, ordinances, tax rates, deadlines and amounts only as they appear in the influencer's speech.
- A proposal, bill or pending regulation is not a rule in force (PROPOSTA stamp — proposal).
- Politics without sides; the influencer's advertising (course, mentoring, accounting firm) doesn't go in; "pay less tax" never becomes a headline.
- Spoken in Nei's tone, addressing the viewer as "você", with numbers spelled out in words. At the end: a question to comment on and the inema.club CTA.
- HeyGen only through the subscription studio. The plan-change offer is always declined.

## License

MIT.
