.. _sql:

##################
SQL, récapitulatif
##################

Ce chapitre présente les compléments du langage d'interrogation SQL (la
partie dite *Langage de Manipulation de Données* ou LMD) dans le cadre d'un récapitulatif. 
Ces compléments
présentent peu de difficulté dans la mesure où la véritable complexité
réside d'une part dans l'interprétation des requêtes complexes qui font parfois
appel à des logiques sophistiquées et d'autre part dans la multiplicité des variantes
syntaxiques qui peut parfois troubler. 

Les deux chapitres précédents devraient
avoir réglé ces problèmes d'interprétation. Vous savez maintenant que SQL 
propose deux paradigmes d'interrogation, l'un déclaratif et l'autre procédural. 
Les requêtes se comprennent soit via leur équivalent en formules logiques, soit 
en les considérant comme des opérations ensemblistes. 

Dans ce chapitre nous utilisons systématiquement l'approche déclarative. Vous pouvez
les reformuler sous leur forme ensembliste si vous le souhaitez. 

La base prise comme exemple dans ce chapitre est celle des immeubles.

*********************************
S1: le bloc ``select-from-where``
*********************************

.. admonition::  Supports complémentaires:

    * `Diapositives: le bloc `select-from-where <http://sql.bdpedia.fr/files/slblocsql.pdf>`_
    * `Vidéo sur le bloc `select-from-where <https://mediaserver.cnam.fr/videos/le-bloc-select-from-where/>`_ 

Dans cette session, nous étudions les compléments à la forme de base d'une requête SQL, 
que nous appelons *bloc*, résumée
ainsi:

.. code-block:: sql

      select liste_expressions
      from   relations_sources
      [where liste_conditions]
      [order by critère_de_tri]

Parmi les quatre clauses ``select``, ``form``, ``where`` et ``order by``, les deux dernières
sont optionnelles.  La recherche la plus simple consiste à récupérer
le contenu complet d'une table. On n'utilise
pas la clause ``where`` et le \* désigne tous les attributs.

.. code-block:: sql

   select * from Immeuble

.. csv-table:: 
   :header: id, nom, adresse
   :widths: 4, 4, 4

   1 , Koudalou , 3 rue des Martyrs 
   2 , Barabas , 2 allée du Grand Turc 

L'ordre des trois clauses ``select``
``from`` et ``where`` est trompeur pour 
la signification d'une requête. Comme nous l'avons déjà détaillé dans
les chapitres qui précédent l'inteprétation
s'effectue *toujours* de la manière suivante:

  - la clause ``from`` définit l'espace
    de recherche en fonction d'un ensemble
    de sources de données;
  - la clause ``where``  exprime un
    ensemble de conditions sur la source:
    seuls les nuplets pour lesquels ces
    conditions sont satisfaites sont conservés;
  - enfin la clause ``select`` construit un nuplet-résultat grâce à
    une liste d'expressions appliquées aux nuplets de la source 
    ayant passé le filtre du ``where``.


La clause ``from``
==================

L'espace de recherche est défini dans la clause ``from``
par une ou plusieurs tables.
Par "table" il ne faut pas ici comprendre
forcément "une des tables de la base" courante
même si c'est le cas le plus souvent rencontré.
SQL est beaucoup général que cela: une table
dans un ``from`` peut également être  *résultat*
d'une autre requête. On parlera de table 
*basée* et de table *calculée* pour distinguer 
ces deux cas.  Ce peut également être une table stockée  dans une
autre base ou une table calculée à partir de
tables basées dans plusieurs bases ou une combinaison
de tout cela. 

Voici une première requête qui
ramène les immeubles dont l'id
vaut 1. 

.. code-block:: sql

     select nom, adresse 
     from Immeuble 
     where id=1
     
Il n'aura pas échappé au lecteur attentif
que le résultat est lui-même une table (calculée et non basée). Pourquoi
ne pourrait-on pas interroger cette table
calculée comme une autre? C'est possible
en SQL comme le montre l'exemple suivant:

.. code-block:: sql

       select * 
       from (select nom, adresse from Immeuble where id=1) as Koudalou

On a donc placé une requête SQL dans le ``from``
où elle définit un espace de recherche constitué de
son propre résultat.  Le mot-clé ``as`` permet
de donner un nom temporaire au résultat. En d'autres
termes ``Koudalou`` est le nom de la table
calculée sur laquelle s'effectue la requête. 
Cette table temporaire n'existe que pendant l'exécution.

.. note:: Comme nous l'avons vu, cette approche est de nature algébrique: on manipule
   dans le ``from`` des ensembles, stockés (les tables) ou calculés (obtenus
   par des requêtes). C'est une syntaxe en plus pour dire la même
   chose, donc on peut très bien se passer de la seconde formulation. Il est plus
   intéressant de prolonger cette idée d'interroger une relation *calculée*
   en donnant définivement un nom à la requête 
   qui sélectionne l'immeuble. En SQL cela s'appelle une *vue*. 
   On crée une vue dans un schéma avec la commande ``create view``.

   .. code-block:: sql

         create view Koudalou as 
            select nom, adresse from Immeuble where id=1

   Une fois créée une vue peut être utilisée comme
   espace de recherche exactement comme une table basée. Le fait que son contenu soit calculé 
   reste transparent pour l'utilisateur.

   .. code-block:: sql

         select nom, adresse from Koudalou

   Les vues sont traitées en détail dans le chapitre consacré aux schémas relationnels.

L'interprétation du ``from`` est indépendante  de l'origine
des tables: tables basées, tables calculées, et vues. Comme nous l'avons
vu dans les chapitres précédents, il existe deux manières de spécifier
l'espace de recherche avec le ``from``. La première est la forme
déclarative dans laquelle on sépare le nom des tables par des virgules.

.. code-block:: sql

      select * from Immeuble as i, Appart as a

