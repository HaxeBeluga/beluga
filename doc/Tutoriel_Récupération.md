Comment récupérer le projet
========================

Il vous faudra tout d'abord des outils :

* un client [git](http://git-scm.com/)
* un client [github](https://windows.github.com) approprié à votre OS (Windows, Linux ...)
* [Haxe3](http://haxe.org/download)

*Pour que le client git soit fonctionnel, recherchez les variables d’environnement de votre système avec la fonction *recherche* et modifiez la variable **Path** en ajoutant ceci à la fin :
« ;C:\Program Files (x86)\Git\cmd » (ou le chemin d’installation de git si vous ne l’avez pas laissé par défaut)*

![Variables d'environnement](http://imagizer.imageshack.us/v2/150x100q90/743/eG5CwO.jpg)

Il vous faudra d'autres outils pour faire des tests :

* un serveur web (comme Apache)

*Je vous conseille de télécharger le pack « wamp » si vous travaillez sous Windows (il contient tout le nécessaire)*

* une base de données « MySQL »

*(allez sur http://dev.mysql.com/downloads/windows/ et cliquez sur « MySQL Installer » pour les utilisateurs de Windows)*

![MySQL](http://imagizer.imageshack.us/v2/150x100q90/631/jKo96F.jpg)

Notre projet « Beluga » est actuellement hébergé sur github, accessible à l’adresse suivante: https://github.com/HaxeBeluga/Beluga

![Github](http://imagizer.imageshack.us/v2/150x100q90/913/3apqko.jpg)

Pour contribuer, il vous faut donc **forker** (faire une copie pour vous) le projet et le **cloner** sur votre poste de travail :

*Pour cela, cliquez sur l’option « Fork » en haut à droite de la page web et choisissez votre compte.
Allez ensuite sur le fork et cliquez sur « Clone in Desktop ». Cela va ouvrir votre client Github et vous demander l’endroit où installer le dépôt cloné.*

Comment contribuer
=================


Ensuite il faut intégrer vos modifications (ajout/modification de fichier/code) sur le dépôt principal de Beluga et donc utiliser les **pull request**.

Par exemple pour ajouter un fichier, voici la marche à suivre :
* Copiez votre fichier dans votre dépôt local
* Ouvrez une ligne de commande et tapez "git add nom_du_fichier"
* Tapez ensuite "git commit -m "description_du_commit" nom_du_fichier"
* Tapez ensuite "git push origin nom_de_votre_branche_locale"
* Allez sur votre fork sur github et choississez votre branche de travail
* Cliquez sur le bouton à droite nommé "Compare, review, create a pull request" pour créer votre pull request qui sera ensuite examiné et validé/refusé !