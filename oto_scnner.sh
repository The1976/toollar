#!/bin/bash

# Kullanım: ./birlesik_script.sh dosya.txt

dosya=$1

if [ -z "$dosya" ]; then
  echo "Kullanım: $0 <dosya>"
  exit 1
fi

if [ ! -f "$dosya" ]; then
  echo "Hata: $dosya bulunamadı."
  exit 1
fi

while IFS= read -r satir; do
  # Satırdaki URL'leri tespit et
  url=$(echo "$satir" | grep -oE "http[s]?://[a-zA-Z0-9./?=_-]*")

  # Eğer URL bulunduysa, klasör oluştur ve URL'yi dosyaya yaz
  if [ -n "$url" ]; then
    domain=$(echo "$url" | awk -F[/:] '{print $4}')

    # Klasörü oluştur
    klasor_adi="$domain-klasor"
    mkdir -p "$klasor_adi"

    # URL'yi "domain.txt" dosyasına yaz
    echo "$url" > "$klasor_adi/domain.txt"

    # Gau komutunu çalıştır ve çıktıyı klasöre kaydet
    echo "İşlem başlıyor: $klasor_adi"
    gau --o "$klasor_adi/raw_gau.txt" "$url"
    echo "İşlem tamamlandı: $klasor_adi"
  fi
done < "$dosya"
