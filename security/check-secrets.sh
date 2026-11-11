#!/usr/bin/env bash
# Teaching-sized secret scanner. Real projects use tools such as gitleaks or trufflehog.
set -u
found=0
patterns=(
 "(password|passwd|secret|api[_-
]?key|token)[[:space:]]*[=:][[:space:]]*[\"'][^\"']{6,}[\"']"
 'AKIA[0-9A-Z]{16}'
 '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
)
for p in "${patterns[@]}"; do
 hits=$(grep -rEliI --exclude-dir=.git --exclude-dir=security -e "$p" . || true)
 if [ -n "$hits" ]; then
 echo "Possible secret in:"
 echo "$hits"
 found=1
 fi
done
if [ "$found" -eq 1 ]; then
 echo "SECRET SCAN FAILED: remove the secret, then rotate it."
 exit 1
fi
echo "Secret scan passed: no obvious secrets found"