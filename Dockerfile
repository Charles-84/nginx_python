# Utilisation de Debian Slim avec Python 3.11 comme base
FROM python:3.11-slim

# Mise à jour des paquets et installation des dépendances nécessaires
RUN apt update && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps sudo openvpn nginx \
    # Installation de PHP et des extensions nécessaires
    && apt -y install php php-xml php-exif php-fpm php-soap php-gmp php-pdo php-json php-dom php-zip php-mysqli php-sqlite3 php-pdo php-gd php-curl php-mbstring php-bcmath php-intl

# Ajout de l'utilisateur non-privilégié pour une meilleure sécurité
RUN useradd -m -d /home/container container --shell /bin/bash && echo "container:container" | chpasswd && adduser container sudo

# Copie de Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration de l'environnement pour l'utilisateur container
USER container
ENV USER=container HOME=/home/container

# Répertoire de travail
WORKDIR /home/container

# Copie et configuration du script d'entrée
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --chown=container:container ./start.sh /home/container/start.sh
RUN chmod +x /home/container/start.sh

# Configuration de l'exécution
CMD ["/bin/bash", "/entrypoint.sh"]
