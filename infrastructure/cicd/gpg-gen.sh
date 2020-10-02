#!/bin/sh
ID=cicd@greenwalking.apps.xennis.org

echo ">>> Generate"
gpg --verbose --batch --gen-key << EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: CICD User
Name-Comment: User for CI CD
Name-Email: ${ID}
Expire-Date: 1y
%no-protection
%commit
EOF

echo ">>> Export"
gpg --export-secret-key --armor -o ${ID}.priv.asc ${ID}
gpg --export-secret-subkeys --armor -o ${ID}.sub_priv.asc ${ID}
gpg --export --armor -o ${ID}.pub.asc ${ID}

#echo ">>> Delete"
#gpg --delete-secret-keys ${ID}
#gpg --delete-keys ${ID}
