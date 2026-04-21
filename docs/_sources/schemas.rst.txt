.. _chap-ddl:

###################
Schémas relationnel
###################

Ce chapitre présente le *langage de définition de données*
(LDD) qui permet de spécifier le schéma d'une base
de données relationnelle. Ce langage correspond
à une partie de la norme SQL (*structured query language*), 
l'autre partie étant relative
à la *manipulation des données* (LMD).

La définition d'un schéma  comprend essentiellement
deux parties: d'une part la description des *tables*, d'autre part 
les *contraintes* qui portent
sur leur contenu. La spécification des contraintes
est souvent placée au second plan bien qu'elle soit
en fait très importante: elle permet d'assurer, 
*au niveau de la base*, des contrôles sur l'intégrité
des données qui s'imposent à toutes les applications
accédant à cette base. Un dernier aspect de la définition
d'un schéma, rapidement survolé ici, 
est la description de la représentation dite "physique", celle qui 
décrit l'organisation des données. Il est toujours possible de réorganiser
une base, et on peut donc tout à fait adopter initialement l'organisation
choisie par défaut pour le système.


****************************
S1: Création d'un schéma SQL
****************************

.. admonition::  Supports complémentaires:

    * `Diapositives: spécification d'un schéma relationnel <http://sql.bdpedia.fr/files/slddl.pdf>`_
    * `Vidéo sur la spécification d'un schéma relationnel / association <https://mediaserver.lecnam.net/videos/schema-relationnel/>`_ 


Passons aux choses concrètes: vous avez maintenant un serveur de base de données en place,
vous disposez d'un compte d'accès, vous avez conçu votre base de données et vous voulez
concrètement la mettre en œuvre.  Nous allons prendre pour fil directeur la
base des films. La première chose à faire est de créer une base spécifique
avec la commande suivante:

.. code-block:: sql

     create database Films

Il est d'usage de créer un utilisateur ayant les droits d'administration
de cette base. 

.. code-block:: sql

     grant all on Films.* to philippe identified by 'motdepasse'
     
Voilà, maintenant il est possible d'ouvrir une connexion à la base
``Film`` sous le compte ``philippe`` et de créer notre schéma. 

Types SQL
=========

La norme SQL ANSI propose un ensemble de types dont
les principaux sont donnés dans le tableau ci-dessous.
Ce tableau présente également la taille, en octets, des instances
de chaque type, cette taille n'étant ici qu'à titre indicatif
car elle peut varier selon les systèmes.


.. csv-table:: 
    :header:  "Type",  "Description", "Taille" 
    :widths: 20, 30, 30

    integer, Type des entiers relatifs, 4 octets
    smallint, idem, 2 octets
    bigint, idem, 8 octets
    float, Flottants simple précision, 4 octets
    double, Flottants double précision, 8 octets
    real, Flottant simple ou double, 8 octets
    "numeric (*M, D*)", Numérique avec précision fixe., *M* octets
    "decimal(*M, D*)",  Idem., *M* octets
    char(*M*), Chaînes de longueur fixe, *M* octets
    varchar*(M*), Chaînes de longueur variable, *L+1* avec :math:`L \leq M`
    bit varying, Chaînes d'octets, Longueur de la chaîne.
    date, "Date (jour, mois, an)", env. 4 octets
    time, "Horaire (heure, minutes, secondes)", env. 4 octets
    datetime, Date et heure, 8 octets
    year, Année, 2 octets

**Types numériques exacts**

La norme SQL ANSI distingue deux catégories d'attributs
numériques: les *numériques exacts*, et les
*numériques flottants*. Les types de la première catégorie
(essentiellement ``integer`` et ``decimal``)
permettent de spécifier la précision souhaitée pour un attribut numérique, et donc 
de représenter une valeur exacte. Les numériques
flottants correspondent aux types couramment utilisés
en programmation (``float``, ``double``) et ne représentent
une valeur qu'avec une précision limitée.

Le type ``integer`` permet de stocker des entiers,
sur 4 octets.  Il existe deux variantes du type ``integer``: 
``smallint`` et ``bigint``. Ces types différent par la taille
utilisée pour le stockage: voir le tableau  des types SQL.

Le type ``decimal(M, D)`` correspond à un numérique de
taille maximale ``M``, avec un nombre de décimales
fixé à ``D``.
``numeric`` est un synonyme de ``decimal``.
Ces types sont surtout utiles pour manipuler des valeurs
dont la précision est connue, comme les valeurs
monétaires. Afin de préserver cette précision,
les instances de ces types sont stockées comme des chaînes de caractères.

**Types numériques flottants**

Ces types s'appuient sur la représentation des 
numériques flottants propre à la machine, en simple
ou double précision. Leur utilisation est donc analogue 
à celle que l'on peut en  faire dans un langage
de programmation comme le C. 

  * Le type ``float`` correspond aux flottants en simple précision. 
  * Le type ``double precision`` correspond aux flottants en double précision; le raccourci ``double`` est accepté.

**Caractères et chaînes de caractères**

Les deux types principaux de la norme ANSI sont ``char`` et ``varchar``.
Ces deux types permettent de stocker des chaînes de
caractères d'une taille maximale fixée par
le paramètre ``M``. Les syntaxes
sont identiques. Pour le premier, ``char(M)``, et ``varchar(M)`` pour le second.
La différence essentielle est qu'une
valeur ``char`` a une taille fixée, et se trouve donc complétée 
avec des blancs si sa taille est inférieure
à ``M``.  En revanche une valeur ``varchar`` a une taille variable et est tronquée
après le dernier caractère non blanc.

Quand on veut stocker des  chaînes de caractères  longues (des textes, voire des livres),
dont la taille dépasse, typiquement, 255 caractères,  le type ``varchar`` ne suffit plus.
La norme SQL propose un type ``bit varying`` qui correspond
à de très longues chaînes de caractères. Souvent
les systèmes proposent des variantes de ce type sous
le nom ``text`` ou ``blob`` (pour *Binary Long Object*).

**Dates**

