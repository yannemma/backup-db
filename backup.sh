#!/bin/bash

# Obtenir l'ID de conteneur du conteneur PostgreSQL
CONTAINER_ID=$(docker-compose ps -q db)

# Créer un horodatage pour le nom de fichier de sauvegarde
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Configuration MinIO
MINIO_ENDPOINT="localhost:9000"
MINIO_ACCESS_KEY="minio"
MINIO_SECRET_KEY="minio123"

# Définir le bucket et la clé d'objet pour le téléchargement
BUCKET_NAME="backup"
FILE_PATH="mydatabase_$TIMESTAMP.dump"
OBJECT_KEY=$FILE_PATH

# Détails pour signer la requête PUT vers MinIO
host=$MINIO_ENDPOINT
s3_key=$MINIO_ACCESS_KEY
s3_secret=$MINIO_SECRET_KEY
resource="/${BUCKET_NAME}/${OBJECT_KEY}"
content_type="application/octet-stream"
date=$(date -R)
_signature="PUT\n\n${content_type}\n${date}\n${resource}"
signature=$(echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64)

# Exécuter pg_dump pour créer un fichier de sauvegarde de la base de données PostgreSQL
docker exec $CONTAINER_ID pg_dump -U admin -Fc axelor-open-suite > $FILE_PATH

# Vérifier si la sauvegarde a été créée avec succès
if [ -f "$FILE_PATH" ]; then
    echo "Backup created successfully: $FILE_PATH"

    # Utiliser curl pour envoyer la sauvegarde vers MinIO
    curl -X PUT -T "${FILE_PATH}" \
        -H "Host: ${host}" \
        -H "Date: ${date}" \
        -H "Content-Type: ${content_type}" \
        -H "Authorization: AWS ${s3_key}:${signature}" \
        http://${host}${resource}

    echo "Backup uploaded to MinIO: ${BUCKET_NAME}/${OBJECT_KEY}"
else
    echo "Failed to create the backup."
fi
