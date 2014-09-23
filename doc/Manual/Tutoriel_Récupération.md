Comment récupérer le projet
========================

Voici les étapes pour récupérer notre projet depuis le site où il est hébergé (github.com) afin de le mettre sur votre ordinateur, en **local**.

Il vous faudra tout d'abord télécharger des outils :

* un client [git](http://git-scm.com/)
* un client [github](https://windows.github.com) approprié à votre OS (Windows, Linux ...)
* [Haxe3](http://haxe.org/download)

*Pour que le client git soit fonctionnel, recherchez les variables d’environnement de votre système avec la fonction **recherche** et modifiez la variable **Path** en ajoutant ceci à la fin :
« ;C:\Program Files (x86)\Git\cmd » (ou le chemin d’installation de git si vous ne l’avez pas laissé par défaut)*

![Environement variables](img/Variables_environnement.jpg)

Il vous faudra ensuite télécharger d'autres outils si vous comptez tester le projet et voir comment il fonctionne :

* un serveur web (comme Apache)

*Je vous conseille de télécharger un pack comme "Wamp" (pour Windows), "Samp" (pour Solaris), "Lama" (pour Linux) ou "Mamp" (pour Mac OSX) qui contient principalement le serveur Apache ainsi que la base de données MySQL qui est aussi un requis (voir ci-dessous).*

* une base de données « MySQL »

*(allez sur http://dev.mysql.com/downloads/windows/ et cliquez sur « MySQL Installer » pour les utilisateurs de Windows par exemple).
Pas la peine de le télécharger donc si vous avez téléchargé un pack juste avant cela puisqu'il contient déjà la base de données.*

Notre projet « Beluga » est actuellement hébergé sur Github, accessible à l’adresse suivante: https://github.com/HaxeBeluga/Beluga

Pour contribuer, il vous faut donc **forker** (faire une copie pour vous) le projet et le **cloner** sur votre poste de travail (afin qu'il soit disponible en **local**):

![Buttons](img/Github.jpg)

*Pour cela, cliquez sur l’option « Fork » en haut à droite de la page web et choisissez votre compte (que vous aurez préalablement créé si vous n'en aviez pas un avant, c'est rapide et gratuit !).
Allez ensuite sur le fork (via https://github.com/votre_nom_de_compte/Beluga) et cliquez sur « Clone in Desktop ». Cela va ouvrir votre client Github et vous demander l’endroit (le chemin d'accès en **local** donc) où installer le dépôt cloné.*

Comment contribuer
=================


Pour contribuer au projet, c'est-à-dire ajouter un petit quelque chose ou faire des modifications, il faut intégrer vos modifications (ajout/modification de fichier/code) sur le dépôt principal de Beluga et donc utiliser les **pull requests**.
Bien sûr, inutile de proposer des fichiers de code non testés.

Par exemple pour ajouter un fichier en utilisant un **pull request**, voici la marche à suivre :
* Copiez votre fichier dans votre dépôt **local**
* Ouvrez une ligne de commande (la petite fenêtre noire) et tapez "git add nom_du_fichier_à_ajouter"
* Tapez ensuite "git commit -m "description_du_fichier_ajouté""
* Tapez enfin "git push origin nom_de_votre_branche_locale_de_travail"
* Allez sur votre fork sur github (https://github.com/votre_nom_de_compte/Beluga) et choississez votre branche de travail
* Cliquez sur le bouton à droite nommé "Compare, review, create a pull request" pour créer votre pull request qui sera ensuite examiné et validé/refusé !

![Button to create a PR](img/PR.jpg)

Vous devez choisir un répertoire de base et un répertoire de destination quand vous créez votre *pull request*.

Le répertoire de base sera votre fork sur github et la branche associée sera celle où vous travaillez en **local**.

Le répertoire de destination sera *HaxeBeluga/Beluga* et la branche associée sera la branche **master**.

![Repository](img/Fork_PR.jpg)