Dans ce cas, le nom d'une table sert à définir une variable nuplet (voir chapitre :ref:`chap-calcul`)
à laquelle on peut affecter tous les nuplets de la table. Les variables peuvent être
explicitement nommées avec la mot-clé ``as`` (elles s'appellent ``i`` et ``a`` dans la requête ci-dessus).
On peut aussi omettre le ``as``, dans ce cas le nom de la variable est (implcitement) le nom de la table.

.. code-block:: sql

      select * from Immeuble, Appart
      
Un cas où le ``as`` est obligatoire est l'auto-jointure: on veut désigner deux nuplets de la même table.
Exemple: on veut les paires d'appartement du même immeuble.

.. code-block:: sql

      select a1.no, a2.no
      from Appart as a1, Appart as a2
      where a1.idImmeuble = a2.idImmeuble

En l'absence du ``as`` et de l'utilisation du nom de la variable comme préfixe,
il y aurait ambiguité sur le nom des attributs.

La deuxième forme du ``from`` définit l'espace de recherche par une 
opération algébrique, jointure ou produit cartésien.


.. code-block:: sql

      select * from Immeuble cross join Appart

Cette formulation revient à définir une table virtuelle (appelons-là *Tfrom*) qui tient
lieu d'espace de recherche par la suite. L'affichage ci-dessus nous montre quel est l'espace
de recherche *Tfrom* de la requête précédente.

.. csv-table:: 
   :header:  id , nom      , adresse       , id  , surface , niveau , idImmeuble , no
   :widths: 4, 7, 15, 4, 4, 4, 4, 4

   1  , Koudalou , 3 rue des Martyrs , 100 , 150     , 14    , 1           , 1  
   2  , Barabas  , 2 allée du Grand Turc , 100 , 150     , 14    , 1           , 1  
   1  , Koudalou , 3 rue des Martyrs , 101 , 50      , 15    , 1           , 34 
   2  , Barabas  , 2 allée du Grand Turc , 101 , 50      , 15    , 1           , 34  
   1  , Koudalou , 3 rue des Martyrs , 102 , 200     , 2     , 1           , 51 
   2  , Barabas  , 2 allée du Grand Turc , 102 , 200     , 2     , 1           , 51 
   1  , Koudalou , 3 rue des Martyrs , 103 , 50      , 5     , 1           , 52 
   2  , Barabas  , 2 allée du Grand Turc ,  104 ,  75 , 3  , 1, 43
   1  , Koudalou , 3 rue des Martyrs , 104 ,  75 , 3  , 1, 43
   2  , Barabas  , 2 allée du Grand Turc , 103 , 50      , 5     , 1           , 52 
   1  , Koudalou , 3 rue des Martyrs , 200 , 150 , 0 , 2, 1
   2  , Barabas  , 2 allée du Grand Turc , 200 , 150 , 0 , 2, 1
   1  , Koudalou , 3 rue des Martyrs , 201 , 250     , 1     , 2           , 1  
   2  , Barabas  , 2 allée du Grand Turc , 201 , 250     , 1     , 2           , 1  
   1  , Koudalou , 3 rue des Martyrs , 202 , 250     , 2     , 2           , 2  
   2  , Barabas  , 2 allée du Grand Turc , 202 , 250     , 2     , 2           , 2

La clause de jointure ``join`` définit un espace
de recherche constitué des paires de nuplets pour
lesquels la condition de jointure est vraie.

.. code-block:: sql

     select * 
     from Immeuble join Appart on (Immeuble.id=Appart.idImmeuble)

On obtient le résultat suivant.

.. csv-table:: 
   :header:  id , nom      , adresse       , id  , surface , niveau , idImmeuble , no
   :widths: 4, 10, 10, 4, 4, 4, 4, 4

   1  , Koudalou , 3 rue des Martyrs , 100 , 150     , 14    , 1           , 1  
   1  , Koudalou , 3 rue des Martyrs , 101 , 50      , 15    , 1           , 34 
   1  , Koudalou , 3 rue des Martyrs , 102 , 200     , 2     , 1           , 51 
   1  , Koudalou , 3 rue des Martyrs , 103 , 50      , 5     , 1           , 52 
   1  , Koudalou , 3 rue des Martyrs , 104 ,  75 , 3  , 1, 43
   2  , Barabas  , 2 allée du Grand Turc , 200 , 150 , 0 , 2, 1
   2  , Barabas  , 2 allée du Grand Turc , 201 , 250     , 1     , 2           , 1  
   2  , Barabas  , 2 allée du Grand Turc , 202 , 250     , 2     , 2           , 2


Dernière précision au sujet du ``from``: l'ordre dans 
lequel on énumère les  tables n'a aucune importance.

La clause ``where``
===================

La clause ``where`` permet d'exprimer des conditions portant
sur les nuplets désignés par la clause ``from``.
Ces conditions suivent
en général la syntaxe ``expr1 [not]`` :math:`\Theta` ``expr2``, 
où ``expr1`` et ``expr2`` sont deux expressions
construites à partir de noms d'attributs, de constantes et
de fonctions,  et :math:`\Theta` est l'un des opérateurs
de comparaison classique *<* *>* *<=* *>=* *!=*.

Les conditions se combinent avec les connecteurs
booléens ``and`` ``or`` et ``not``.
SQL propose également un prédicat ``in``
qui teste l'appartenance d'une valeur
à un ensemble. Il s'agit (du moins
tant qu'on n'utilise pas
les requêtes imbriquées) d'une facilité d'écriture
pour remplacer le ``or``. La requête

.. code-block:: sql

    select * 
    from Personne 
    where profession='Acteur' 
    or profession='Rentier'

s'écrit de manière équivalente avec un ``in`` comme
suit:

.. code-block:: sql

    select * 
    from Personne
    where profession in ('Acteur', 'Rentier')

.. csv-table:: 
   :header: id , prénom  , nom    , profession , idAppart
   :widths: 4, 10, 10, 10, 4

   4  , Barnabé , Simplet , Acteur     , 102       
   5  , Alphonsine    , Joyeux  , Rentier    , 201


Pour les chaînes de caractères, SQL propose l'opérateur
de comparaison  ``like``, avec deux
caractères de substitution:

  - le "%" remplace n'importe quelle sous-chaîne;
  -  le "_" remplace n'importe quel caractère.


L'expression ``_ou%ou`` est donc interprétée par
le ``like`` comme toute chaîne commençant
par un caractère suivi de "ou" suivi de n'importe
quelle chaîne suivie une nouvelle fois de "ou".
 
.. code-block:: sql

   select * 
   from Immeuble 
   where nom like '_ou%ou'

.. csv-table:: 
   :header: id , nom      , adresse
   :widths: 4, 10, 15

   1  , Koudalou , 3 rue des Martyrs


Il est également possible d'exprimer des conditions
sur des tables calculées par d'autre requêtes
SQL incluses dans la clause ``where``
et habituellement désignées par
le terme de "requêtes imbriquées".
On pourra par exemple demander la liste
des personnes dont l'appartement fait partie
de la table calculée des appartements
situés au-dessus du troisième niveau.

.. code-block:: sql

    select * from Personne
    where idAppart in (select id from Appart where niveau > 3)

..  csv-table::
    :header: id, prénom, nom, profession, idAppart

    2   , Alice , Grincheux , Cadre , 103
    3   , Léonie    , Atchoum   , Stagiaire , 100
    

