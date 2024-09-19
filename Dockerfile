FROM tomcat:9.0.84-jdk11

# Copier le fichier ROOT.war dans le répertoire webapps de Tomcat
COPY build/libs/kapsiki-erp-8.0.8.war /usr/local/tomcat/webapps/ROOT.war

# Exposer le port 8080
EXPOSE 8080
