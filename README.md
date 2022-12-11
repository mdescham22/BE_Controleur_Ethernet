# BE_Controleur_Ethernet


## Fonctionnement

Le contrôleur Ethernet est utilisé pour la communication entre plusieurs appareils distants. 
Dans le modèle OSI, Il est situé dans la couche MAC de la partie Liaison de données. 
Son rôle est ainsi d’attribuer à appareil une adresse physique sur le réseau pour ainsi différencier les appareils et donc communiquer.

Lors de notre recherche, nous avons pu identifier 3 entités majeures de "Contrôleur Ethernet”: Emetteur, Récepteur, Détecteur de collision. Chaque entité est définie par des signaux d’entrée et de sortie. 

L’objectif de l’émetteur est de recevoir la trame venant de la couche LLC (couche supérieure), d’empaqueter les données MAC et d’envoyer cette trame à la couche physique.
Le récepteur quant à lui, a pour but “d’écouter” le réseau Ethernet et de recevoir les trames qui lui sont attribuées pour enfin envoyer les données à la couche LLC.

Une trame ethernet est composée de plusieurs couches d’information. Le premier octet est une entête ethernet que nous appelons SFD. Un émetteur construit ce SFD et il est détecté comme le début d’une trame par le récepteur. Les 6 prochains octets constituent l’adresse ethernet de destination. Le récepteur vérifie cette adresse et continue la réception dès qu’elle est correcte. Les 6 octets qui suivent constituent l’adresse émetteur qui sera généré par l’entité émettrice lors de la transmission. La couche suivante constitue la donnée de couche LLC. Cette donnée est transmise à partir de la couche LLC de la machine émettrice vers la couche LLC de la machine réceptrice. Un dernier octet EFD est généré par l'émetteur qui sera détecté par le récepteur en déclenchant la fin d’une trame ethernet.

![This is an image](https://github.com/mdescham22/BE_Controleur_Ethernet/blob/main/image_readme/f1.PNG)

Le détecteur de collision a pour but d’identifier une collision, c'est-à-dire si l’ethernet est à la fois en mode émission et réception au même moment. Cela va déclencher un flag de refus ainsi le rejet de l’émission et de la réception. 


## Réalisation du controleur Ethernet-10 Core

![This is an image](https://github.com/mdescham22/BE_Controleur_Ethernet/blob/main/image_readme/f2.PNG)

### Emetteur

Pour gagner en temps de programmation nous avons dans un premier temps construit un logigramme relatant des différents cas dans lequel l'émetteur pouvait ce trouver (figure ci-dessous).

![This is an image](https://github.com/mdescham22/BE_Controleur_Ethernet/blob/main/image_readme/f3.PNG)

Après avoir valider notre logigramme nous avons commencé à écrire le code VHDL pour finir par la simulation.

### Récepteur

De la même façon, nous avons commencé cette partie par un logigramme (ci-dessous).

![This is an image](https://github.com/mdescham22/BE_Controleur_Ethernet/blob/main/image_readme/f4.PNG)

### Collision

La collision possédant moins de registre, nous nous sommes passés de la convention adoptée plus tôt. Nous avons écrit le code VHDL et la simulation sans l’aide de logigramme.

### Réunion des Parties

Une fois toutes les parties opérationnelles, nous avons décidé de les joindre dans une structure globale “”.

## Améliorations

## Objectifs
- [ ] Réaliser le contrôleur sous VHDL
- [ ] Avoir des tests fonctionnels
- [ ] Possibilité de l’implémenter matériellement
