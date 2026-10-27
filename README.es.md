# contaviral

[![contaviral — radar contable](guia/assets/banner-es.jpg)](https://inematds.github.io/contaviral/guia/es/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## Qué es

contaviral hace, solo, videos cortos (9:16) con el resumen de lo que dijeron los 10 mayores canales brasileños de contabilidad e impuestos de YouTube: nuevas leyes y ordenanzas, la Reforma Tributaria brasileña (IBS y CBS, los nuevos impuestos sobre el consumo, e Imposto Seletivo, el impuesto selectivo) y su impacto en las empresas, MEI (régimen brasileño de microemprendedor individual) y Simples Nacional (régimen tributario simplificado para pequeñas empresas), impuesto sobre la renta, obligaciones fiscales (SPED, facturas), IA en los despachos contables y oportunidades para contadores. Mira los videos a través de la transcripción, separa los números y los hechos con la fuente de cada uno y arma un video con números grandes, sellos (MUDOU A REGRA (cambió la regla), PROPOSTA (propuesta), PRAZO (plazo), ALERTA) y Nei comentando (avatar). Una propuesta se trata como propuesta, la política no tiene bando y nada se convierte en consejo: no sustituye la orientación de un contador. Funciona en una computadora con GPU, con la suscripción de Claude Code y de HeyGen. Es hermano de [futviral](https://github.com/inematds/futviral), de [advviral](https://github.com/inematds/advviral), de [saudeviral](https://github.com/inematds/saudeviral) y de [finviral](https://github.com/inematds/finviral) (mismo motor, otro tema).

## 📖 Guía de uso

Guía completa (landing + paso a paso): **https://inematds.github.io/contaviral/guia/es/**

## Los 10 canales

Elegidos el 27/10/2026 con medición propia (yt-dlp, mediana de vistas de los últimos 15 videos, canal activo y hablado), a partir de la lista de Nei. Detalles en [`pesquisa/canais.md`](pesquisa/canais.md) (en portugués); lista viva en `canais.json`.

Central do Microempreendedor · Sua Contadora · Flávia Holanda Gaeta · Gerando Empreendedores · Tenha Renda · Econet Editora · Receita Federal · Contabilidade Facilitada · Fellipe Guerra · Paulo Henrique Pêgas (IPECRJ TV).

## El proceso, de principio a fin

| # | Paso | Comando | Quién lo hace |
|---|---|---|---|
| 1 | Lista los videos de los canales del período (solo metadatos) | `coleta/listar.py` (llamado por `auto/rodar.sh`) | ⚙️ script |
| 2 | Elige 1 video por canal (el más visto), sin repetir videos ya usados | `auto/rodar.sh` + `auto/usados.py` | ⚙️ script |
| 3 | Toma el subtítulo de YouTube; si no lo hay, descarga el audio y lo transcribe localmente (inemavox, Whisper large-v3) | `coleta/transcrever.sh` + `coleta/legenda_yt.py` | ⚙️ script |
| 4 | Escribe `base.md` (hecho + fragmento literal), `roteiro.json` y `legenda.txt` | `claude -p` con `auto/roteiro.md` | 🤖 `claude -p` |
| 5 | Verifica fragmentos, números escritos en letras, 5+ temas y el aviso "No sustituye la orientación de un contador"; 1 corrección | `auto/checar.py` | ⚙️ script |
| 6 | Avatar de Nei en el estudio HeyGen (suscripción); si falla, foto + voz de Nei | `motor/avatar_heygen.sh` / `motor/narrar.py` | ⚙️ script |
| 7 | Renderiza el video (palco.html cuadro a cuadro) y compone el avatar | `motor/gerar_cena.py` + `motor/compor_avatar.sh` | ⚙️ script |
| 8 | Generación a las 10 h: el video va al bot como vista previa. A las 13 h se publica en YouTube **INEMA TIA (lives2)** y se manda el enlace al bot (`touch <edición>/SEGURAR` lo retiene) | `auto/publicar.sh` + `auto/publicar-pendente.sh` (yt-pubx) | ⚙️ timer 10:00 / 13:00 |
| 9 | Sáb/dom: largo 16:9 "La semana explicada" | `auto/roteiro-longo.md` → `auto/longo.sh` | 🤖 + ⚙️ |
| 10 | Aprobar el formato, incluir/quitar canales, activar la agenda | `canais.json`, `systemd/` | 🧠 sesión con Nei |

Ronda a mano (siempre con `systemd-run --user`, con `PATH` incluyendo `~/.npm-global/bin` y `DISPLAY=:99`, como en `systemd/*.service`):

```bash
auto/rodar.sh diario 2026-10-27                   # ronda completa (avatar + lives2 + bot)
SEM_AVATAR=1 auto/rodar.sh diario 2026-10-27      # versión con foto, solo para el bot (no marca usados)
REUSAR_ROTEIRO=1 auto/rodar.sh diario 2026-10-27  # rehace avatar/video/publicación con el guion ya aprobado
```

Agenda (`systemd/contaviral-*.timer`): generación a las 10:00 (diario lun–vie, semanal el sábado, domingo el domingo) y publicación a las 13:00. Instalar: `cp systemd/contaviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload && systemctl --user enable --now contaviral-diario.timer contaviral-semanal.timer contaviral-domingo.timer contaviral-publicar.timer`.

## Reglas de cada video

- Todo hecho tiene la fuente (canal, fecha, título) en pantalla y un fragmento literal de la transcripción en `base.md`.
- Todo atribuido a quien lo dijo; nada de "haz X" para tu caso: cada caso es distinto, habla con tu contador.
- Ley, instrucción normativa, ordenanza, alícuota, plazo y valor solo tal como están en el habla del influencer.
- Una propuesta, un proyecto o una reglamentación pendiente no es una regla vigente (sello PROPOSTA, propuesta).
- Política sin bando; la publicidad del influencer (curso, mentoría, despacho) no entra; "paga menos impuestos" no se convierte en titular.
- Habla en el tono de Nei, directo al espectador, con los números escritos en letras. Al final: pregunta para comentar y CTA de inema.club.
- HeyGen solo por el estudio de la suscripción. La oferta de cambio de plan siempre se rechaza.

## Licencia

MIT.