Un attribut de type ``date`` stocke les informations jour,
mois et année (sur 4 chiffres). La représentation interne
n'est pas spécifiée par la norme.
Tous les systèmes proposent de nombreuses opérations de conversion (non normalisées)
qui permettent d'obtenir un format d'affichage quelconque.

Un attribut de type ``time`` représente un horaire avec une précision à la seconde. 
Le type ``datetime`` permet de combiner
une date et un horaire.

Création des tables
===================

D'une manière générale, les objets du schéma sont créés avec ``create``, modifiés
avec ``alter`` et détruits avec ``drop``, alors que les données, instances du schéma
sont créées, modifiées et détruites avec, respectivement, ``insert``, ``update``
et ``delete``.

Voici un premier exemple avec la commande de création de la table *Internaute*.

.. code-block:: sql

    create table Internaute (email varchar (40) not null, 
                            nom varchar (30) not null ,
                            prénom varchar (30) not null,
                            région varchar (30),
                            primary key (email));

La syntaxe se comprend aisément. La seule difficulté
est de choisir correctement le type de chaque attribut. 

.. admonition:: Conventions: noms des tables, des attributs, mots-clé SQL 

    On dispose, comme dans un langage de programmation, d'une certaine
    liberté. La seule recommandation est d'être cohérent pour des raisons de lisibilité.
    D'une manière générale, SQL n'est pas sensible à la casse. Quelques propositions:
   
     - Le nom des tables devrait commencer par une majuscule, le nom
       des attributs par une minuscule;
     - quand un nom d'attribut est constitué de plusieurs mots, on peut soit les séparer par
       des caractères '_', soit employer la convention *CamelCase*: minuscule au premier
       mot, majuscule aux suivants. Exemple: ``mot_de_passe`` ou ``motDePasse``.
     - Majuscule ou minuscule pour les mots-clé SQL? Quand on inclut une commande SQL
       dans un langage de programmation, il est peut-être plus lisible d'utiliser
       des majuscules pour les mots-clé.
     - Les accents et caractères diacritiques sont-ils acceptés? En principe oui, c'est
       ce que nous faisons ici. Cela implique de pouvoir aussi utiliser des accents
       dans les programmes qui incluent des commandes SQL et donc d'utiliser 
       un encodage de type UTF8. Il faut vérifier si c'est possible dans l'environnement
       de développement que vous utilisez. Dans le doute, il vaut peut-être mieux
       sacrifier les accents.

Le ``not null`` dans la création de table  *Internaute*
indique que l'attribut correspondant doit *toujours*
avoir une valeur. Il s'agit d'une différence importante entre
la pratique et la théorie: on admet que certains attributs
peuvent ne pas avoir de valeur, ce qui est très différent
d'une chaîne vide ou de 0.  Il est préférable
d'ajouter la contrainte ``not null`` quand c'est pertinent: cela renforce
la qualité de la base et facilite le travail des applications par la suite.
L'option suivante permet ainsi de garantir que
tout internaute a un mot de passe.

.. code-block:: sql

   motDePasse  varchar(60) not null

Le SGBD  rejettera alors toute tentative d'insérer
un nuplet dans *Internaute* sans donner de mot de passe.

.. important:: La clé primaire doit *toujours* être déclarée ``not null``.

Une autre manière de forcer un attribut à toujours prendre une valeur est  de
spécifier une *valeur par défaut* avec l'option ``default``. 

.. code-block:: sql

    create table Cinéma (id integer not null, 
                         nom varchar (30) not null ,
                         adresse varchar(255) default 'Inconnue',
                         primary key (id));
                         
Quand on insérera un nuplet dans la table *Cinéma* sans
indiquer d'adresse, le système affectera automatiquement
la valeur ``'Inconnue'``  à cet attribut. En général on utilise comme valeur par
défaut une constante, sauf pour quelques variables fournies par le système 
(par exemple ``sysdate``  pour indiquer la date courante). 


Contraintes
===========

La création d'une table telle qu'on l'a vue précédemment
est assez sommaire car elle n'indique que
le contenu de la table sans spécifier les contraintes
que doit respecter ce contenu. Or il y a *toujours*
des contraintes et il est indispensable de les inclure
dans le schéma pour assurer (dans la mesure du possible)
l'intégrité de la base.

