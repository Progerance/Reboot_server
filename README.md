<h1>Server Reboot Script</h1>

<p>Ce script Bash automatise le processus de surveillance de la connectivité réseau pour un serveur Linux. Il tente de <code>ping</code> deux adresses IP configurables à intervalles réguliers. Si les deux adresses IP sont injoignables après deux tentatives de test, le script initiera un redémarrage propre du serveur. Cette automatisation vise à réduire le temps d'arrêt du serveur dû à des problèmes de connectivité réseau transitoires.</p>

<h2>Fonctionnalités</h2>

<ul>
  <li>Surveillance de la connectivité réseau via <code>ping</code> à deux adresses IP distinctes.</li>
  <li>Deux niveaux de vérification avant le redémarrage pour éviter les redémarrages intempestifs.</li>
  <li>Écriture des tentatives de redémarrage dans un fichier de log pour la traçabilité.</li>
  <li>Protection contre les redémarrages en boucle grâce à un intervalle minimum configurable entre les redémarrages.</li>
</ul>

<h2>Prérequis</h2>

<ul>
  <li>Système d'exploitation : Linux (Testé sur Ubuntu et Debian).</li>
  <li>Privilèges root pour le redémarrage du serveur et la modification de la crontab.</li>
</ul>

<h2>Installation</h2>

<ol>
  <li>Clonez ce dépôt ou téléchargez le script <code>server-reboot.sh</code> sur votre serveur.</li>
  <li>Rendez le script exécutable :
    <pre><code>chmod +x server-reboot.sh</code></pre>
  </li>
  <li>(Optionnel) Modifiez les adresses IP dans le script pour correspondre à vos cibles de surveillance spécifiques.</li>
</ol>

<h2>Configuration</h2>

<h3>Configurer les adresses IP</h3>

<p>Ouvrez <code>server-reboot.sh</code> dans votre éditeur de texte préféré et modifiez les variables <code>IP1</code> et <code>IP2</code> pour définir les adresses IP que vous souhaitez surveiller :</p>

<pre><code>IP1="8.8.8.8" # Exemple: Google DNS
IP2="1.1.1.1" # Exemple: Cloudflare DNS
</code></pre>

<h3>Configurer le Cron Job</h3>

<p>Pour une surveillance continue, configurez un cron job pour exécuter le script à intervalles réguliers :</p>

<ol>
  <li>Ouvrez la crontab de l'utilisateur root :
    <pre><code>sudo crontab -e</code></pre>
  </li>
  <li>Ajoutez une ligne pour exécuter le script toutes les 3 minutes (ou selon vos préférences) :
    <pre><code>*/3 * * * * /chemin/vers/server-reboot.sh </code></pre>
    Remplacez <code>/chemin/vers/</code> par le chemin absolu de votre script et du fichier de log.
  </li>
</ol>

<h2>Utilisation</h2>

<p>Une fois configuré, le script s'exécutera automatiquement selon l'horaire défini dans cron. Il n'y a pas besoin d'intervention manuelle pour les opérations de routine. Le fichier de log <code>/chemin/vers/reboot.log</code> contiendra les entrées de journal chaque fois que le script tente de redémarrer le serveur.</p>

<h2>Sécurité</h2>

<ul>
  <li>Assurez-vous que seuls les utilisateurs autorisés ont accès au script et au fichier de log.</li>
  <li>Vérifiez régulièrement le fichier de log pour tout redémarrage inhabituel qui pourrait indiquer un problème sous-jacent à résoudre.</li>
</ul>
