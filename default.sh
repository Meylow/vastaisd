#!/bin/bash

# Aktiviert das virtuelle Python-Umfeld
source /venv/main/bin/activate

# Verzeichnis definieren
A1111_DIR=${WORKSPACE}/stable-diffusion-webui

# Sicherstellen, dass das WebUI-Verzeichnis existiert
if [[ ! -d "$A1111_DIR" ]]; then
    echo "Fehler: $A1111_DIR nicht gefunden!"
    echo "Bitte stelle sicher, dass dein Google Drive Sync korrekt ist."
    exit 1
fi

# Optional: Extensions aktualisieren (z. B. falls du ControlNet oder andere manuell ergänzt hast)
# git -C "$A1111_DIR/extensions/sd-webui-controlnet" pull || true

# Optional: Fix für GIT-Sicherheitswarnungen beim Root-Zugriff
export GIT_CONFIG_GLOBAL=/tmp/temporary-git-config
git config --file $GIT_CONFIG_GLOBAL --add safe.directory '*'

# Startparameter definieren (du kannst hier Flags anpassen)
export COMMANDLINE_ARGS="--skip-python-version-check --no-download-sd-model --do-not-download-clip --no-half --port 11404"

# Starte AUTOMATIC1111 WebUI
cd "$A1111_DIR"
LD_PRELOAD=libtcmalloc_minimal.so.4 python launch.py $COMMANDLINE_ARGS &

# Provisioning-Flag auf "fertig" setzen, damit A1111 nicht blockiert
rm -f /.provisioning
touch /workspace/.provisioning_done

echo -e "\n✅ Stable Diffusion WebUI wurde gestartet auf Port 11404"