Voici les  règles (ou *contraintes d'intégrité*) que l'on peut demander au système de garantir:

  * La valeur d'un attribut doit être unique 
    au sein de la table.
  * Un attribut doit toujours avoir une valeur.
    C'est la contrainte ``not null`` vue précédemment.
  * Un attribut (ou un ensemble d'attributs) constitue(nt)
    la clé de la table.
  * Un attribut dans une table est liée à la clé
    primaire d'une autre table (*intégrité référentielle*).
  * Enfin toute règle s'appliquant à la valeur
    d'un attribut (min et max par exemple).

Les contraintes sur les clés (unicité et intégrité référentielle) doivent être systématiquement
spécifiées. 

Clés d'une table
****************

Il
peut y avoir plusieurs clés dans une table (les clés "candidates") mais l'une d'entre elles
doit être choisie comme *clé primaire*.  Ce choix est important: la  clé primaire est 
la clé utilisée pour référencer un nuplet et un seul 
à partir d'autres tables. Il est donc très délicat de la remettre en cause après coup.
En revanche les clés secondaires peuvent être créées ou supprimées beaucoup plus facilement. 

La clé primaire est spécifiée avec l'option ``primary key``.

.. code-block:: sql

     create table Pays (code varchar(4) not null,
                        nom  varchar (30) not null,
                        langue varchar (30) not null,
                        primary key (code));

Il doit *toujours* y avoir une clé primaire
dans une table. Elle sert à garantir l'absence de doublon
et à désigner un nuplet de manière univoque. 
Une clé peut être constituée de plusieurs attributs:

.. code-block:: sql

     create table Notation (idFilm integer not null,
                            email  varchar (40) not null,
                            note  integer not null,
                            primary key (idFilm, email));

Tous les attributs figurant dans une clé doivent être déclarés
``not null``. Cela n'a pas de sens 
d'identifier des nuplets par des valeurs
absentes.

Comme nous l'avons déjà expliqué à plusieurs reprises, la méthode recommandée pour
gérer la clé primaire est d'utiliser un attribut ``id``, sans aucune signification
particulière autre que celle de contenir la valeur unique identifiant un nuplet.
Voici un exemple typique:

.. code-block:: sql

     create table Artiste (id integer not null,
                           nom varchar (30) not null,
                           prénom varchar (30) not null,
                           annéeNaiss integer,
                           primary key (id))

La valeur de cet identifiant peut même est automatiquement engendrée
à chaque insertion, ce qui soulage d'avoir à implanter un mécanisme
de génération d'identifiant. La méthode varie d'un système à l'autre, et
repose de manière générale sur la notion de *séquence*. Voici la syntaxe MySQL
pour indiquer qu'une clé est auto-incrémentée.

.. code-block:: sql

     create table Artiste (id integer not null auto increment,
                          ...,
                           primary key (id))

L'utilisation d'un identifiant artificiel n'apporte rien pour le contrôle
des redondances. Il est possible d'insérer des centaines de nuplets dans
la table *Artiste* ci-dessus ayant tous exactement les mêmes valeurs,
et ne différant que par la clé.

Les contraintes empêchant la redondance (et plus généralement assurant la
cohérence d'une base) sont spécifiées indépendamment de la clé 
par la clause ``unique``. On peut par exemple indiquer que deux
artistes distincts ne peuvent avoir les mêmes nom et prénom.

.. code-block:: sql

     create table Artiste  (idArtiste integer not null,
                           nom varchar (30) not null,
                           prénom varchar (30) not null,
                           annéeNaiss integer,
                           primary key (idArtiste),
                           unique (nom, prénom))

Il est facile de supprimer cette contrainte  (dite de "clé secondaire")
par la suite. Ce serait beaucoup plus difficile
si on avait utilisé la paire ``(nom, prénom)``
comme clé primaire puisqu'elle serait alors utilisée
pour référencer un artiste dans d'autres tables.

La clause ``unique`` ne s'applique pas aux valeurs
``null``.

Clés étrangères
===============

SQL permet d'indiquer quelles sont les
clés étrangères dans une table, autrement dit, quels sont les
attributs qui font référence à un nuplet dans une autre table.  On
peut spécifier les clés étrangères avec l'option ``foreign key``.

.. code-block:: sql

     create table Film  (idFilm integer not null, 
                        titre    varchar (50) not null,
                        année    integer not null,
                        idRéalisateur    integer not null,
                        genre varchar (20) not null,
                        résumé      varchar(255),
                        codePays    varchar (4),
                        primary key (idFilm),
                        foreign key (idRéalisateur) references Artiste(idArtiste),
                        foreign key (codePays) references Pays(code));
                        

La commande


.. code-block:: sql

    foreign key (idRéalisateur) references Artiste(idArtiste),

indique que ``idRéalisateur`` référence la clé primaire de 
la table  *Artiste*. Le SGBD vérifiera alors, pour toute
modification pouvant affecter le lien entre les deux tables,
que la valeur de ``idRéalisateur``  correspond bien à un nuplet de *Artiste*. Ces
modifications sont:

  * l'insertion dans *Film* avec une valeur inconnue pour ``idRéalisateur``;
  * la destruction d'un artiste;
  * la modification de ``id`` dans *Artiste* ou de ``idRéalisateur`` dans *Film*.

En d'autres termes on a la garantie que le lien entre *Film* et *Artiste* est *toujours* valide.
Cette contrainte est importante pour s'assurer qu'il n'y a pas de fausse référence dans la base,
par exemple qu'un film ne fait pas référence à un artiste qui n'existe pas. Il est beaucoup
plus confortable d'écrire une application par la suite quand on sait
que les informations sont bien là où elles doivent être.

Il faut noter que l'attribut ``codePays`` n'est pas
déclaré ``not null``, ce qui signifie que l'on
s'autorise à ne pas connaître le pays de production d'un 
film. Quand un attribut est à ``null``, la contrainte
d'intégrité référentielle ne s'applique pas. En revanche, on impose de connaître
le réalisateur d'un film. C'est une contrainte forte, qui d'un côté améliore
la richesse et la cohérence de la base, mais de l'autre empêche toute
insertion, même provisoire, d'un film dont le metteur en scène est inconnu. 
Ces deux situations correspondent respectivement aux associations 0..* et 1..*
dans la modélisation entité/association. 

.. note:: On peut facilement passer
   un attribut de ``not null`` à ``null``. L'inverse n'est pas vrai s'il existe
   déjà des valeurs à ``null`` dans la base.

Que se passe-t-il quand la violation d'une contrainte
d'intégrité est détectée par le système? Par défaut,
la mise à jour est rejetée, mais il est possible de demander
la répercussion de cette mise à jour de manière à ce
que la contrainte soit respectée. Les événements 
que l'on peut répercuter sont la modification
ou la destruction du nuplet référencé, et on les
désigne par ``on update`` et ``on delete``
respectivement. La répercussion elle-même consiste
soit à mettre la clé étrangère à ``null`` 
(option ``set null``), soit à appliquer la même
opération aux nuplets de l'entité composante (option ``cascade``).

Voici comment on indique que la destruction
d'un pays déclenche la mise à ``null``
de la clé étrangère ``codePays`` pour tous les films
de ce pays.


.. code-block:: sql

     create table Film  (idFilm integer not null, 
                        titre    varchar (50) not null,
                        année    integer not null,
                        idRéalisateur    integer not null,
                        genre varchar (20) not null,
                        résumé      varchar(255),
                        codePays    varchar (4),
                        primary key (idFilm),
                        foreign key (idRéalisateur) references Artiste(idArtiste),
                        foreign key (codePays) references Pays(code)
                           on delete set null)

Dans le cas d'une entité faible,  on décide en général de détruire le *composant*
quand on détruit le *composé*.  Par exemple, quand on détruit un cinéma, on veut également
détruire les salles; quand on modifie la clé d'un cinéma, on
veut répercuter la modification sur ses salles (la modification d'une clé est très déconseillée, 
mais malgré tout autorisée). Dans ce cas c'est l'option ``cascade``
qui s'impose.

.. code-block:: sql

     create table Salle  (idCinéma integer not null, 
                          noSalle    integer not null,
                          capacité    integer not null,
                          primary key (idCinéma, noSalle),
                          foreign key (idCinéma) references Cinéma(idCinéma)
                            on delete cascade,
                            on update cascade)

L'attribut  ``idCinema`` fait partie de la clé et ne
peut donc pas être ``null``. On ne pourrait
donc pas spécifier ici  ``on delete set null``.

La spécification des actions ``on delete`` et ``on update``
simplifie  la gestion de la base
par la suite: on n'a plus par exemple à se soucier de détruire
les salles quand on détruit un cinéma.


Quiz
====

.. eqt:: sch1-1

    Les ``varchar`` ont une taille limitée à 255 caractères. Quelle explication de cette limite
    vous semble la plus vraisemblable?
   
    A) :eqt:`I`  C'est un choix arbitraire de la norme.
    #) :eqt:`I`  Cela correspond à une contrainte physique d'écriture sur le disque
    #) :eqt:`C` Comme la taille est variable, il faut la stocker avec la chaîne, sur 1 octet (d'où :math:`2^{8}-1=255`  possibilités)

.. eqt:: sch1-2

    Quelle est la différence entre une clé primaire et une clé secondaire?
   
    A) :eqt:`I`  Aucune
    #) :eqt:`C`  La clé primaire est utilisée pour référencer un nuplet,  par une ou plusieurs clés étrangères
    #) :eqt:`I` La contrainte d'unicité s'applique à à la clé primaire, pas aux clés secondaires.


.. eqt:: sch1-4

    Soit deux tables ``R(A, B)``  et ``S(C, A)``. Dans ``S``, ``A`` est une clé étrangère (non nulle) vers ``R(A)``. Parmi
    les affirmations ci-dessous, laquelle est *vraie*?

   
    A) :eqt:`I`  Si l’association est de type plusieurs-plusieurs, alors S.A peut contenir une liste de valeurs de clés, celles des nuplets de R référencés
    #) :eqt:`C`  Si ``S.A`` est ``not null``, cela oblige chaque nuplet de ``S`` à être associé à un nuplet de ``R``
    #) :eqt:`I` Si ``S.A`` est ``null``, cela signifie qu’on autorise un nuplet de ``R`` à ne pas être référencé par un nuplet de ``S``.