Avec les requêtes imbriquées on entre dans le monde
incertain des requêtes qui semblent claires
mais finissent par ne plus l'être du tout. La
difficulté vient souvent du fait qu'il faut raisonner
simultanément sur plusieurs requêtes qui,
de plus, sont souvent interdépendantes
(les données sélectionnées dans l'une servent de
paramètre à l'autre). Il est très souvent possible
d'éviter les requêtes imbriquées comme nous l'expliquons
dans ce chapitre.

Valeurs manquantes: le ``null``
===============================

En théorie, dans une table relationnelle, tous les attributs ont une valeur.
En pratique, certaines valeurs peuvent être inconnues ou manquantes: on dit qu'elles
sont à ``null``. Le ``null`` *n'est pas une valeur spéciale*, c'est
une absence de valeur. 

.. note:: Les valeurs à ``null`` sont une source de problème, car elles rendent
   parfois le résultat des requêtes difficile à comprendre. Mieux vaut les éviter si c'est possible.

Il est impossible de déterminer quoi que ce
soit à partir d'une valeur à ``null``. Dans le cas
des comparaisons, la présence d'un ``null``
renvoie un résultat qui n'est ni ``true``
ni ``false`` mais ``unknown``, 
une valeur booléenne intermédiaire. Reprenons
à nouveau la table *Personne* avec un 
des prénoms à ``null``. La requête
suivante devrait ramener tous les nuplets.

.. code-block:: sql

   select * 
   from Personne
   where prénom like '%'

Mais la présence d'un ``null`` empêche 
l'inclusion du nuplet correspondant dans le
résultat.


.. csv-table:: 
   :header:  id , prénom , nom  , profession , idAppart  
   :widths: 4, 10, 10, 10, 4
   
   2 , Alice , Grincheux  , Cadre , 103
   3 , Léonie  , Atchoum , Stagiaire , 100
   4 , Barnabé , Simplet  , Acteur , 102  
   5 , Alphonsine , Joyeux  , Rentier , 201  
   6 , Brandon , Timide  , Rentier , 104  
   7 , Don-Jean , Dormeur  , Musicien , 200  

Cependant la condition ``like``
n'a pas été évaluée à ``false`` comme
le montre la requête suivante.

.. code-block:: sql

    select  *
    from Personne
    where prénom not like  '%'

On obtient un résultat vide, ce qui  montre  bien que le ``like`` appliqué à un 
``null`` ne renvoie pas ``false``
(car sinon on aurait ``not false = true``).
C'est d'ailleurs tout à fait normal 
puisqu'il n'y a aucune raison de dire
qu'une absence de valeur ressemble à n'importe
quelle chaîne.

Les tables de vérité de la logique trivaluée de SQL 
sont définies de la manière suivante. Tout d'abord
on affecte une valeur aux trois constantes logiques:

  - ``true`` vaut 1
  - ``false`` vaut 0
  - ``unknown`` vaut 0.5

Les connecteurs booléens s'interprètent alors ainsi:

  - ``val1 and val2``, = min(val1 val2)
  - ``val1 or val2`` = max(val1, val2)
  - ``not val1`` =  1 - val1.

On peut vérifier notamment que ``not unknown``
vaut toujours ``unknown``. Ces définitions
sont claires et cohérentes. Cela étant
il faut mieux prévenir de mauvaises surprises
avec les valeurs à ``null``, soit
en les interdisant à la création de la table
avec les options ``not null`` ou
``default``, soit en utilisant le
test ``is null`` (ou son complément
``is not null``). La requête
ci-dessous ramène tous les nuplets de la table, 
même en présence de ``null``.

.. code-block:: sql

   select *
   from Personne
   where prénom like '%' 
   or prénom is null


.. csv-table:: 
   :header:  id , prénom , nom  , profession , idAppart  
   :widths: 4, 10, 10, 10, 4
   
   1 ,  , Prof ,  Enseignant , 202
   2 , Alice , Grincheux  , Cadre , 103
   3 , Léonie  , Atchoum , Stagiaire , 100
   4 , Barnabé , Simplet  , Acteur , 102  
   5 , Alphonsine , Joyeux  , Rentier , 201  
   6 , Brandon , Timide  , Rentier , 104  
   7 , Don-Jean , Dormeur  , Musicien , 200  


Attention le test ``valeur = null`` n'a pas
de sens. On ne peut pas être égal à une absence de valeur.


La clause ``select``
====================

Finalement, une fois obtenus les nuplets du ``from``
qui satisfont le ``where`` on crée à
partir de ces nuplets le résultat final
avec les expressions du ``select``.


Si on indique explicitement les attributs
au lieu d'utiliser \*, leur nombre détermine
le nombre de colonnes de la table calculée. Le nom
de chaque attribut dans cette table est par défaut
l'expression du ``select`` mais on peut indiquer explicitement ce nom
avec ``as``. Voici un exemple qui
illustre également une fonction assez utile, la concaténation de chaînes.

.. code-block:: sql

   select concat(prénom, ' ', nom) as 'nomComplet'
   from Personne

..  csv-table::
    :header: nomComplet

    null
    Alice Grincheux
    Léonie Atchoum
    Barnabé Simplet
    Alphonsine Joyeux
    Brandon Timide
    Don-Jean Dormeur
.. note:: La fonction ``concat()`` ici utilisée est spécifique à MySQL. 

Le résultat montre que l'une des valeurs est à ``null``. 
Logiquement toute opération appliquée à un ``null`` renvoie un
``null`` en sortie puisqu'on ne peut calculer
aucun résultat à partir d'une  valeur inconnue. Ici 
c'est le prénom de l'une des personnes qui manque.
La concaténation du prénom
avec le nom est une opération qui "propage" cette
valeur à ``null``. Dans ce cas, il faut utiliser une fonction
(spécifique à chaque système)à qui remplace la valeur à ``null`` par une valeur
de remplacement.
Voici la version MySQL (fonction ``ifnull(attribut, remplacement)``).

.. code-block:: sql

    select concat(ifnull(prénom,' '), ' ', nom) as 'nomComplet'
    from Personne

Une "expression" dans la clause ``select`` désigne ici, comme
dans tout langage, une construction syntaxique 
qui prend une ou plusieurs valeurs en entrée
et produit une valeur en sortie. Dans sa
forme la plus simple,
une expression est simplement un nom d'attribut
ou une constante comme dans l'exemple suivant.

.. code-block:: sql

    select surface, niveau, 18 as 'EurosParm2' 
    from Appart

..  csv-table::
    :header: surface, niveau, EurosParm2

    150 , 14    , 18
    50  , 15    , 18
    200 , 2 , 18
    50  , 5 , 18
    75  , 3 , 18
    150 , 0 , 18
    250 , 1 , 18
    250 , 2 , 18

Les attributs ``surface`` et ``niveau`` proviennent de *Appart* alors
que 18 est une constante qui sera répétée autant de fois
qu'il y a de nuplets dans le résultat. De plus, on
peut donner un nom à cette colonne avec la commande ``as``.
Voici un second exemple qui montre une expression plus complexe.
L'utilisateur (certainement un agent immobilier avisé
et connaissant bien SQL) calcule le loyer d'un appartement
en fonction d'une savante formule qui fait intervenir
la surface et le niveau.

.. code-block:: sql

    select no, surface, niveau, 
            (surface * 18) * (1 + (0.03 * niveau)) as loyer 
    from Appart


.. csv-table:: 
   :header: no , surface , niveau , loyer
   :widths: 4, 4, 4, 4

   1  , 150     , 14    , 3834.00 
   34 , 50      , 15    , 1305.00 
   51 , 200     , 2     , 3816.00 
   52 , 50      , 5     , 1035.00 
   1  , 250     , 1     , 4635.00 
   2  , 250     , 2     , 4770.00


SQL fournit de très nombreux opérateurs et fonctions
de toute sorte qui sont clairement énumérées dans la
documentation de chaque système. Elles sont particulièrement utiles
pour des types de données un peu délicat à manipuler
comme les dates. 


Une extension rarement utilisée consiste à effectuer des tests
sur la valeur des attributs à l'intérieur de 
la clause ``select`` avec l'expression ``case`` dont
la syntaxe est:

.. code-block:: sql

   case 
     when test then expression
     [when ...]
     else  expression
   end

Ces tests peuvent
être utilisés par exemple pour effectuer un
*décodage* des valeurs quand celles-ci sont
difficiles à interpréter ou quand on souhaite
leur donner une signification dérivée. La requête
ci-dessous classe les appartements
en trois catégories selon la surface.

.. code-block:: sql

      select no, niveau, surface,
            case when surface <= 50 then 'Petit'
                 when surface > 50 and surface <= 100 then 'Moyen'
                 else 'Grand'
            end as categorie
     from Appart

..  csv-table::
    :header: no, niveau, surface, categorie

    1   , 14    , 150   , Grand
    34  , 15    , 50    , Petit
    51  , 2 , 200   , Grand
    52  , 5 , 50    , Petit
    43  , 3 , 75    , Moyen
    10  , 0 , 150   , Grand
    1   , 1 , 250   , Grand
    2   , 2 , 250   , Grand

Jointure interne, jointure externe
==================================

La jointure est une opération indispensable dès que l'on souhaite
combiner des données réparties dans plusieurs tables. Nous avons
déjà étudié en détail la conception et l'expression des jointures. 
On va se contenter ici de montrer quelques exemples en forme
de récapitulatif, sur notre base d'immeubles.

.. note::  Il existe beaucoup de manières différentes d'exprimer les jointures
   en SQL. Il est recommandé de se limiter
   à la forme de base donnée ci-dessous qui est plus facile
   à interpréter et se généralise à un nombre de tables quelconques.


Jointure interne
----------------

Prenons l'exemple d'une requête cherchant la surface et le niveau
de l'appartement de M. Barnabé Simplet. 

.. code-block:: sql

    select p.nom, p.prénom,  a.surface, a.niveau
    from Personne as p, Appart as a
    where prénom='Barnabé'
    and nom='Simplet'
    and   a.id = p.idAppart
   
..  csv-table::
    :header: nom, prénom, surface, niveau

    Simplet , Barnabé   , 200   , 2

Une première difficulté à résoudre quand on utilise plusieurs
tables est la possibilité d'avoir des attributs de
même nom dans l'union des schémas, ce qui soulève des ambiguités dans les clauses
``where`` et ``select``. On résout cette ambiguité
en préfixant les attributs par le nom des variables-nuplet dont ils
proviennent. 

Notez que la levée de l'ambiguité 
en préfixant par le nom de la variable-nuplet
n'est nécessaire que pour les attributs qui apparaissent
en double soit ici ``id`` qui peut désigner
l'identifiant de la personne ou celui de l'appartement.


Comme dans la très grande majorité des cas la jointure consiste
à exprimer une égalité entre la clé primaire de l'une
des tables et la clé étrangère correspondante de l'autre.
Mais rien n'empêche d'exprimer des conditions
de jointure sur n'importe quel attribut et pas
seulement sur ceux qui sont des clés.

Imaginons que l'on veuille trouver les appartements
d'un même immeuble qui ont la même surface. On veut
associer un nuplet de *Appart* à un
autr nuplet de *Appart* avec les conditions
suivantes:

 -  ils sont dans le même immeuble (attribut ``idImmeuble``);
 -  ils ont la même valeur pour l'attribut ``surface``;
 -  ils correspondent à des appartements distincts (attributs ``id``).

La requête exprimant ces conditions est donc:

.. code-block:: sql

    select a1.id as idAppart1, a1.surface as surface1, a1.niveau as niveau1, 
           a2.id as idAppart2, a2.surface as surface2, a2.niveau as niveau2
    from Appart a1, Appart a2
    where a1.id != a2.id
    and a1.surface = a2.surface
    and a1.idImmeuble = a2.idImmeuble

