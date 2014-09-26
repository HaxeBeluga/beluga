# Beluga

Bonjour à tous ! Bienvenue dans ce manuel qui va vous présenter notre projet "Beluga" et vous apprendre à le manipuler.

Dans un premier temps, je vais vous présenter le projet puis je vous donnerai quelques précisions pour le récupérer, le modifier et le tester depuis votre machine. Enfin, je vous montrerai quelques éléments pour programmer en **Haxe** - parce que notre projet a été fait avec ce langage - et parlerai de quelques termes techniques.

## Qu'est-ce que Beluga ?

Beluga est tout simplement un framework pour navigateur (comme *Internet Explorer*, *Mozilla Firefox* ou *Google Chrome*).
### Mais qu'est-ce qu'un framework ?
Un framework est un ensemble de composants logiciels structurels (que nous appellerons ici **modules**) qui sert à créer les fondations d'un logiciel.
Un framework est donc conçu et utilisé pour modeler l'architecture des logiciels, applications web et autres.
Le terme français le plus correct est *cadre d'applications* ou encore *cadriciel* mais **framework** est plus approprié même si le terme est anglais.

Donc Beluga est un framework qui va créer différents modules (module de forum, de marché, de tickets pour contacter le support, de compte pour s'identifier/se déconnecter, de messagerie, d'informations ...) autour d'une application web (application sur navigateur).

Il est **open source**, c'est-à-dire que tout le monde peut avoir accès au code source du projet. Un utilisateur lambda ne sera pas forcément intéressé contrairement à un développeur.

Comme je l'ai déjà dit, le projet a été fait avec le langage **Haxe**.

## Récupération du projet et contribution

Voir le tutoriel de récupération (https://github.com/FassiClement/Beluga/blob/documentation/doc/Manual/Tutoriel_Récupération.md)

## Modules

https://github.com/regnarock/Beluga/blob/doc/create_module/doc/03-Module.md

## Hello World

Voici comment afficher un "Hello World" avec Haxe :

> class HelloWorld {

>   static public function main():Void {
>     trace("Hello World");

> }

> }

On peut tester le code suivant dans un fichier **HelloWorld.hx** et faire appel au compiler de Haxe en tapant la ligne qui suit en ligne de commande :

> haxe -main HelloWorld --interp

On verra s'afficher ceci :

> HelloWorld.hx:3: Hello world

Il y a plusieurs choses à retenir en Haxe :

* Les programmes sont sauvegardés dans des fichiers avec *.hx* comme extension
* Le compiler Haxe est un outil de ligne de commande qui fonctionne avec des paramètres tels que **-main Helloworld** ou encore **--interp**.
* Les programmes contiennent des classes (*HelloWorld*, avec majuscules) qui contiennent des fonctions (*main*, avec des minuscules).

## Partie technique

Reprendre les infos du TD et de l'UD pour les triggers et autres ?