.. eqt:: sch1-4

    Soit deux tables ``R(A, B)``  et ``S(C, A)``. Dans ``S``, ``A`` est une clé étrangère (non nulle) vers ``R(A)``. Parmi
    les affirmations ci-dessous, laquelle est *fausse*?
   
    A) :eqt:`C`  Si j'insère dans ``R``, je dois vérifier qu'il existe au moins un nuplet référençant dans ``S`` 
    #) :eqt:`I`  Si j'insère dans ``S``, je dois vérifier qu'il existe exactement un nuplet référencé  par ``S.A`` dans ``R`` 
    #) :eqt:`I` Si je détruis dans ``R``, je dois vérifier qu'il n'existe aucun nuplet référençant dans ``S`` 
    #) :eqt:`I`  Si je modifie ``A`` dans ``S``, je dois vérifier qu'il existe exactement un nuplet référencé  
       par la nouvelle valeur de ``S.A`` dans ``R`` 

.. eqt:: sch1-5

    Soit deux tables ``R(A, B)``  et ``S(C, A)``. Dans ``S``, ``A`` est une clé étrangère (non nulle) vers ``R(A)``. Les
    deux tables sont vides. Quelle affirmation est vraie?
   
    A) :eqt:`C`  Il faut insérer dans ``R`` *avant* d'insérer dans ``S`` 
    #) :eqt:`I`  Il faut insérer dans ``S`` *avant* d'insérer dans ``R`` 
    #) :eqt:`I` L'ordre des insertions est indifférent

***************
S2: Compléments
***************

.. admonition::  Supports complémentaires:

    Pas de vidéo pour cette session qui présente quelques commandes utilitaires.

La clause ``check``
===================

La clause ``check`` exprime des contraintes
portant soit sur un attribut, soit sur un nuplet. La condition
elle-même peut être toute expression suivant la clause ``where``
dans une requête SQL.  Les contraintes les plus courantes sont celles
consistant à restreindre un attribut à un ensemble de valeurs,
comme expliqué ci-dessous. On
peut trouver des contraintes arbitrairement complexes, faisant
référence à d'autres tables.

Voici un exemple simple qui restreint les valeurs
possibles des attributs ``année`` et ``genre`` dans la table
*Film*.


.. code-block:: sql

     create table Film  (idFilm integer not null, 
                        titre    varchar (50) not null,
                        année    integer 
                           check (année between 1890 and 2020) not null,
                        idRéalisateur    integer,
                        genre varchar (20) l
                              check (genre in ('Histoire','Western','Drame')) not null,
                        résumé      varchar(255),
                        codePays    varchar (4),
                        primary key (idFilm),
                        foreign key (idRéalisateur) references Artiste,
                        foreign key (codePays) references Pays)

Au moment d'une insertion dans la table *Film*, 
ou d'une modification de l'attribut ``année`` ou ``genre``,
le SGBD vérifie que la valeur insérée dans ``genre`` appartient
à l'ensemble énuméré défini par la clause ``check``.

Une autre manière de définir, dans la base,  l'ensemble des valeurs autorisées
pour un attribut -- en d'autres termes, une
codification imposée -- consiste à  placer ces valeurs
dans une table et  la lier à l'attribut
par une contrainte de clé étrangère. C'est
ce que nous pouvons faire par exemple
pour la table *Pays*.