Ce qui donne le résultat suivant:

..  csv-table::
    :header: idAppart1, surface1, niveau1, idAppart2, surface2, niveau2

    103 , 50    , 5 , 101   , 50    , 15
    101 , 50    , 15    , 103   , 50    , 5
    202 , 250   , 2 , 201   , 250   , 1
    201 , 250   , 1 , 202   , 250   , 2

On peut noter que dans le résultat la même paire apparaît
deux fois avec des ordres inversés. On peut éliminer
cette redondance en remplaçant ``a1.id != a2.id``
par ``a1.id < a2.id``.

Voici quelques exemples complémentaires de jointure.

  - Qui habite un appartement de plus de 200 m2?

    .. code-block:: sql

        select prénom, nom, profession
        from Personne, Appart
        where idAppart = Appart.id
        and  surface >= 200

   Attention à lever l'ambiguité sur les noms d'attributs
   quand ils peuvent provenir de deux tables (c'est le
   cas ici pour ``id``).


  - Qui habite le Barabas?

    .. code-block:: sql

        select prénom, p.nom, no, surface, niveau
        from   Personne as p, Appart as a, Immeuble as i
        where  p.idAppart=a.id
        and    a.idImmeuble=i.id
        and    i.nom='Barabas'

 -  Qui habite un appartement qu'il possède et avec quelle quote-part?

    .. code-block:: sql

       select prénom, nom, quotePart
       from   Personne as p, Propriétaire as p2, Appart as a
       where  p.id=p2.idPersonne /* p est propriétaire */
       and    p2.idAppart=a.id   /* de l'appartement a */
       and    p.idAppart=a.id   /* et il y habite     */


 -  De quel(s) appartement(s) Alice Grincheux
    est-elle propriétaire et dans quel immeuble?

    Voici la requête sur les quatre tables avec
    des commentaires inclus montrant les jointures.

    .. code-block:: sql

         select i.nom, no, niveau, surface
        from  Personne as p, Appart as a, Immeuble as i, Propriétaire as p2
        where  p.id=p2.idPersonne /* Jointure PersonnePropriétaire */
        and    p2.idAppart = a.id /* Jointure PropriétaireAppart */
        and    a.idImmeuble= i.id /* Jointure AppartImmeuble */
        and    p.nom='Grincheux' and p.prénom='Alice'


    Attention à lever l'ambiguité sur les noms d'attributs
    quand ils peuvent provenir de deux tables (c'est le
    cas ici pour ``id``).

L'approche déclarative d'expression des jointures est une
manière tout à fait recommandable de procéder
surtout pour les débutants SQL. Elle permet
de se ramener toujours à la même méthode
d'interprétation et consolide la compréhension
des principes d'interrogation d'une base relationnelle.  

Toutes ces jointures peuvent s'exprimer avec
d'autres syntaxes: tables calculées dans le ``from``
opérateur de jointure dans le ``from`` ou
(pas toujours) requêtes imbriquées. À l'exception
notable des jointures externes, elles n'apportent
aucune expressivité supplémentaire. Toutes ces variantes
constituent des moyens plus ou moins commodes
d'exprimer différemment la jointure.

Jointure externe
----------------

Qu'est-ce qu'une jointure externe?
Effectuons la requête qui affiche tous les
appartements avec leur occupant. 

.. code-block:: sql

    select idImmeuble, no, niveau, surface, nom, prénom
    from  Appart as a, Personne as p
    where  p.idAppart=a.id

Voici
ce que l'on obtient:

..  csv-table::
    :header: idImmeuble, no, niveau, surface, nom, prénom

    2   , 2 , 2 , 250   , Prof  , null
    1   , 52    , 5 , 50    , Grincheux , Alice
    1   , 1 , 14    , 150   , Atchoum   , Léonie
    1   , 51    , 2 , 200   , Simplet   , Barnabé
    2   , 1 , 1 , 250   , Joyeux    , Alphonsine
    1   , 43    , 3 , 75    , Timide    , Brandon
    2   , 10    , 0 , 150   , Dormeur   , Don-Jean

Il manque un appartement, le 34 du Koudalou. En effet cet appartement n'a pas d'occupant. Il n'y
a donc aucune possibilité que la condition de jointure soit satisfaite.

La jointure externe permet d'éviter cette élimination
parfois indésirable. On considère alors
une hiérarchie entre les deux tables. La
première table (en général celle de gauche)
est dite "directrice" et tous ses nuplets,
même ceux qui ne trouvent pas
de correspondant dans la table de droite,
seront prises en compte. Les nuplets de la table
de droite sont en revanche  optionnels.

Si pour un nuplet de la table de gauche on trouve un
nuplet satisfaisant le critère de jointure dans la table de droite,
alors la jointure s'effectue normalement. Sinon, les attributs
provenant de la table de droite sont affichés à ``null``.
Voici la jointure externe entre *Appart* et *Personne*.  Le mot-clé 
``left`` est optionnel.

.. code-block:: sql

    select idImmeuble, no niveau, surface, nom, prénom
    from  Appart as a left outer join Personne as p on (p.idAppart=a.id)


.. csv-table:: 
   :header:  idImmeuble , no , niveau , surface , nom    , prénom
   :widths: 4, 4, 4,4, 10, 10
   
   1           , 1  , 14    , 150     , Atchoum  , Rachel  
   1           , 34 , 15    , 50      , null   , null    
   1           , 51 , 2     , 200     , Simplet , Barnabé 
   1           , 52 , 5     , 50      , Grincheux  , Alice   
   2           , 1  , 1     , 250     , Joyeux  , Alphonsine    
   2           , 2  , 2     , 250     , Prof   , null


Notez les deux attributs ``prénom`` et ``nom``
à ``null`` pour l'appartement 34.

Il existe un ``right outer join``
qui prend la table de droite comme table directrice.
On peut combiner la jointure externe avec 
des jointures normales des sélections des tris etc.
Voici la requête qui affiche le nom
de l'immeuble en plus des informations précédentes
et trie par numéro d'immeuble et numéro 
d'appartement.

.. code-block:: sql

    select i.nom as nomImmeuble, no, niveau, surface, p.nom as nomPersonne, prénom
    from  Immeuble  as i  
           join 
               (Appart as a left outer join Personne as p
                          on (p.idAppart=a.id))
            on (i.id=a.idImmeuble)
    order by i.id, a.no


Tri et élimination de doublons
==============================

SQL renvoie les nuplets du résultat sans se soucier 
de la présence de doublons. Si on cherche par exemple
les surfaces des appartements avec

.. code-block:: sql

   select surface 
   from Appart

on obtient le résultat suivant.

.. csv-table:: 
   :header: surface
   :widths: 4

   150     
   50      
   200     
   50      
   250     
   250


On a  autant de fois une valeur qu'il y a de nuplets
dans le résultat intermédiaire après exécution
des clauses ``from`` et ``where``. En général,
on ne souhaite pas conserver ces nuplets identiques 
dont la répétition n'apporte aucune information. Le
mot-clé ``distinct`` placé juste après le
``select`` permet d'éliminer ces doublons.

.. code-block:: sql

    select distinct surface   
    from Appart

.. csv-table:: 
   :header: surface
   :widths: 4

   150     
   50      
   200     
   250


Le ``distinct`` est à éviter quand c'est possible
car l'élimination des doublons peut entraîner des 
calculs coûteux. Il faut commencer par calculer entièrement
le résultat, puis le trier ou construire une table de hachage, et
enfin utiliser la structure temporaire obtenue pour trouver
les doublons et les éliminer. Si le résultat est de petite taille
cela ne pose pas de problème. Sinon, on risque de constater une
grande différence de temps de réponse entre une requête
sans ``distinct`` et la même avec ``distinct``.

On peut demander explicitement le tri du résultat sur
une ou plusieurs expressions avec la clause ``order by``
qui vient toujours à la fin d'une requête ``select``. La requête
suivante trie les appartements par surface puis, pour
ceux de surface identique, par niveau.

.. code-block:: sql

   select *  
   from Appart 
   order by surface, niveau

.. csv-table:: 
   :header: id  , surface , niveau , idImmeuble , no
   :widths: 4, 10, 10, 10, 4
   
   103 , 50      , 5     , 1           , 52 
   101 , 50      , 15    , 1           , 34 
   100 , 150     , 14    , 1           , 1  
   102 , 200     , 2     , 1           , 51 
   201 , 250     , 1     , 2           , 1  
   202 , 250     , 2     , 2           , 2

