#!/usr/bin/env bash
# Publica um vídeo do contaviral no YouTube INEMA TIA (lives2) pelo yt-pubx e manda SEMPRE ao bot v3 (com o link).
# uso: auto/publicar.sh <video.mp4> <pasta-da-edicao> <rotulo> [extra-da-legenda]
#   título = 1ª linha de <ed>/legenda.txt (curto vertical recebe #Shorts e sai sem thumb; o longo ganha thumb do Codex).
#   SEM_YT=1 só manda ao bot; SEM_BOT=1 simula o envio ao bot (teste).
# Autorizado pelo Nei (finviral, 10/10/2026; contaviral, 27/10/2026: "será colocado também no lives2"): "pode sempre criar direto com o avatar … publicar … e sempre manda para o bot também".
set -uo pipefail
# systemd não tem ~/.npm-global/bin no PATH e pegava o codex velho de /usr/bin (0.116), que não lê o config.toml do novo (10/10/2026)
export PATH="$HOME/.npm-global/bin:$PATH"
V="$1"; E="$(cd "$2" && pwd)"; ROT="$3"; EXTRA="${4:-}"
PL="$E/publicar-$(printf %s "$ROT" | tr -c 'A-Za-z0-9-' _).log"  # o rótulo traz a data dd/mm/aaaa: barra no nome quebrava o log (10/10/2026)
BOT="$HOME/projetos/refazvideo/ferramentas/enviar_bot_v3.mjs"
DRY=""; [ "${SEM_BOT:-}" = 1 ] && DRY=--dry-run
# Publicação adiada (futviral, Nei 26/10/2026; contaviral: geração 10:00, publicação 13:00).
# Com PUBLICAR_AS=HH:MM (vem do serviço), o vídeo pronto vai ao bot como PRÉVIA e fica pendente;
# o auto/publicar-pendente.sh (timer das 13:00) publica no lives2. Ficou pronto depois das 13:00? Continua pendente e sai no timer do dia seguinte (ou rode auto/publicar-pendente.sh). Para segurar: crie <ed>/SEGURAR.
if { [ -n "${PUBLICAR_AS:-}" ] || [ -e "$E/SEGURAR" ]; } && [ "${SEM_YT:-}" != 1 ] && [ -z "${PUBLICANDO_PENDENTE:-}" ]; then
  QUANDO="às ${PUBLICAR_AS:-13:00}"; [ -e "$E/SEGURAR" ] && QUANDO="só quando o Nei liberar (rm $E/SEGURAR e rodar auto/publicar-pendente.sh)"
  printf '%s\n%s\n%s\n' "$V" "$ROT" "$EXTRA" > "$E/PUBLICAR_PENDENTE.$(basename "$V" .mp4)"
  VP="$V"; if [ "$(stat -c %s "$V")" -gt 48000000 ]; then VP="${V%.mp4}-720p.mp4"
    ffmpeg -v error -y -i "$V" -vf "scale=-2:720" -c:v libx264 -crf 27 -preset medium -c:a aac -b:a 128k -movflags +faststart "$VP"; fi
  rm -f "$VP.envio-v3.json"
  node "$BOT" $DRY "$VP" "contaviral · PRÉVIA · $ROT
Vai ao ar $QUANDO no lives2 (INEMA TIA). Para segurar: touch $E/SEGURAR
$(head -c 500 "$E/legenda.txt")$EXTRA" || echo "falhou o envio da prévia"
  echo "pendente: publica $QUANDO"; exit 0
fi
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$V" | cut -d. -f1)
W=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$V")
TIT=$(head -1 "$E/legenda.txt" | cut -c1-90)
[ "$W" -lt 1000 ] && TIT="$TIT #Shorts"
URL=""
if [ "${SEM_YT:-}" != 1 ]; then
  CTX="contaviral (INEMA TIA): resumo do que os maiores canais de contabilidade e tributos do YouTube disseram (novas leis e portarias, Reforma Tributária, MEI e Simples Nacional, imposto de renda, obrigações fiscais, IA nos escritórios), com a fonte de cada fato na tela e o Nei Maldaner comentando. Proposta não é regra em vigor. Não substitui orientação de um contador. Curso gratuito de gestão de agentes de IA em https://inema.club. Não cite outros canais na descrição além dos influenciadores do vídeo."
  timeout 2400 "$HOME/projetos/yt-pubx/yt-pubx" publicar "$V" --canal lives2 --title "$TIT" --contexto "$CTX" \
      --contexto-arquivo "$E/legenda.txt" > "$PL" 2>&1
  URL=$(grep -o 'https://www.youtube.com/watch?v=[A-Za-z0-9_-]*\|https://youtu.be/[A-Za-z0-9_-]*' "$PL" | tail -1)
fi
if [ -n "$URL" ]; then ST="publicado no INEMA TIA (lives2): $URL"
elif [ "${SEM_YT:-}" = 1 ]; then ST="(sem YouTube nesta rodada)"
else ST="⚠ NÃO publicou no lives2: $(grep -h -i 'erro\|error\|quota\|limit' "$PL" | tail -1 | cut -c1-200)"; fi
VB="$V"  # bot aceita até ~49 MB: acima disso vai uma cópia 720p (o YouTube recebe o original)
if [ "$(stat -c %s "$V")" -gt 48000000 ]; then
  VB="${V%.mp4}-720p.mp4"
  ffmpeg -v error -y -i "$V" -vf "scale=-2:720" -c:v libx264 -crf 27 -preset medium -c:a aac -b:a 128k -movflags +faststart "$VB"
fi
rm -f "$VB.envio-v3.json"
node "$BOT" $DRY "$VB" "contaviral · $ROT · ${DUR}s
$ST
$(head -c 600 "$E/legenda.txt")$EXTRA" || echo "falhou o envio ao bot"
echo "$ST"
# contaviral ainda não vai ao TikTok/Instagram (metricool-pub2 não configurado para ele).