.. code-block:: sql

     create table Pays (code    varchar(4) not null,
                        nom  varchar (30) default 'Inconnu' not null,
                       langue varchar (30) not null,
                       primary key (code));
      insert into Pays (code, nom, langue) values ('FR', 'France', 'Français');
      insert into Pays (code, nom, langue) values ('USA', 'Etats Unis', 'Anglais');
      insert into Pays (code, nom, langue) values ('IT', 'Italie', 'Italien');
      insert into Pays (code, nom, langue) values ('GB', 'Royaume-Uni', 'Anglais');
      insert into Pays (code, nom, langue) values ('DE', 'Allemagne', 'Allemand');
      insert into Pays (code, nom, langue) values ('JP', 'Japon', 'Japonais');

Si on ne fait pas de vérification automatique, soit avec 
``check``, soit avec la commande ``foreign key``, 
il faut faire cette vérification dans l'application,
ce qui est plus lourd à gérer.

Modification du schéma
======================

La création d'un schéma n'est qu'une première étape dans la vie
d'une base de données. On est toujours amené
par la suite à créer de nouvelles tables,
à ajouter des attributs ou à en modifier la définition.
La forme générale de la commande
permettant de modifier une table est:

.. code-block:: sql

     alter table <nomTable> <action> <description> 
     
où ``action`` peut être principalement ``add``, ``modify``, ``drop``
ou ``rename`` et ``description`` est la commande de modification associée à
``action``. La modification d'une table
peut poser des problèmes si elle est incompatible
avec le contenu existant. Par exemple passer
un attribut à ``not null`` implique
que cet attribut a déjà des valeurs pour tous
les nuplets de la table.

Modification des attributs
**************************

Voici quelques exemples d'ajout et de modification
d'attributs. 
On peut ajouter un attribut ``region``
à la table *Internaute* avec la commande:

.. code-block:: sql

    alter table Internaute add région varchar(10)

S'il existe déjà des données dans la table,
la valeur sera à ``null`` ou à la valeur par défaut.
La taille de ``région`` étant certainement insuffisante,
on peut l'agrandir avec ``modify``, et la
déclarer ``not null`` par la même occasion:

.. code-block:: sql
   
    alter table Internaute modify région varchar(30) not null
    
Il est également possible de diminuer la taille d'un attribut,
avec le risque d'une perte d'information pour les données
existantes. On peut même changer son type, pour passer
par exemple de ``varchar`` à ``integer``, avec
un résultat imprévisible.

La commande ``alter table`` permet d'ajouter une valeur par
défaut.
 
 
.. code-block:: sql
   
     alter table Internaute add région set default 'Corse'


Enfin, on peut détruire un attribut avec ``drop``.


.. code-block:: sql
   
     alter table Internaute drop région

De plus, chaque système propose des commandes non normalisées. MySQL par exemple dispose
d'une commande ``truncate`` pour "vider" une table rapidement, sans effectuer de contrôle (!) À vous
d'éplucher la documentation pour ces aspects spécifiques.

Création d'index
================

Pour compléter le schéma d'une table, on peut définir des
*index*. Un index offre un chemin d'accès 
aux nuplets d'une table qui est considérablement plus
rapide que le balayage de cette table -- du moins 
quand le nombre de nuplets est très élevé. 
Les SGBD créent systématiquement
un index sur la clé primaire de chaque table.
Il y a plusieurs raisons à cela;

  * l'index permet de vérifier rapidement, au moment 
    d'une insertion, que la clé n'existe pas déjà;
  * l'index permet également de vérifier rapidement
    la contrainte d'intégrité référentielle: la valeur
    d'une clé étrangère doit toujours être la valeur d'une clé primaire.
  * beaucoup de requêtes SQL, notamment
    celles qui impliquent plusieurs tables (*jointure*),
    se basent sur les clés des tables pour reconstruire
    les liens. L'index peut alors être utilisé
    pour améliorer les temps de réponse.


Un index est également créé pour chaque clause
``unique`` utilisée dans la création de la table.
On peut de plus créer d'autres index, sur un ou plusieurs
attributs, si l'application utilise
des critères de recherche autres que les clés
primaire ou secondaires.
 
La commande pour créer un index est  la suivante:

.. code-block:: sql

    create [unique] index <nomIndex>  on <nomTable> (<attribut1> [, ...])


L'option ``unique``  indique qu'on ne peut pas trouver
deux fois la même clé dans l'index. La commande ci-dessous
crée un index de nom *idxNom* sur les attributs
``nom`` et ``prénom`` de la table *Artiste*.
Cet index a donc une fonction équivalente à la clause 
``unique`` déjà utilisée dans la création de la table.

.. code-block:: sql

     create unique index idxNom  on Artiste (nom, prénom)

On peut créer un index, cette fois   non unique,
sur l'attribut ``genre`` de la table *Film*.


.. code-block:: sql
    
    create index idxGenre on Film (genre)


Cet index permettra d'exécuter très rapidement
des requêtes SQL ayant comme critère de recherche
le genre d'un film.


.. code-block:: sql
  
    select * from Film where genre = 'Western'


Cela dit il ne faut pas créer des index à tort et
à travers, car ils ont un impact négatif sur les
commandes d'insertion et de destruction. À chaque
fois, il faut en effet mettre à jour tous les index
portant sur la table, ce qui représente un coût certain.

Pour en savoir plus sur les index, et en général sur la gestion de l'organisation
des données, je vous renvoie à la seconde partie du cours disponible à
http://sys.bdpedia.fr.

************
S3: Les vues
************


.. admonition::  Supports complémentaires:

    * `Diapositives: les vues <http://sql.bdpedia.fr/files/slvues.pdf>`_
    * `Vidéo sur les vues <https://mediaserver.lecnam.net/videos/les-vues/>`_ 

Une requête SQL produit toujours une table. Cela suggère la possibilité
d'ajouter au schéma des tables *calculées*,  qui ne sont rien d'autre que le résultat
de requêtes stockées. De telles
tables sont nommées des *vues* dans la
terminologie relationnelle. On peut
interroger des vues comme des tables stockées
et, dans certaines limites, faire des mises à jour
des tables stockées au travers de vues.