Par défaut, le tri est en ordre ascendant. On peut inverser
l'ordre de tri d'un attribut avec le mot-clé ``desc`` .

.. code-block:: sql

    select *  
    from Appart 
    order by surface desc,  niveau desc

.. csv-table:: 
   :header: id  , surface , niveau , idImmeuble , no
   :widths: 4, 10, 10, 10, 4
   
   202 , 250     , 2     , 2           , 2  
   201 , 250     , 1     , 2           , 1  
   102 , 200     , 2     , 1           , 51 
   100 , 150     , 14    , 1           , 1  
   101 , 50      , 15    , 1           , 34 
   103 , 50      , 5     , 1           , 52



Bien entendu, on peut trier sur des expressions
au lieu de trier sur de simples noms d'attribut.


Quiz
====


.. eqt:: sql1-1

    Parmi les requêtes ci-dessous, laquelle nous donnera la liste des logements où on n’a pas informé le lieu
   
    A) :eqt:`I`  select * from Logement where lieu = ''
    #) :eqt:`C`  select * from Logement where lieu is null
    #) :eqt:`I` select * from Logement where lieu = null

.. eqt:: sql1-2

    Voici trois manières de chercher des livres dont l'année est connue. Sont-elles toutes
    correctes et équivalentes?
    
        - select * from Livre where année is not null
        - select * from Livre where not (année is null)
        - select * from Livre where not (année + 0)  is null
    
    A) :eqt:`I`  faux
    #) :eqt:`C`  vrai

.. eqt:: sql1-3

    On peut demander explicitement le tri du résultat sur une ou plusieurs expressions avec la clause
   
    A) :eqt:`I`  ``left outer by``
    #) :eqt:`C`  ``order by``
    #) :eqt:`I`   ``desc by``

.. eqt:: sql1-4

    On ne peut trier que sur des valeurs numériques
   
    A) :eqt:`C`  faux
    #) :eqt:`I`  vrai

.. eqt:: sql1-5

    Quelle affirmation sur la jointure externe est vraie parmi les suivantes
   
    A) :eqt:`I`  Le résultat de la jointure externe entre R et S est inclus dans le résultat de la jointure classique
    #) :eqt:`C`  Le résultat de la jointure classique entre R et S est inclus dans le résultat de la jointure externe
    #) :eqt:`I`  La jointure externe et la jointure classique entre R et S ont une intersection non vide mais ne sont pas inclus l’un dans l’autre


*****************************
S2: Requêtes et sous-requêtes
*****************************

.. admonition::  Supports complémentaires:

    Pas de support vidéo pour cette session qui ne fait que récapituler les différentes
    syntaxes équivalentes pour exprimer une même requête. Ne vous laissez pas troubler
    par la multiplicité des options offertes pqr SQL. En choisissant un dialecte
    et un seul (vous avez compris que je vous recommande la partie déclarative,
    logique de SQL) vous pourrez tout exprimer sans avoir à vous poser des questions
    sans fin. Vos requêtes n'en seront que plus cohérentes et lisibles.

Dans tout ce qui précède, les requêtes étaient "à plat", avec un
seul bloc ``select-from-where``. SQL est assez riche
(ou assez inutilement compliqué, selon les goûts) pour permettre
des expressions complexes combinant plusieurs blocs. On a dans
ce cas une requête principale, et des sous-requêtes, ou requêtes imbriquées.

Disons-le tout de suite: à l'exception des requêtes avec négation
``not exists``, toutes les requêtes imbriquées peuvent s'écrire de
manière équivalente à plat, et on peut juger que c'est préférable
pour des raisons de lisibilité et de cohérence d'écriture. Cette session
essaie en tout cas de clarifier les choses.

Requêtes imbriquées
===================

Reprenons l'exemple de la requête trouvant
la surface et le niveau de l'appartement de M. Simplet.
On peut l'exprimer avec une requête imbriquée de deux manières. La première
est la forme déclarative classique.

.. code-block:: sql

   select surface, niveau
   from Appart as a, Personne as p
   where p.prénom='Barnabé' and p.nom='Simplet'
   and a.id = p.idAppart

On remarque qu'aucun attribut de la table ``Personne`` n'est utilisé
pour construire le résultat. On peut donc utiliser une sous-requête (ou
requête imbriquée).

.. code-block:: sql

   select surface, niveau 
   from Appart
   where  id  in (select idAppart  
                  from Personne
                  where prénom='Barnabé' and nom='Simplet')

Le mot-clé ``in`` exprime 
la condition d'appartenance de l'identifiant
de l'appartement à l'ensemble d'identifiants constitué
avec la requête imbriquée. Il doit y avoir correspondance
entre le nombre et le type des attributs auxquels
s'applique la comparaison par ``in``. L'exemple
suivant montre une comparaison entre des paires d'attributs
(ici on cherche des informations sur les propriétaires).

.. code-block:: sql

    select prénom, nom, surface, niveau
    from   Appart as a, Personne as p 
    where  a.id = p.idAppart
    and    (p.id, p.idAppart)
              in (select idPersonne, idAppart from Propriétaire)

.. csv-table:: 
   :header:  prénom , nom   , surface , niveau
   :widths: 10, 10, 4, 4

   null   , Prof  , 250     , 2     
   Alice  , Grincheux , 50      , 5     
   Alphonsine   , Joyeux , 250     , 1

Il est bien entendu assez direct de réécrire la
requête ci-dessus comme une jointure classique (exercice).
Parfois l'expression avec requête imbriquée
peut s'avérer plus naturelle. Supposons
que l'on cherche les immeubles dans lesquels
on trouve un appartement de 50 m2. Voici
l'expression avec requête imbriquée.

.. code-block:: sql

     select * 
     from Immeuble 
     where id in (select idImmeuble from Appart where surface=50)

.. csv-table:: 
   :header:  id , nom      , adresse
   :widths: 4, 10, 10

   1  , Koudalou , 3 rue des Martyrs

La requête directement réécrite en jointure donne le résultat
suivant:

.. code-block:: sql

     select i.* 
     from   Immeuble as i,Appart as a 
     where  i.id=a.idImmeuble
     and    surface=50

.. csv-table:: 
   :header:  id , nom      , adresse
   :widths: 4, 10, 15

   1  , Koudalou , 3 rue des Martyrs
   1  , Koudalou , 3 rue des Martyrs

On obtient deux fois le même immeuble puisqu'il peut 
être associé à deux appartements différents de 50 m2.
Il suffit d'ajouter un ``distinct`` après le ``select``
pour régler le problème, mais on peut
considérer que dans ce cas la requête imbriquée est
plus appropriée. Attention cependant: il n'est pas possible
de placer dans le résultat des attributs appartenant
aux tables des requêtes imbriquées.

Le principe général des requêtes imbriquées
est d'exprimer des conditions sur des tables calculées
par des requêtes. Cela revient, dans le cadre formel qui soutient
SQL, à appliquer une quantification sur une collection constituée
par une requête (voir chapitre :ref:`chap-calcul`).

Ces conditions sont les suivantes:

  - ``exists R``: renvoie ``true`` si *R*
    n'est pas vide ``false`` sinon.
  - *t* ``in R`` où est un nuplet dont le type (le nombre
    et le type des attributs)
    est celui de *R*: renvoie ``true`` si *t* appartient
    à *R* ``false`` sinon.
  - *v* *cmp* ``any R`` où *cmp* est un
    comparateur SQL (*<* *>* *=* etc.): renvoie
    ``true`` si la comparaison avec *au moins un*
    des nuplets de la table *R* renvoie ``true``.
  - *v* *cmp* ``all R`` où *cmp* est un
    comparateur SQL (*<* *>* *=* etc.): renvoie
    ``true`` si la comparaison avec *tous*
    les nuplets de la table *R* renvoie ``true``.


De plus toutes ces expressions peuvent être préfixées
par ``not`` pour obtenir la négation. La richesse 
des expressions possibles permet d'effectuer une même
interrogation en choisissant parmi plusieurs syntaxes
possibles. En général, tout ce qui n'est pas
basé sur une négation ``not in`` ou ``not exists``
peut s'exprimer *sans* requête imbriquée. 

