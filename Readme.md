## sauvegarder une base de données PostgreSQL et télécharger un fichier de sauvegarde dans MinIO à l'aide de Docker Compose et Shell Script

### Qu'est-ce que MinIO ?

MinIO est un serveur de stockage d'objets léger et performant, compatible avec le service de stockage cloud Amazon S3. 
Il peut être utilisé pour stocker des données non structurées, telles que des photos, des vidéos et des fichiers de sauvegarde.
Vous pouvez facilement déployer MinIO sur votre propre serveur et gérer vos données sans avoir recours à un service de stockage cloud tiers.

Étape 1 : Configurer les differents services avec Docker Compose
Enregistrez le fichier Docker Compose ci-dessus docker-compose.yml à l'emplacement souhaité,
Étape 2 : Créer un script de sauvegarde

Pour créer un script de sauvegarde, vous pouvez utiliser n'importe quel langage de script que vous connaissez, comme Bash ou Python.
Dans cet exemple, nous allons créer un script Bash.

Créez un nouveau fichier appelé backup.sh et ajoutez le code suivant :

![image](https://github.com/user-attachments/assets/6fb51d22-25c8-4c44-a588-7bb2aef8dcae)

 puis exécutez la commande suivante dans le même répertoire :
`docker-compose up -d` apres vous creer le bucket Minio du nom de BACKUP
![image](https://github.com/user-attachments/assets/30f30228-257a-4c83-8b04-3a65dbe41788)

Étape 3 : tester le script de sauvegarde

Avant de configurer une tâche cron pour exécuter automatiquement le script de sauvegarde, vous devez la tester pour vous assurer qu'elle fonctionne correctement. Pour ce faire, exécutez simplement le script de sauvegarde à partir de la ligne de commande 
`chmod +x backup.sh` et `./backup.sh` 

Étape 4 : planifier une tâche Cron

Ouvrez le fichier crontab en exécutant la commande suivante :
`crontab -e`
Ajoutez la tâche cron ci-dessous à la fin du fichier

`0 2 * * * /home/moussa/kapsiki-axelor-open-suite-webapp-8.0.8/backup.sh >> /home/moussa/kapsiki-axelor-open-suite-webapp-8.0.8/backup.log 2>&1`
Une fois la tâche cron ajoutée, elle s'exécutera automatiquement chaque 2h du matin

