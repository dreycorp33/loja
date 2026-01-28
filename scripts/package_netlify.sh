#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${ROOT_DIR}/dist"
ARCHIVE_NAME="dr-solucoes-netlify.zip"

mkdir -p "${OUTPUT_DIR}"
cd "${ROOT_DIR}"

zip -r "${OUTPUT_DIR}/${ARCHIVE_NAME}" \
  index.html \
  README.md \
  netlify.toml \
  -x "*.git*" \
  -x "dist/*"

echo "Pacote gerado em ${OUTPUT_DIR}/${ARCHIVE_NAME}"
