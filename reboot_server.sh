#!/bin/bash

# Emplacement du fichier indicateur horodatage
FLAG_FILE="server_reboot.flag"

# Chemin vers le fichier de log
LOG_FILE="/var/log/reboot_script.log"

# Temps minimum entre les redemarrages (en secondes), ici 12 heures = 43200 secondes
MIN_REBOOT_INTERVAL=43200

# Adresses IP a verifier
IP1="8.8.8.8" # Exemple: Google DNS 8.8.8.8
IP2="1.1.1.1" # Exemple: Cloudflare DNS 1.1.1.1

# Fonction pour verifier la connectivite
check_connectivity() {
    ping -c 3 -W 10 $1 > /dev/null
    return $?
}

# Fonction pour verifier et gerer le fichier indicateur
manage_flag_file() {
    if [ -f "$FLAG_FILE" ]; then
        FILE_AGE=$(( $(date +%s) - $(stat -c %Y "$FLAG_FILE") ))
        if [ $FILE_AGE -gt $MIN_REBOOT_INTERVAL ]; then
            echo "Le dernier redemarrage reussi est plus ancien que le delai minimum. Nettoyage du fichier indicateur."
            rm -f "$FLAG_FILE"
            return 0 # Indique qu'il est sur de proceder a un redemarrage si necessaire
        else
            echo "Un redemarrage a deja ete effectue il y a moins de $(($MIN_REBOOT_INTERVAL / 3600)) heures. Annulation pour eviter une boucle."
            return 1 # Indique qu'un redemarrage ne doit pas etre effectue
        fi
    else
        return 0 # Pas de fichier indicateur, donc sur de proceder
    fi
}

# Premiere verification de la connectivite
check_connectivity $IP1
status1=$?
check_connectivity $IP2
status2=$?

if [ $status1 -ne 0 ] && [ $status2 -ne 0 ]; then
    echo "Les deux adresses IP ne repondent pas, tentative de re-verification dans 30 secondes..."
    sleep 30
    # Seconde verification
    check_connectivity $IP1
    status1=$?
    check_connectivity $IP2
    status2=$?
    if [ $status1 -ne 0 ] && [ $status2 -ne 0 ]; then
        echo "Les deux adresses IP ne repondent toujours pas..."
        manage_flag_file
        can_restart=$?
        if [ $can_restart -eq 0 ]; then
            echo "Preparation au redemarrage du serveur..."
            touch "$FLAG_FILE" # Creation ou mise a jour du fichier indicateur
	    echo "Reboot execute par le script automatique le $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
     	# Redemarrage du serveur
            /sbin/shutdown -r now "Redemarrage automatique suite a l'echec de la connectivite."
        fi
    else
	echo "La connectivite est retablie lors de la seconde tentative."
	rm -f "$FLAG_FILE" # Nettoyage du fichier si la connectivite est retablie et le redemarrage ancien
    fi
else
    echo "La connectivite est bonne."
    rm -f "$FLAG_FILE" # Nettoyage du fichier si la connectivite est retablie et le redemarrage ancien
fi