Une vue n'induit aucun stockage puisqu'elle
n'existe pas physiquement. Elle permet
d'obtenir une représentation différente
des tables sur lesquelles elle est basée
avec deux grands avantages:
 
  - on peut faciliter l'interrogation
    de la base en fournissant sous forme
    de vues des requêtes prédéfinies;
  - on peut masquer certaines informations
    en créant des vues et en forçant
    par des droits d'accès l'utilisateur
    à passer par ces vues pour accéder à la base.

Les *vues* constituent donc un moyen complémentaire de contribuer
à la sécurité (par restriction d'accès)
et à la facilité d'utilisation (en offrant
une "schéma virtuel" simplifié). 


Création et interrogation d'une vue
===================================

Une vue est en tout point comparable à une table: en
particulier on peut l'interroger par SQL.
La grande différence est qu'une vue est 
le résultat d'une requête avec la
caractéristique essentielle que ce résultat 
est réévalué à chaque fois que l'on accède à la vue. 
En d'autres termes une vue est *dynamique*: elle donne
une représentation fidèle de la base au moment 
de l'évaluation de la requête.

Une vue est essentiellement une requête à laquelle 
on a donné un nom. La syntaxe de création d'une
vue est très simple:

.. code-block:: sql

      create view nomvue ([listeattributs])
      as          requete
      [with check option]


Voici une vue sur la
table *Immeuble* montrant
uniquement le Koudalou. 

.. code-block:: sql

   create view Koudalou as 
        select nom, adresse, count(*) as nb_apparts 
        from Immeuble as i, Appart as a 
        where i.nom='Koudalou'
        and i.id=a.idImmeuble
        group by i.id, nom, adresse

La destruction d'une vue a évidemment beaucoup
moins de conséquences que pour une table 
puisqu'on supprime uniquement la *définition*
de la vue pas son *contenu*. 

On interroge
la vue comme n'importe quelle table.

.. code-block:: sql

   select * from Koudalou

.. csv-table:: 
   :header: nom      , adresse       , nb_apparts
   :widths: 10, 10, 4

   Koudalou , 3 rue des Martyrs , 5

La vue fait maintenant partie du schéma. 
On
ne peut d'ailleurs évidemment pas créer
une vue avec le même nom qu'une table (ou vue)
existante. La définition d'une vue peut consister en un
requête SQL aussi complexe que nécessaire,
avec jointures, regroupements, tris.

Allons un peu plus loin en définissant sous forme de vues
un accès aux informations de notre base 
*Immeuble*, mais restreint uniquement
à tout ce qui concerne l'immeuble Koudalou. On
va en profiter pour offrir dans ces
vues un accès plus facile à l'information.
La vue sur les appartements, par exemple, 
va contenir contrairement
à la table *Appart* le nom
et l'adresse de l'immeuble et le nom de son occupant.

.. code-block:: sql

    create or replace view AppartKoudalou as 
       select no, surface, niveau, i.nom as immeuble, adresse,
              concat(p.prénom,  ' ', p.nom) as occupant 
       from Immeuble as i, Appart as a, Personne as p
       where i.id=a.idImmeuble
       and   a.id=p.idAppart
       and   i.id=1 

On voit bien sur cet exemple que l'un des intérêts des vues est de donner une représentation
"dénormalisée" de la base en regroupant des
informations par des jointures. Le contenu
étant virtuel, il n'y a ici aucun inconvénient
à "voir" la redondance du nom de l'immeuble
et de son adresse. Le bénéfice, en revanche,
est la possibilité d'obtenir très simplement
toutes les informations utiles.

.. code-block:: sql

   select * from AppartKoudalou

..  csv-table::
    :header: no, surface, niveau, immeuble, adresse, occupant

    1   , 150   , 14    , Koudalou  , 3 rue des Martyrs , Léonie Atchoum
    51  , 200   , 2 , Koudalou  , 3 rue des Martyrs , Barnabé Simplet
    52  , 50    , 5 , Koudalou  , 3 rue des Martyrs , Alice Grincheux
    43  , 75    , 3 , Koudalou  , 3 rue des Martyrs , Brandon Timide


Le nom des attributs de la vue est celui des
expressions de la requête associée. On peut
également donner ces noms après le ``create view``
à condition qu'il y ait correspondance univoque
entre un nom et une expression du ``select``. 
On peut ensuite donner des droits en lecture sur cette
vue pour que cette information limitée soit
disponible à tous.

.. code-block:: sql

   grant select on Immeuble.Koudalou, Immeuble.AppartKoudalou to adminKoudalou

Pour peu que cet utilisateur n'ait aucun droit
de lecture sur les tables de la base *Immeuble*,
on obtient un moyen simple de masquer et
restructurer l'information.

Mise à jour d'une vue
=====================

L'idée de modifier une vue peut sembler
étrange puisqu'une vue n'a pas de contenu. En fait
il s'agit bien entendu de modifier la table qui
sert de support à la vue. Il existe de sévères
restrictions sur les droits d'insérer ou de mettre à jour 
des tables au travers des vues. Un exemple suffit pour comprendre
le problème. Imaginons que l'on souhaite insérer
un nuplet dans la vue ``AppartKoudalou``.

.. code-block:: sql

     insert into AppartKoudalou (no, surface, niveau, immeuble, adresse, occupant) 
     values (1, 12, 4, 'Globe', '2 Avenue Leclerc', 'Palamède')

Le système rejettera cette requête (par exemple, pour MySQL,  avec le message 
``Can not modify more than one base table 
through a join view 'Immeuble.AppartKoudalou'``).
Cet ordre s'adresse à une vue issue de trois tables. Il
n'y a clairement pas assez d'information pour alimenter
ces tables de manière cohérente et l'insertion
n'est pas possible (de même que toute
mise à jour). De telles vues sont dites
*non modifiables*. Les règles définissant les vues modifiables
sont assez strictes et difficiles à résumer
simplement d'autant qu'elles varient
selon l'opération (``update``,
``delete``, ou ``insert``). En première approximation 
on peut retenir les points suivants
qui donnent lieu à quelques exceptions sur
lesquelles nous reviendrons ensuite.
 

  - la vue doit être basée sur une seule table;
  - toute colonne non référencée
    dans la vue doit pouvoir être mise à 
    ``null`` ou disposer d'une valeur par défaut;
  - on ne peut pas mettre à jour un attribut
    qui résulte d'un calcul ou d'une opération.