Le ``all`` peut se réécrire avec  une négation 
puisque si une propriété est *toujours* vraie
il n'existe pas de cas où elle est fausse.
La requête ci-dessous applique le ``all``
pour chercher le niveau le plus élevé de l'immeuble 1.

.. code-block:: sql

 select * from Appart
     where idImmeuble=1
     and    niveau >= all (select niveau from Appart where idImmeuble=1)

Le ``all`` exprime une comparaison qui vaut pour
*toutes*  les nuplets ramenés par la requête imbriquée. La formulation
avec ``any`` s'écrit:

.. code-block:: sql

 select * from Appart
     where idImmeuble=1
     and   not (niveau < any (select niveau from Appart where idImmeuble=1))

Rien de nouveau du point de vue expressif: on peut prendre les étages tels
*qu'il n'existe pas* un niveau supérieur.

.. code-block:: sql

 select * from Appart as a1
     where a1.idImmeuble=1
     and    not exists (select * 
                     from Appart as a2 
                     where a1.idImmeuble=1 and a1.niveau < a2.niveau)

Attention aux valeurs à ``null`` dans ce genre
de situation: toute comparaison avec
une de ces valeurs renvoie ``unknown``
et cela peut entraîner l'échec du ``all``. 
Il n'existe pas d'expression avec jointure qui puisse exprimer
ce genre de condition. 

Requêtes correlées
==================

Les exemples de requêtes imbriquées donnés
précédemment pouvaient être évalués 
indépendamment de la requête principale, ce
qui permet au système (s'il le juge nécessaire)
d'exécuter la requête en deux phases. 
La clause ``exists`` fournit encore un nouveau moyen d'exprimer
les requêtes vues précédemment en basant la sous-requête sur 
une ou plusieurs valeurs issues de
la requête principale. On parle alors de 
requêtes *correlées*. 

Voici encore une fois la recherche de l'appartement de M. Barnabé Simplet
exprimée avec ``exists``:

.. code-block:: sql

    select * from Appart
    where  exists  (select * from Personne
                    where  prénom='Barnabé' and nom='Simplet'
                    and    Personne.idAppart=Appart.id)

On obtient donc une nouvelle technique d'expression qui permet d'aborder le
critère de recherche sous une troisième perspective: on conserve un
appartement si, *pour cet appartement*, l'occupant s'appelle Barnabé
Simplet. Il s'agit assez visiblement d'une jointure mais entre deux tables
situées dans des requêtes (ou plutôt des "blocs") distinctes.  La
condition de jointure est appelée corrélation d'où le nom de ce type de
technique.

Les jointures dans lesquelles le résultat est construit à partir
d'une seule table peuvent d'exprimer
avec ``exists`` ou ``in``. Voici quelques
exemples reprenant des requêtes déjà vues
précédemment.

  - Qui habite un appartement de plus de 200 m2?

    Avec ``in``:

    .. code-block:: sql

        select prénom, nom, profession      
        from Personne      
        where idAppart in (select id from Appart where surface >= 200)

    Avec ``exists``:

    .. code-block:: sql

       select prénom, nom, profession      
       from Personne  p    
       where exists (select * from Appart a 
                     where a.id=p.idAppart 
                     and surface >= 200)

  - Qui habite le Barabas?

    Avec ``in``:

    .. code-block:: sql

       select prénom, nom, no, surface, niveau
       from   Personne as p, Appart as a
       where  p.idAppart=a.id
       and a.idImmeuble in 
                (select id from Immeuble
                 where  nom='Barabas')

    Avec ``exists``:

    .. code-block:: sql

       select prénom, nom, no, surface, niveau 
       from Personne as p, Appart as a 
       where  p.idAppart=a.id 
       and exists (select * from Immeuble i
                   where  i.id=a.idImmeuble 
                   and i.nom='Barabas')

.. important:: dans une sous-requête associée à la clause ``exists``
   peu importent les attributs du ``select``
   puisque la condition se résume à: cette requête ramène-t-elle
   au moins un nuplet ou non? On peut donc systématiquement
   utiliser ``select *`` ou  ``select ''`` 


Enfin rien n'empêche d'utiliser plusieurs niveaux d'imbrication au prix d'une forte 
dégradation de la lisibilité. Voici la requête "De quel(s) appartement(s) Alice Grincheux
est-elle propriétaire et dans quel immeuble?" écrite avec plusieurs niveaux.

.. code-block:: sql

     select i.nom, no, niveau, surface
     from  Immeuble as i, Appart as a
     where  a.idImmeuble= i.id
     and    a.id in 
                  (select idAppart 
                   from Propriétaire
                   where idPersonne in
                            (select id 
                             from Personne
                             where  nom='Grincheux' 
                             and prénom='Alice'))

En résumé une jointure entre les tables
*R* et *S* de la forme:

.. code-block:: sql

     select R.*
     from R S
     where R.a = S.b

peut s'écrire de manière équivalente avec
une requête imbriquée:

.. code-block:: sql

    select [distinct] *
    from R
    where R.a in (select S.b from S)

ou bien encore sous forme de requête corrélée:

.. code-block:: sql

    select [distinct] *
    from R
    where exists (select S.b from S where S.b = R.a)


Le choix de la forme est matière de goût ou de lisibilité, 
ces deux critères relevant de considérations 
essentiellement subjectives. 

Requêtes avec négation
======================

Les sous-requêtes sont en revanche irremplaçables
pour exprimer des négations. On utilise
alors ``not in`` ou (de manière équivalente)
``not exists``. Voici un premier
exemple avec la requête: *donner les 
appartements sans occupant*.
 
.. code-block:: sql

    select * from Appart
    where  id not in (select idAppart from Personne)

On obtient comme résultat.


..  csv-table::
    :header: id, no, surface, niveau, idImmeuble

    101 , 34    , 50    , 15    , 1

La négation est aussi un moyen d'exprimer  des requêtes courantes comme celle
recherchant l'appartement le plus élevé de son immeuble.
En SQL, on utilisera
typiquement une sous-requête pour prendre le niveau 
maximal d'un immeuble, et on utilisera cet niveau 
pour sélectionner un ou plusieurs appartements,
le tout avec une requête correlée pour
ne comparer que des appartements situés
dans le même immeuble.

.. code-block:: sql

    select *
    from Appart as a1
    where niveau =  (select max(niveau) from Appart as a2
                    where a1.idImmeuble=a2.idImmeuble)

.. csv-table:: 
   :header:  id  , surface , niveau , idImmeuble , no
   :widths: 4, 4, 4, 4, 4

   101 , 50      , 15    , 1           , 34 
   202 , 250     , 2     , 2           , 2

   

Il existe en fait beaucoup de manières d'exprimer la même chose. Tout d'abord cette requête peut en
fait s'exprimer sans la fonction *max()* avec la négation: si
*a* est l'appartement le plus élevé, c'est *qu'il n'existe pas* 
de niveau plus elevé  que *a*.  On utilise alors habituellement une
requête dite "corrélée" dans laquelle la
sous-requête est basée sur une ou plusieurs valeurs issues des
tables de la requête principale.

.. code-block:: sql

     select *
     from Appart as a1
     where not exists  (select * from Appart as a2
                        where a2.niveau > a1.niveau
                        and a1.idImmeuble = a2.idImmeuble)


Autre manière d'exprimer la
même chose: si le niveau est le plus élevé, tous les autres
sont situés à un niveau inférieur.
On peut utiliser le mot-clé ``all`` qui indique que la comparaison est
vraie avec *tous* les éléments de l'ensemble constitué par la sous-requête.

.. code-block:: sql

     select *
     from Appart as a1
     where niveau >= all (select niveau from Appart as a2
                     where a1.idImmeuble=a2.idImmeuble)

Dernier exemple de négation: quels sont
les personnes qui ne possèdent aucun appartement
même partiellement? Les deux formulations ci-dessous sont équivalentes, 
l'une s'appuyant sur ``not in``, et l'autre sur 
``not exists``.

.. code-block:: sql

     select *
     from Personne
     where id not in (select idPersonne from Propriétaire)

     select *
     from Personne as p1
     where not exists (select * from Propriétaire as p2
                       where p1.id=p2.idPersonne)

************
S3: Agrégats
************

.. admonition::  Supports complémentaires:

    * `Diapositives: agrégats <http://sql.bdpedia.fr/files/slagregats.pdf>`_
    * `Vidéo sur les agrégats <https://mediaserver.cnam.fr/videos/agregats/>`_ 


Les requêtes d'agrégation en SQL consistent à effectuer des regroupements de nuplets
en fonction des valeurs d'une ou plusieurs expressions.  Ce regroupement est
spécifié par la clause ``group by``.  On obtient une structure qui n'est
pas une table relationnelle puisqu'il s'agit d'un ensemble de groupes de
nuplets. On doit ensuite ramener cette structure à une table en appliquant des
*fonctions de groupes* qui déterminent des valeurs agrégées
calculées pour chaque groupe.

Enfin, il est possible d'exprimer des conditions sur les valeurs agrégées pour
ne conserver qu'un ou plusieurs des groupes constitués. Ces conditions portent
sur des *groupes* de nuplets et ne peuvent donc être obtenues avec
``where``. On utilise alors la clause ``having``.

Les agrégats s'effectuent *toujours* sur le résultat d'une requête
classique ``select - from``. On peut donc les voir comme une extension de
SQL consistant à partitionner un résultat en groupes selon certains critères,
puis à
exprimer des conditions sur ces groupes, et enfin à appliquer des fonctions
d'agrégation.

Il existe un groupe par défaut: c'est la table toute entière. Sans même
utiliser ``group by``, on peut appliquer  les fonctions d'agrégation au contenu
entier de la table comme le montre
l'exemple suivant.

.. code-block:: sql

    select count(*) as nbPersonnes, count(prénom) as nbPrénoms, count(nom) as nbNoms
    from Personne

Ce qui donne:

..  csv-table::
    :header: nbPersonnes, nbPrénoms, nbNoms

    7   , 6 , 7

On obtient 7 pour le nombre de nuplets, 6 pour le nombre
de prénoms, et 7 pour le nombre de noms. 
En effet, l'attribut ``prénom`` est 
à ``null`` pour la première personne  et
n'est en conséquence pas pris en compte par la fonction d'agrégation.
Pour compter tous les nuplets, on doit utiliser
``count(*)`` ou un attribut déclaré
comme  ``not null``.
On peut aussi compter le nombre de valeurs distinctes
dans un groupe avec ``count(distinct <expression>)``.

La clause ``group by``
======================

Le rôle du ``group by`` est de partitionner 
le résultat d'un bloc ``select from where``  en fonction
d'un critère (un  ou plusieurs attributs, ou plus généralement 
une expression sur des attributs).
Pour bien analyser ce qui se passe pendant une requête avec 
``group by``
on peut  décomposer l'exécution d'une requête en deux étapes.
Prenons l'exemple de celle  permettant
de vérifier que la somme des quote-part des propriétaires
est bien égale à 100 pour tous les appartements.

