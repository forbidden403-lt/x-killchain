#!/bin/bash
TARGET=$1
BASE="/home/forbidden/x-killchain"
STORAGE="$BASE/storage/$TARGET"

if [ -z "$TARGET" ]; then
    echo "Usage: ./main.sh <domain>"
    exit 1
fi

mkdir -p "$STORAGE"/{stage1_recon,stage2_probing,stage3_vulns}

echo "[*] Pipeline dimulai: $TARGET"

# STAGE 1: Recon
subfinder -d "$TARGET" -silent > "$STORAGE/stage1_recon/final_subdomains.txt"
assetfinder --subs-only "$TARGET" >> "$STORAGE/stage1_recon/final_subdomains.txt"
sort -u "$STORAGE/stage1_recon/final_subdomains.txt" -o "$STORAGE/stage1_recon/final_subdomains.txt"

# STAGE 2: Probing (Paralel)
echo "[+] Probing 95+ target aktif..."
> "$STORAGE/stage2_probing/active_targets.txt"
cat "$STORAGE/stage1_recon/final_subdomains.txt" | xargs -I {} -P 20 sh -c '
    code=$(curl -k -o /dev/null -s -w "%{http_code}" --connect-timeout 2 "https://{}" 2>/dev/null)
    if [ "$code" != "000" ] && [ "$code" != "" ]; then
        echo "https://{}"
    fi
' >> "$STORAGE/stage2_probing/active_targets.txt"

# STAGE 3: Nuclei (Lebih sensitif dengan menambah severity)
if [ -s "$STORAGE/stage2_probing/active_targets.txt" ]; then
    echo "[+] Scanning dengan Nuclei (Severity: Medium, High, Critical)..."
    nuclei -l "$STORAGE/stage2_probing/active_targets.txt" \
           -severity medium,high,critical \
           -stats \
           -o "$STORAGE/stage3_vulns/vulnerabilities.txt"
else
    echo "[!] Tidak ada target aktif ditemukan."
    exit 1
fi

echo "[!] Selesai. Hasil disimpan di: $STORAGE/stage3_vulns/vulnerabilities.txt"
