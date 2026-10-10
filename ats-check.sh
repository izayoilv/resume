#!/usr/bin/env bash
# ATS parse check: verifies the built resume PDF extracts cleanly.
set -u
cd "$(dirname "$0")"

PDF="Vincent_Yongky_Pratama_Resume.pdf"
SRC="resume.tex"
fail=0

for tool in pdftotext pdfinfo pdfimages pdffonts; do
  command -v "$tool" >/dev/null || { echo "MISSING TOOL: $tool (install poppler-utils)"; exit 2; }
done

if [ ! -f "$PDF" ]; then echo "MISS: $PDF not built (run latexmk)"; exit 1; fi
if [ "$SRC" -nt "$PDF" ]; then echo "MISS: $SRC is newer than the PDF — rebuild with latexmk"; fail=1; fi

pages=$(pdfinfo "$PDF" | awk '/^Pages:/{print $2}')
[ "$pages" = "1" ] && echo "ok: single page" || { echo "MISS: pages=$pages (expected 1)"; fail=1; }

imgs=$(pdfimages -list "$PDF" 2>/dev/null | awk 'NR>2' | wc -l)
[ "$imgs" -eq 0 ] && echo "ok: no embedded images" || { echo "MISS: $imgs image(s) embedded"; fail=1; }

notembedded=$(pdffonts "$PDF" | awk 'NR>2 && $(NF-4)!="yes" {print $1}')
[ -z "$notembedded" ] && echo "ok: all fonts embedded" || { echo "MISS: fonts not embedded: $notembedded"; fail=1; }

title=$(pdfinfo "$PDF" | awk -F': *' '/^Title:/{print $2}')
case "$title" in *Resume*) echo "ok: PDF title metadata" ;; *) echo "MISS: PDF title '$title' lacks 'Resume'"; fail=1 ;; esac

TEXT=$(pdftotext "$PDF" -)

check() {
  if printf '%s' "$TEXT" | grep -qF -- "$1"; then
    echo "ok: $1"
  else
    echo "MISS: $1"
    fail=1
  fi
}

echo "--- identity & contact"
check "Vincent Yongky Pratama"
check "812-6694-0976"
check "izayoilv@gmail.com"
check "www.linkedin.com/in/vincent-yongky"
check "github.com/izayoilv"

echo "--- section headings"
for s in Summary Skills Experience Projects Education Certifications Languages; do
  check "$s"
done

echo "--- content keywords"
check "Universitas Internasional Batam"
check "3.70/4.00"
check "Expected 2029"
check "Kubernetes"
check "OpenTofu"
check "OpenBao"
check "Rust"
check "Woodpecker"
check "TOEIC 920"
check "KodeKloud"
check "Cisco Networking Academy"

if [ "$fail" -ne 0 ]; then
  echo
  echo "ATS CHECK FAILED"
  exit 1
fi
echo
echo "ATS CHECK PASSED"