.. code-block:: sql

     select  idAppart, sum(quotePart) as totalQP
     from    Propriétaire
     group by idAppart

..  csv-table::
    :header: idAppart, totalQP

    100 , 100
    101 , 100
    102 , 100
    103 , 100
    104 , 100
    201 , 100
    202 , 100

Dans une première étape le système va constituer les groupes. 
On peut les représenter avec un tableau comprenant,
pour chaque nuplet, d'une part la (ou les) valeur(s) du
(ou des) attribut(s) de partitionnement (ici ``idAppart``), 
d'autre part l'ensemble de nuplets dans lesquelles
on trouve cette valeur. Ces nuplets "imbriqués" sont séparés
par des points-virgule dans la représentation ci-dessous.

.. csv-table:: 
   :header: idAppart, "Groupe", "count"  
   :widths: 4, 10, 4 
   
   100  , (idPersonne=1 quotePart=33 ; idPersonne=5 quotePart=67) , 2 
   101 ,    (idPersonne=1 quotePart=100) , 1
   102  ,   (idPersonne=5 quotePart=100) , 1 
   103 ,  (idPersonne=2 quotePart=100) , 1 
   104 ,  (idPersonne=2 quotePart=100) , 1 
   201 ,    (idPersonne=5 quotePart=100) , 1
   202  ,   (idPersonne=1 quotePart=100) , 1


Le groupe associé à l'appartement 100 est constitué de deux 
copropriétaires. Le tableau ci-dessus
n'est donc pas une table relationnelle dans laquelle
chaque cellule ne peut contenir qu'une seule valeur.

Pour se ramener à une table relationnelle, on transforme
durant la deuxième étape chaque  groupe de nuplets
en une valeur par application d'une fonction d'agrégation.
La fonction ``count()`` compte le nombre de nuplets
dans chaque groupe, ``max()`` donne la valeur maximale
d'un attribut parmi l'ensemble des nuplets du groupe, etc.
La liste des fonctions d'agrégation est donnée ci-dessous:

 - ``count(expression)``, Compte le nombre de nuplets pour lesquels ``expression`` est ``not null``.
 - ``avg(expression``), Calcule la moyenne de ``expression``.
 - ``min(expression``), Calcule la valeur minimale de ``expression``.
 - ``max(expression``), Calcule la valeur maximale de ``expression``.
 - ``sum(expression``), Calcule la somme de  ``expression``.
 - ``std(expression``), Calcule l'écart-type de ``expression``.


Dans la norme SQL  l'utilisation de fonctions d'agrégation 
pour les attributs qui n'apparaissent pas
dans le  ``group by`` est *obligatoire*.
Une requête comme:

.. code-block:: sql

   select  id, surface, max(niveau) as niveauMax
   from    Appart
   group by surface

sera rejetée parce que le groupe associé à 
une même surface  
contient deux appartements  différents (et donc
deux valeurs différentes pour ``id``), et qu'il n'y a pas
de raison d'afficher l'un plutôt que l'autre.


Quelques exemples
=================

.. note:: Vous pouvez exécuter ces requêtes sur le site des TP http://deptfod.cnam.fr/bd/tp.

Calculons la surface totale des appartements, groupés par immeuble. Décomposons: 
nous avons d'abord besoin du bloc "select - from - where" avec les identifants d'immeubles
et les surfaces d'appartement. 

.. code-block::  sql

    select idImmeuble, surface 
    from Appart
    
On ajoute à cette requête la clause ``group by`` pour grouper par immeuble. On obtient 
alors (en phase intermédiaire) deux groupes d'appartements, un pour chaque immeuble. 
Il reste à appliquer une fonction d'agrégation pour ramener ces groupes à une valeur atomique.

.. code-block:: sql

    select idImmeuble, sum(surface) as totalSurface
    from Appart
    group by idImmeuble
 
On pourrait aussi appliquer d'autres fonctions d'agrégation:

.. code-block:: sql

        select idImmeuble, min(niveau) as minEtage, max(niveau) as maxEtage, 
                 sum(surface) as totalSurface
        from Appart
        group by idImmeuble
        

Revenons un moment à nos voyageurs et à leurs séjours. La requête ci-dessous
doit être claire. Exécutez-la sur le site: on constate qu'un voyageur a effectué
plusieurs séjours et qu'un logement a reçu plusieurs voyageurs.

.. code-block:: sql

        select v.nom as nomVoyageur, l.nom as nomLogement 
        from Voyageur as v, Séjour as s, Logement as l
        where v.idVoyageur = s.idVoyageur
        and l.code = s.codeLogement
    
En ajoutant une clause ``group by`` on produit des statistiques sur le résultat de cette requête.
Par exemple, en groupant sur les voyageurs

.. code-block:: sql

    select v.nom as nomVoyageur, count(*) as 'nbSéjours'
    from Voyageur as v, Séjour as s, Logement as l
    where v.idVoyageur = s.idVoyageur
    and l.code = s.codeLogement
    group by v.idVoyageur

Ou en groupant sur les logements

.. code-block:: sql

    select l.nom as nomLogement, count(*) as 'nbVoyageurs'
    from Voyageur as v, Séjour as s, Logement as l
    where v.idVoyageur = s.idVoyageur
    and l.code = s.codeLogement
    group by l.code

On peut aussi regrouper sur plusieurs attributs. Pour obtenir par exemple
le nombre de séjours effectués par un voyageur dans un même logement.

.. code-block:: sql

    select l.nom as nomLogement, v.nom as 'nomVoyageur', count(*) as 'nbSéjours'
    from Voyageur as v, Séjour as s, Logement as l
    where v.idVoyageur = s.idVoyageur
    and l.code = s.codeLogement
    group by l.code, v.idVoyageur
    