On ne peut donc pas insérer ou modifier la
vue *Koudalou* à cause de la jointure et
de l'attribut calculé. La requête suivante serait rejetée.

.. code-block:: sql

     insert into Koudalou (nom, adresse) 
     values ('Globe', '2 Avenue Leclerc')


En revanche une vue portant sur une seule table
avec un ``select *`` est modifiable.

.. code-block:: sql

    create view PropriétaireAlice 
       as select * from Propriétaire 
      where idPersonne=2

    insert into PropriétaireAlice values (2, 100, 20)
    insert into PropriétaireAlice values (3, 100, 20)


Maintenant, si on fait:

.. code-block:: sql 
      
      select * from PropriétaireAlice

On obtient:

.. csv-table:: 
   :header:  idPersonne , idAppart, quotePart
   :widths: 4, 4, 4

   2           , 100       , 20         
   2           , 103       , 100


L'insertion précédente illustre une petite subtilité:
on peut insérer dans une vue sans être en mesure
de voir le nuplet inséré au travers de la vue
par la suite! On a en effet inséré
dans la vue le propriétaire 3 qui 
est ensuite filtré quand on interroge la vue.

SQL propose l'option  ``with check option`` qui
permet de garantir que tout nuplet inséré
dans la vue satisfait les critères de sélection
de la vue.

.. code-block:: sql

   create view PropriétaireAlice 
   as select * from Propriétaire 
   where idPersonne=2 
   with check option


SQL permet également la modification
de vues définies par des jointures. Les restrictions
sont essentielement les même que pour les vues
mono-tabulaires: on ne peut insérer que
dans une des tables (il faut donc
préciser la liste des attributs) et 
tous les attributs ``not null`` doivent 
avoir une valeur. Voici un exemple
de vue modifiable basée sur une jointure.
 

.. code-block:: sql

   create or replace view ToutKoudalou
   as select i.id as id_imm, nom, adresse, a.* 
      from Immeuble as i, Appart as a 
      where i.nom='oudalou'
      and i.id=a.idImmeuble
      with check option


Il est alors possible d'insérer à condition d'indiquer
des attributs d'une seule des deux tables. La
commande ci-dessous ajoute un nouvel appartement
au *Koudalou*.

.. code-block:: sql

     insert into ToutKoudalou (id, surface, niveau, idImmeuble, no)
     values (104, 70, 12, 1, 65)

En conclusion, l'intérêt principal des vues
est de permettre une restructuration du schéma
en vue d'interroger et/ou de protéger des données.
L'utilisation de vues pour des mises à jour
devrait rester marginale. 


Quiz
====

.. eqt:: sch3-1

    Comment définiriez-vous la notion de vue?
   
    A) :eqt:`I`  C'est un moyen de pré-calculer un résultat
    #) :eqt:`I`  C'est un moyen de créer une deuxième base dérivée de la première par exécution de requêtes SQL
    #) :eqt:`C` C'est un moyen de pré-définir des requêtes

.. eqt:: sch3-2

    Quelles restrictions s'appliquent à l'interrogation d'une vue?
   
    A) :eqt:`I`  On ne peut pas effectuer de jointure entre une vue et une table
    #) :eqt:`C`  Aucune
    #) :eqt:`I` On ne peut pas créer de vue sur une autre vue

    
.. eqt:: sch3-3

    À votre avis, que fait le système quand on interroge une vue avec une requête ``Q``?
   
    A) :eqt:`I`  Il calcule le contenu de la vue, et applique ``Q`` à ce contenu
    #) :eqt:`C`  Il remplace le nom de la vue dans ``Q`` par la définition de la vue: on obtient une requête SQL correcte
    #) :eqt:`I` Il exécute ``Q`` et applique la définition de la vue au résultat de ``Q`` 
    

.. eqt:: sch3-4

   Voici une vue sur les logements corses
   
   .. code-block:: sql

      create view LogementCorse as
      select *
      from Logement
      where lieu='Corse'

   Est-il possible à votre avis d’effectuer l’insertion suivante dans la vue ?
   
   .. code-block:: sql

      insert into LogementCorse (code, nom, capacité, type, lieu)
      values     ('ta', 'Tabriz', 34, 'Hôtel', 'Bretagne') ;

   Réponses:
   
   A) :eqt:`I`  Oui, car ce nuplet va être stocké dans la vue, pas dans la table Logement, et il sera donc possible de le retrouver en interrogeant la vue.
   #) :eqt:`I`  Non, pour des raisons de cohérence : en interrogeant la vue, on ne peut pas retrouver un logement en Bretagne !
   #) :eqt:`C` Oui, car aucune des restrictions mentionnées dans le cours ne s’applique  

.. eqt:: sch3-5

    Quelle est l'utilité de la clause ``check option`` 
   
    A) :eqt:`C`  On vérifie que tout ce qui est inséré dans la vue peut être lu dans la vue
    #) :eqt:`I`  On vérifie les droits d'accès de l'utilisateur avant toute mise à jour
    #) :eqt:`I` On vérifie que la syntaxe de la requête SQL définissant la vue est correcte

    


*********
Exercices
*********


