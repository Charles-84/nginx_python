#!/bin/bash
# Un petit délai pour s'assurer que tout est prêt pour le démarrage
sleep 1

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Changement vers le répertoire de l'utilisateur
cd /home/container

# Affiche la version actuelle de Python
python --version

# Remplacement des variables de démarrage
# Utilisation de eval et echo pour le traitement et le remplacement des variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Exécution de la commande de démarrage
eval ${MODIFIED_STARTUP}