Moralité: à partir d'une requête SQL ``select - from -- where``, aussi complexe que nécessaire,
vous produisez un résultat
(une table). Le  ``group by`` permet d'effectuer des regroupements et des 
agrégations (simples) sur ce résultat. Il s'agit vraiment d'un complément au SQL que nous
avons étudié en long et en large.


La clause ``having``
====================

Finalement, on peut faire porter des conditions sur
les groupes,  ou plus précisément sur le résultat de
fonctions d'agrégation appliquées à des groupes 
avec la clause  ``having``.  Par exemple,
on peut sélectionner les appartements pour lesquels on connaît
au moins deux copropriétaires.


.. code-block:: sql

     select  idAppart, count(*) as nbProprios
     from    Propriétaire
     group by idAppart
     having count(*) >= 2

On voit que la condition porte ici sur une propriété
de l'*ensemble* des nuplets du groupe et pas de chaque 
nuplet pris individuellement. La clause  ``having`` 
est donc toujours exprimée sur le résultat de
fonctions d'agrégation, par opposition avec la clause
``where`` qui ne peut exprimer des conditions 
que sur les nuplets  pris un à un.

.. important:: La requête ci-dessus pourrait s'exprimer en utilisant l'alias
   pour éviter d'avoir à répeter deux fois le ``count(*)`` (et pour la rendre plus claire).

   .. code-block:: sql

            select  idAppart, count(*) as nbProprios
            from    Propriétaire
            group by idAppart
            having nbProprios >= 2
            
   Il n'est malheureusement pas sûr que l'utilisation de l'alias dans le ``group by`` soit
   acceptée dans tous les systèmes. 
 
Quelques exemples pour conclure. Toujours sur la base des voyageurs: quels voyageurs ont effectué
au moins deux séjours ?

.. code-block:: sql

    select v.nom as nomVoyageur, count(*) as 'nbSéjours'
    from Voyageur as v, Séjour as s, Logement as l
    where v.idVoyageur = s.idVoyageur
    and l.code = s.codeLogement
    group by v.idVoyageur
    having count(*) > 1

Quels logements proposent moins de deux activités.

.. code-block:: sql

    select l.nom
    from Logement as l, Activité as a
    where l.code = a.codeLogement
    group by l.code
    having count(*) < 2

Voici enfin une requête un peu complexe (sur la base des immeubles) sélectionnant la
surface possédée par chaque copropriétaire
pour l'immeuble 1. La surface possédée est la somme
des surfaces d'appartements possédés par un propriétaire,
pondérées par leur quote-part. On regroupe par
propriétaire et on trie sur la surface possédée.

.. code-block:: sql

   select prénom nom,
          sum(quotePart * surface / 100) as 'surfacePossédée'
   from Personne as p1, Propriétaire as p2, Appart as a
   where p1.id=p2.idPersonne
   and  a.id=p2.idAppart
   and  idImmeuble = 1
   group by p1.id
   order by sum(quotePart * surface / 100)

On obtient le résultat suivant.

..  csv-table::
    :header: nom, surfacePossédée

    null    , 99.5000
    Alice   , 125.0000
    Alphonsine  , 300.5000

Quiz
====

.. eqt:: agregat1

   Pourquoi peut-on effectuer des *count()*, *sum()* et autres fonctions d’agrégations 
   sans clause ``group by`` (premier exemple du cours) ?

   A) :eqt:`I` Parce que dans ce cas chaque nuplet du résultat de la requête avant regroupement est un groupe, auquel on applique la fonction
   #) :eqt:`C` Parce que dans ce cas le résultat avant regroupement forme un seul et unique groupe
   #) :eqt:`I` Parce que la condition de sélection dans la clause where définit toujours autant de groupes qu’il y a de critères

.. eqt:: agregat2

   Quel est le rôle de la clause ``having``

   A) :eqt:`I` C’est un synonyme du ``where``, avec lequel elle est interchangeable : on l’utilise pour des raisons de lisibilité
   #) :eqt:`C` Elle permet d’exprimer des conditions portant exclusivement sur les groupes, et pas sur les nuplets individuels
   #) :eqt:`I` Elle permet d’éliminer des nuplets de certains groupes, une fois ceux-ci constitués



.. eqt:: agregat3

   La requête suivante 

   .. code-block:: sql

       select nom, type, count(*) as Nombre, sum(capacité) as totalCapacité
       from Logement
       group by type
      

   est-elle correcte ?

   A) :eqt:`I` Oui : toutes les clauses et fonctions d’agrégation sont bien utilisées
   #) :eqt:`C` Non, car il peut y avoir plusieurs noms de logement par type, et le résultat n’est donc pas en première forme normale
   #) :eqt:`I` Non, car il faut appliquer une fonction d’agrégation à tous les attributs de la clause ``select``



.. eqt:: agregat4

   La requête suivante 

   .. code-block:: sql

       select count(*) as Nombre
       from Logement
       group by type
       having type = 'Hôtel'

   pourrait-elle s’écrire sans group by, en remplaçant la clause ``having`` par une clause ``where`` ?
   
   A) :eqt:`C` Oui 
   #) :eqt:`I` Non
   


.. eqt:: agregat5

   On cherche les lieux ayant au moins 3 auberges. Quelle est la bonne requête ?
   
   A) :eqt:`I` select lieu from Logement where type=’Auberge’ and count(*) > 3
   #) :eqt:`C` select lieu from Logement where type=’Auberge’ group by lieu having count(*) > 3
   #) :eqt:`I` select lieu from Logement group by type having type=’Auberge’  and count(*) > 3
   

****************
S4: Mises à jour
****************


.. admonition::  Supports complémentaires:

    Pas de vidéo sur cette partie triviale de SQL.

Les commandes de mise à jour (insertion,
destruction, modification) sont considérablement plus 
simples que les interrogations. 

Insertion
=========

L'insertion s'effectue avec la commande 
``insert``,
avec trois variantes. Dans la première on indique 
la liste des valeurs à insérer sans donner explicitement
le nom des attributs. Le système suppose alors qu'il
y a autant de valeurs que d'attributs, et que l'ordre
des valeurs correspond à celui des attributs dans la table.
On peut indiquer 
``null`` pour les valeurs
inconnues.

.. code-block:: sql

   insert into Immeuble
   values (1 'Koudalou' '3 rue des Martyrs')


Si on veut insérer dans une partie seulement des attributs,
il faut donner la liste explicitement. 

.. code-block:: sql

   insert into Immeuble (id nom adresse)
   values (1 'Koudalou' '3 rue des Martyrs')

Il est d'ailleurs préférable de toujours donner la liste
des attributs. La description d'une table peut changer
par ajout d'attribut, et l'ordre  ``insert``
qui marchait un jour ne marchera plus le lendemain.

Enfin avec la troisième forme de
``insert`` il est possible d'insérer dans une table
le résultat d'une requête. Dans ce cas la
partie 
``values`` est remplacée par
la requête elle-même. Voici un exemple
avec une nouvelle table *Barabas* dans
laquelle on insère uniquement les informations
sur l'immeuble "Barabas".

.. code-block:: sql

    create table Barabas (id int not null,
                         nom varchar(100) not null,
                         adresse varchar(200),
                         primary key (id)
    )

    insert into Barabas
    select * from Immeuble where nom='Barabas'
     

Destruction
===========

La destruction s'effectue avec la clause ``delete``
dont la syntaxe est:

.. code-block:: sql

   delete from table
   where condition

``table`` étant bien entendu le nom de la table, et ``condition``
toute condition ou liste de conditions
valide pour une clause  ``where``.
En d'autres termes, si on effectue avant la destruction
la requête


.. code-block:: sql

   select * from table
   where condition

on obtient l'ensemble des nuplets qui seront détruits
par 
``delete``. Procéder de cette manière est un des moyens de
s'assurer que l'on va bien détruire ce que l'on souhaite.

Modification
============

La modification s'effectue avec la clause 
``update``. La
syntaxe est proche de celle du 
``delete``:


.. code-block:: sql

   update table set A1=v1, A2=v2, ... An=vn
   where condition

Comme précédemment ``table``  est la table, les ``Ai`` sont les attributs
les ``vi`` les nouvelles valeurs, et ``condition``
est toute condition valide pour la clause  ``where``.