.. _Ex-schema-1:
.. admonition:: Exercice `Ex-schema-1`_: le schéma du centre médical

    Reprenons le  centre médical étudié dans le chapitre :ref:`chap-ea`.
    
       - Donnez les commandes SQL de création du schéma 
       - Donnez les commandes d'insertion pour une base avec un médecin (le Dr Folamour),
         un patient (M. Maboul), un médicament (le libellé est Trucmyl) et une consultation
         ayant donné lieu a la prescription de 3 prises de Trucmyl par le Dr Folamour 
         à M. Maboul. Choisissez les identifiants à votre convenance.
       - Créez une vue ``DrFolamour`` donnant pour toutes les prescriptions du Dr Folamour 
         le nom du patient, le libellé du médicament et le nombre de prises 
       
    .. ifconfig:: schemas in ('public')

      .. admonition:: Correction
      
         Voici les commandes SQL. Note: le point-virgule est un séparateur de commandes, à utiliser
         quand on soumet plusieurs commandes à un système.
         
           .. code-block:: sql
           
               create table Médecin (matricule varchar not null,
                                     nom varchar not null,
                                     primary key (matricule)
                                     );
               create table Patient (noSS varchar not null,
                                     nom varchar not null,
                                     primary key (noSS)
                                     );
               create table Médicament (code varchar not null,
                                     libellé varchar not null,
                                     primary key (code)
                                     );
               create table Consultation (no integer  not null,
                                     matricule varchar not null,
                                     noSS  varchar not null,
                                     primary key (no),
                                     foreign key (matricule) references Médecin(matricule),
                                     foreign key (noSS) references Patient(noSS)
                                     );
              create table Prescription (codeMédicament varchar not null,
                                     noConsultation integer not null,
                                     nbPrises integer not null,
                                     primary key (codeMédicament, noConsultation),
                                     foreign key (codeMédicament) references Médicament(code),
                                     foreign key (noConsultation) references Consultation(no)
                                     );
              
               insert into Médecin (matricule, nom) values ('xx', 'Folamour');
               insert into Patient (noSS, nom) values ('1983778', 'Maboul');
               insert into Médicament (code, libellé) values ('tm', 'Trucmyl');
               insert into Consultation (no, matricule, noSS) values (1, 'xx', '1983778');
               insert into Prescription (codeMédicament, noConsultation, nbPrises) values ('tm', 1, 3);
                                     
               create view DrFolamour as
                select p.nom as nomPatient, m.libellé as médicament, p.nbPrises as nbPrises
                from Médecin as doc, Patient as pat, Médicament as medoc, 
                          Consultation as cons, Prescription as pres
                where doc.nom='Folamour'
                and   cons.matricule = doc.matricule
                and   pat.noSS = cons.noSS
                and   cons.no = pres.noConsultation
                and   pres.codeMédicament = medoc.code

.. _Ex-schema-2:
.. admonition:: Exercice `Ex-schema-2`_: pour pratiquer

    Donnez les commandes SQL de création du schéma pour le quotidien et la médiathèque.




*****************************************
Atelier: étude du cas "Zoo", suite et fin
*****************************************

Allons-y pour la création de la base (normalisée) de notre zoo.

  
  - Donner les commandes de création des tables, avec clés primaire et clés étrangères.
  - Ajoutez la contrainte suivante: deux animaux de la même espéce ne doivent pa avoir le même nom
  - Reprendre le contenu de la table non-normalisée (ci-dessous), et donner les commandes
    d'insertion de ces données dans la base normalisée
  - Exprimez les requêtes suivantes
     
      - Quels sont les ours du zoo?
      - Quels animaux s'appellent Jojo?
      - Quels animaux viennent de la planète Kashyyyk (quand ils ne sont pas prisonniers dans le zoo...)?
      - De quels animaux s'occupe le gardien Jules?
      - Sur quel(s) emplacement(s) y-a-il des animaux de  classes différentes (donner aussi le nom du gardien)
      - Somme des salaires des gardiens.
      - Quels gardiens surveillent plus d'un emplacement

  - Et pour finir, donnez la définition de la vue qui recrée, à partir de la base normalisée,
    le contenu de la table avant décomposition (ci-dessous). 

.. csv-table:: 
    :header: "codeAnimal",  "nom", "espèce", "gardien", "salaire", "classe", "origine", "codeEmplacement", "surface"
    :widths: 7, 7, 7, 7, 7, 7, 7, 7, 4
  
      10 , Zoé , Girafe , Marcel , 20 000 , Mammifère , Afrique , A, 120
      20 , Chewbacca , Wookiee , Marcel , 20 000 ,  , Kashyyyk , C, 200
      30 , Jojo , Mérou  , Jules , 18 000 , Poisson , Méditerranée , B, 50
      20 , Irma , Perroquet , Marcel , 20 000 , Oiseau , Asie , A, 120
      40 ,  Goupil , Renard , Jules , 18 000 , Insecte , Europe , B, 50

À vous de jouer !

    .. ifconfig:: schemas in ('public')

      .. admonition:: Correction
      
          Voici la création des tables
         
          .. code-block:: sql

            create table Gardien (id  integer not null,
                  prénom          varchar (10),
                  salaire         number(10,2) not null,
                  primary key (id));

            create table Emplacement (code  integer not null,
                  surface         integer not null,
                  idGardien     integer not null,
                  primary key (code),
                  foreign key (idGardien) references Gardien);

            create table Espèce (espèce     varchar(10) not null,      
                  classe          varchar (10),
                  origine         varchar (10) not null,
                  primary key (espèce));

            create table Animal (code  integer not null,
                     nom     varchar(30) not null,
                     annéeNaissance integer not null,
                  espèce          varchar(10) not null,
                  codeEmplacement    integer not null ,
                primary key  (code),
                foreign key (espèce) references Espèce(espèce),
                foreign key (codeEmplacement) references Emplacement(code),
                unique (nom, espèce));
                
          La requête SQL la plus difficile:
         
          .. code-block:: sql
          
               select e.code as codeEmplacement, e.surface as surface, g.nom as nomGardien
               from   Animal as a1, Animal as a2, Emplacement as e,
                     Espece as es1, Espece as es2, Gardien as g
               where     a1.codeEmplacement = a2.codeEmplacement
               and       a1.espèce = es1.espèce
               and       a2.espèce = es2.espèce
               and       not (es1.classe = es2.classe)
               and       e.code = a1.codeEmplacement
               and       e.idGardien = g.id
