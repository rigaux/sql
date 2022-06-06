.. _chap-calcul:

#######################
SQL, langage déclaratif
#######################


Il est courant en informatique de disposer de plusieurs langages pour résoudre un même
problème. Ces langages ont leur propre syntaxe, mais surtout ils peuvent s'appuyer
sur des approches de programmation très différentes. Vous avez peut-être rencontré
des langages impératifs (le C), orientés-objet (Java, Python) ou fonctionnels (Camel, Erlang).

Certains langages sont plus appropriés à certaines tâches que d'autres. Il est plus facile 
de vérifier
les propriétés d'un programme écrit en langage fonctionnel par exemple que d'un programme C.
Si l'on s'en tient aux bases de données (et particulièrement pour les bases relationnelles),
deux approches sont possibles: la première est *déclarative* et la seconde *procédurale*.

L'approche procédurale est assez familière: on dispose d'un ensemble d'opérations, et on
décrit le calcul à effectuer par une séquence de ces opérations. Chaque opération élémentaire
peut être très simple, mais la séquence à construire pour régler des problèmes complexes
peut être longue et peu claire.

L'approche déclarative est beaucoup plus simple conceptuellement: elle consiste
à décrire les propriétés du point d'arrivée (le résultat) en fonction  de celles du
point de départ (les données de la base, dans notre cas). La description de ces propriétés
se fait classiquement par des formules logiques qui indiquent comment l'existence
d'un fait :math:`f_1` au départ implique l'existence d'un fait :math:`f_2` à l'arrivée.

Cela peut paraître abstrait, et de fait ça l'est puisqu'aucun calcul n'est spécifié. On s'appuie
simplement sur le fait que l'informatique *sait* effectuer des calculs spécifiés par des formules logiques (dans le cas particulier
des bases de données en tout cas)  apparemment indépendantes
de tout processus calculatoire. Il se trouve que SQL *est* un langage déclaratif, 
et qu'il l'était même exclusivement
dans sa version initiale. 

.. note:: Il existe de très bonnes raisons pour privilégier le caractère déclaratif des langages de requêtes, 
   liées à l'indépendance entre le niveau logique et le niveau physique donc
   nous avons déjà parlé, et à l'opportunité que cette indépendance laisse au 
   SGBD pour déterminer la meilleure manière d'évaluer une requête. Cela n'est 
   possible que si l'expression de cette requête est assez abstraite pour n'imposer
   aucun choix de calcul à priori.

Avec SQL, on ne dit rien sur la manière dont le résultat doit être calculé: c'est le problème
du SGBD, qui sait d'ailleurs trouver la solution bien mieux que nous puisqu'on 
ne connaît pas l'organisation des données. On se contente avec SQL d'énoncer
les propriétés de la relation de sortie en fonction des propriétés de la base en entrée.
Pour bien utiliser SQL, et surtout bien comprendre la *signification* de ce que l'on
exprime, il faut donc maîtriser l'expression de formules logiques et connaitre les
mécanismes d'inférences des valeurs de vérité. 

On rencontre parfois l'argument que SQL est, à l'inverse d'un langage de programmation,
accessible à un non-initié, car il est proche de la manière dont on exprimerait
naturellement une recherche. Ce n'est vrai que si on sait *formuler* cette dernière de manière 
rigoureuse, et c'est exactement ce que nous allons apprendre dans ce chapitre.
   
.. admonition:: SQL est-il *totalement* déclaratif?

   Au fil des années et des normes successives, SQL s'est étendu pour incorporer un
   autre langage relationnel, l'algèbre, que nous étudierons dans le prochain chapitre.
   Est-ce à dire que la forme déclarative n'était pas suffisante? Non: tous ces ajouts
   sont redondants et auraient pu être omis sans affecter l'expressivité du langage.

   On se retrouve à l'heure actuelle avec un langage très riche dans lequel on peut  
   exprimer des requêtes de manière soit déclarative, soit procédurale, soit par
   un mélange des deux. Cela ne contribue pas forcément à la facilité d'apprentissage,
   et introduit une certaine confusion sur la portée de telle ou telle formulation, et
   sa possible équivalence avec une autre.

   En présentant successivement les deux approches, et en montrant ensuite comment elles
   sont parfaitement équivalentes l'une à l'autre, ce cours a choisi de tenter de clarifier
   la situation.


*********************
S1: Un peu de logique
*********************

.. admonition::  Supports complémentaires:

    * `Diapositives: notions de logique <http://sql.bdpedia.fr/files/slnotionslogique.pdf>`_
    * `Vidéo sur les notions de logique <https://mediaserver.cnam.fr/videos/notions-de-logique/>`_ 

La logique est l'art de raisonner, autrement dit de construire des argumentations rigoureuses
permettant d'induire ou déduire de nouveaux faits à partir de faits existants (ou considérés
comme tels). La logique mathématique est la partie de la logique qui présente les règles
de raisonnement de manière formelle. C'est une branche importante des mathématiques, 
qui s'est fortement
développée au début du XXe siècle, et constitue un fondement majeur de la science informatique.

Commençons par effectuer un rappel des quelques éléments de logique formelle qui sont 
indispensables pour formuler et interpréter les requêtes SQL. Ce qui suit n'est qu'une très brève
(et assez simplifiée) introduction au sujet: il faut recourir à des textes spécialisés si vous voulez
aller plus loin. Pour une passionante introduction historico-scientifique, je vous recommande d'ailleurs
la bande dessinée (mais oui) *Logicomix*, parue chez Vuivert en 2009.

.. important:: Ceux qui pensent maîtriser le sujet peuvent sauter cette session.

La partie la plus simple de la logique formelle est le calcul propositionnel, par lequel nous commençons.
SQL est construit sur une forme plus élaborée, impliquant des *prédicats*, des *collections*
et des *quantificateurs*, notions brièvement présentées 
ensuite dans une optique "bases de données".

Le calcul propositionnel
========================

Une *proposition* est un énoncé auquel on peut attacher une valeur de vérité: vrai (V) ou faux (F).
Des énoncés comme "Ce livre parle d'informatique" ou "Cette musique est de Mozart" sont 
des propositions. Une question comme "Qui a écrit ce texte?" n'est pas une proposition.

Le calcul propositionnel décrit la manière dont on peut combiner des propositions
pour former des *formules* (propositionnelles) et attacher des valeurs de vérité à ces
formules. Les propositions peuvent être combinées grâce à des *connecteurs logiques*. Il
en faut au moins deux, mais on en considère en général trois.

   - la conjonction, notée :math:`\land`
   - la disjonction, notée :math:`\lor`
   - la négation, notée :math:`\neg`
   
On note classiquement les propositions par des lettres en minuscules, :math:`p`,
:math:`q`, :math:`r`. La table ci-dessous donne les valeurs de vérités pour les
formules obtenues à l'aide des trois connecteurs logiques, en fonction des valeurs
de vérité de :math:`p` et :math:`q`.

.. _truth-values:
.. list-table:: Valeurs de vérité pour les connecteurs logiques
   :widths: 15 15 15 15 15  
   :header-rows: 1
   
   * - :math:`p`
     - :math:`q`  
     - :math:`p \land q`
     - :math:`p \lor q`
     - :math:`\neg p`
   * - V
     - V
     - V
     - V
     - F
   * - V
     - F
     - F
     - V
     - F
   * - F
     - V
     - F
     - V
     - V
   * - F
     - F
     - F
     - F
     - V

Les formules créées par connecteurs logiques à partir de propositions ont elles-mêmes
des valeurs de vérité, et on peut les combiner à leur tour. Généralement, 
si :math:`F_1` et :math:`F_2` sont des formules, alors :math:`F_1 \land F_2`,
:math:`F_1 \lor F_2` et :math:`\neg F_1` sont aussi des formules. On crée ainsi des
*arbres*
dont les feuilles sont des propositions et les nœuds internes des connecteurs. 

Pour représenter
l'arbre dans le codage de la formule, on utilise des parenthèses et on évite
ainsi toute ambiguité. La formule :math:`p \land q` peut ainsi être combinée à :math:`r`
selon la syntaxe.

.. math::
   
      (p \land q) \lor r

La valeur de vérité de la formule obtenue s'obtient par application récursive des règles
de la table. Si, par exemple, :math:`p, q, r`  ont respectivement
pour valeurs V, V et F, la formule ci-dessus s'interprète ainsi:

   - :math:`(p \land q)` vaut :math:`(V \land V)`, donc V
   - :math:`(p \land q) \lor r` vaut :math:`V \lor r`, qui vaut :math:`V \lor F`, donc V

Deux formules sont *équivalentes* si elles ont les mêmes valeurs de vérité quelles que soient
les valeurs initiales des propositions. Les
équivalences les plus courantes sont très utiles à connaître. En notant :math:`F, F_1, F_2` trois formules
quelconques, on a:

  - :math:`\neg (\neg F)` est équivalente à :math:`F` 
  - :math:`F_1 \land F_2` est équivalente à :math:`F_2 \land F_1` (commutativité)
  - :math:`F_1 \lor F_2` est équivalente à :math:`F_2 \lor F_1` (commutativité)
  - :math:`F \land (F_1 \land F_2)` est équivalente à :math:`(F\land F_1) \land F_2` (associativité)
  - :math:`F \lor (F_1 \lor F_2)` est équivalente à :math:`(F\lor F_1) \lor F_2` (associativité)
  - :math:`F \lor (F_1 \land F_2)` est équivalente à :math:`(F\lor F_1) \land (F \lor F_2)` (distribution)
  - :math:`F \land (F_1 \lor F_2)` est équivalente à :math:`(F\land F_1) \lor (F \land F_2)` (distribution)
  - :math:`\neg (F_1 \land F_2)` est équivalente à :math:`(\neg F_1) \lor (\neg F_2)` (loi DeMorgan)
  - :math:`\neg (F_1 \lor F_2)` est équivalente à :math:`(\neg F_1) \land (\neg F_2)` (loi DeMorgan)

Une *tautologie* est une formule qui est toujours vraie. La tautologie la plus évidente est

.. math::
   
    F \lor \neg F

Une *contradiction* est une formule qui est toujours fausse. La contradiction la plus évidente est

.. math::
   
      F \land \neg F

Vérifiez que ces notions sont claires pour vous: il est bien difficile d'écrire correctement du SQL
si on ne les maîtrise pas.

.. note::   Un connecteur très intéressant  est l'implication, noté :math:`\to`. 
   L'implication ne fait pas partie de connecteurs primaires car
   :math:`p \to q` est équivalent à :math:`\neg p \lor q`. Nous y revenons
   dans les exercices. Et, oui, l'implication a un lien avec les dépendances
   fonctionnelles: nous y revenons aussi!

Prédicats
=========

Une faiblesse de la logique propositionnelle est qu'elle ne considère que des énoncés "bruts", non décomposables.
Si je considère les  énoncés "Mozart a composé Don Giovanni", "Mozart a composé Cosi fan tutte",
et "Bach a composé la Messe en si", la logique propositionnelle ne permet pas
de distinguer qu'ils déclarent le même type de propriété (le fait de composer une œuvre)
liant des entités (Mozart, Bach, leurs œuvres). Il est impossible par exemple
en calcul propositionnel d'identifier que deux des propositions parlent de la
même entité, Mozart.

Les *prédicats* sont des extensions des propositions qui
énoncent des propriétés liant des objets. Un prédicat est de la forme
:math:`P (X_1, X_2, \cdots, X_n)`, avec :math:`n\geq 0`, :math:`P`
étant le nom du prédicat, et les :math:`X_i` désignant les entités liés
par la propriété.
On peut ainsi définir un 
prédicat :math:`Compose(X, Y)` énonçant une relation de type *X a composé Y* entre 
l'entité représentée par *X* et celle représentée par *Y*. 

Avec un prédicat, il est possible de donner un ensemble d'énoncés ayant tous la même
structure. Appelons ces énoncés des *nuplets* pour adopter une terminologie "bases de données" (un logicien
parlera plutôt d'atôme, ou de fait). Les trois propositions précédentes deviennent donc
les trois nuplets suivants:

.. code-block:: text

       Compose (Mozart, Don Giovanni)
       Compose (Mozart, Cosi fan tutte)
       Compose (Bach, Messe en si)

Cette fois, contrairement au langage propositionnel, on désigne explicitement les entités: compositeurs
(dont Mozart, qui apparaît deux fois) et œuvres. 
On obtient une collection de *nuplets* qui remplacent avantageusement
les propositions grâce à leur structure plus riche. 

Il existe virtuellement une infinité de nuplets énoncables avec un prédicat. Certains
sont faux, d'autres vrais. Comment les distingue-t-on? Tout dépend du contexte interprétatif.

Dans un contexte arithmétique par exemple, les prédicats courants sont l'égalité,
l'inégalité (stricte ou large) et leur négation. Le prédicat d'égalité s'applique
à deux valeurs numériques et  s'écrit :math:`=(x,y)`.  L'interprétation de ces prédicats 
(dans un contexte arithmétique encore une fois) est celle que nous connaissons "naturellement". 
On sait  par exemple que :math:`\geq(2, 1)` est vrai, et que  :math:`\geq(1, 2)` est faux.

Quand on modélise le monde réel,
les nuplets vrais doivent le plus souvent être énoncés explicitement comme, dans l'exemple ci-dessus,
les compositeurs et leurs œuvres. Une base
de données n'est rien d'autre que l'ensemble des nuplets considérés comme vrais
pour des prédicats applicatifs, tous les autres étant considérés comme faux.

Un système pourra nous dire que le nuplet suivant est faux (il n'est pas dans la base):

.. code-block:: text

       Compose (Bach, Don Giovanni)

Alors que le nuplet suivant est vrai (il appartient à la base):

.. code-block:: text

       Compose (Mozart, Don Giovanni)

Une réponse Vrai/Faux n'est pas forcément très utile. Nous restons pour l'instant
dans un système assez restreint où tous les nuplets font référence à des entités
connues. De tels nuplets sont dits *fermés*. Mais on peut également manipuler des nuplets
dits *ouverts*
dans lesquels certains objets sont inconnus, et remplacés par des variables habituellement dénotés :math:`x, y, z`. 
On obtient un langage beaucoup plus puissant.

Dans le nuplet ouvert suivant, le nom du compositeur est remplacé par une variable.

.. math::

       Compose (x, \rm{Don Giovanni})

Intuitivement, ce nuplet ouvert représente concisément tous les nuplets fermés
exprimant qu'un musicien :math:`x` a composé
une œuvre intitulée Don Giovanni. En affectant à :math:`x` toutes les valeurs possibles
(une variable est supposée couvrir un domaine de valeurs),
on énumère tous les nuplets de ce type. La plupart sont faux (ceux qui ne sont pas dans la base),
certains sont vrais. 

*Interroger une base relationnelle, c'est simplement demander au système
les valeurs de* :math:`x` *pour lesquelles* :math:`Compose (x, Don Giovanni)` *est vrai. La réponse
est probablement* ``Mozart``.

Collections et quantificateurs
==============================

L'ensemble des nuplets vrais d'un prédicat constitue une *collection*. Jusqu'à présent
nous avons évalué les valeurs de vérité au niveau de chaque nuplet individuel,
mais on peut également le faire sur l'ensemble de la collection grâce aux quantificateurs *existentiel*
et *universel*.

 - Le quantificateur existentiel. :math:`\exists x P(x)` est vrai s'il existe *au moins*
   une valeur de :math:`x` pour laquelle :math:`P(x)` est vraie.
 - Le quantificateur universel. :math:`\forall x P(x)` est vrai si 
   :math:`P(x)` est vraie pour toutes les valeurs de :math:`x`.

..  note:: Le quantificateur existentiel serait suffisant puisqu'il est possible d'exprimer
    la quantification universelle avec deux négations. Une propriété :math:`P` est *toujours*
    vraie s'il *n'existe pas* de cas où est *n'est pas* vraie. SQL ne connaît d'ailleurs
    que le ``exists``: voir plus loin.
    
On peut donc définir la forme complète des formules de la manière suivante:

.. admonition:: Définition: Syntaxe des formules

     - Un nuplet (ouvert ou fermé) :math:`P(a_1, a_2, \cdots, a_n)` est une formule
     - Si :math:`F_1` et :math:`F_2` sont deux formules, :math:`F_1 \land F_2`, :math:`F_1 \lor F_2`
       et :math:`\neg F_1` sont des formules.
     - Si :math:`F`  est une formule et si :math:`x` est une variable, alors  :math:`\exists x F` et :math:`\forall x F`
       sont des formules.

Les notions d'"ouvert" et de "fermé" se généralisent au niveau des formules: une formule
est *ouverte* si elle contient des variables qui ne sont liées par aucun quantificateur.
On les appelle les *variables libres*. Les formules ouvertes sont celles qui nous
intéressent en base de données, car elles reviennent à poser la question suivante: *quelles
sont les valeurs des variables libres qui satisfont (rendent vraie) la formule*?

Reprenons l'un des exemples précédents

.. math::

       Compose (x, \text{Don Giovanni})

Cette formule est ouverte, avec une seule variable libre; :math:`x`. Les valeurs
qui satisfont cette formule sont les noms des compositeurs qui ont écrit *Don Giovanni*.

Voici une autre formule dans laquelle le second composant est une  variable dite
"anonyme", notée :math:`\_`.  


.. math::

      Compose (x, \_)


.. admonition:: **Variable anonyme**

   Les variables anonymes sont celles dont la valeur ne nous intéresse pas
   et auxquelles on ne se donne donc même pas la peine de donner un nom.  Ecrire
   un nuplet :math:`P(\_, x, \_, \_)` est donc une facilité d'écriture pour ne
   pas avoir à nommer trois variables qui ne servent à rien. La notation complète serait 
   de la forme :math:`P(x_1, x, x_2, x_3)`.


La seule variable libre est :math:`x`, et les valeurs de :math:`x` qui satisfont la formule sont l'ensemble
des noms de compositeur. De fait, une formule :math:`F` avec des variables libres :math:`x_1, x_2, \cdots, x_n` 
définit un prédicat :math:`R(x_1, x_2, \cdots, x_n)`. L'ensemble des nuplets vrais de :math:`R`  est
l'ensemble des nuplets qui satisfont :math:`F`. Pour reprendre notre exemple, on pourrait
définir le prédicat *Compositeur* de la manière suivante:

.. math::

       Compositeur(x)  \leftarrow  Compose (x, \_)
       
Ce qui se lit: ":math:`x` est un compositeur s'il existe une valeur de :math:`y` telle que :math:`(x, y)` 
est un nuplet vrai de *Compose*.

Un schéma de base de données peut être vu comme la déclaration d'un ensemble de prédicats. Reprenons
un exemple déjà rencontré, celui des manuscrits évalués par des experts.

   -  Expert (id_expert, nom)
   -  Manuscrit (id_manuscrit, auteur, titre, id_expert, commentaire)

Ces prédicats énoncent des propriétés. Le premier nous dit que l'expert nommé ``nom``  
a pour identifiant ``id_expert``. Le second nous dit que le manuscrit identifié
par ``id_manuscrit`` s'intitule ``titre``, a été rédigé par ``auteur`` et évalué
part l'expert identifié par ``id_expert`` qui a ajouté un ``commentaire``.

Voici quelques formules sur ces prédicats. La première est vraie
pour toutes les valeurs de :math:`x` égales à l'identifiant d'un  expert nommé Serge.

.. math::

     Expert (x, \text{'Serge'})

La seconde est vraie pour toutes les valeurs de :math:`t` titre du manuscrit d'un auteur nommé Proust.

.. math::

      Manuscrit (\_, \text{'Proust'},  t,  \_)
      
Enfin,  la troisième est vraie pour toutes les valeurs de :math:`t` , :math:`x`  et :math:`n` telles que
:math:`t` est le titre du manuscrit d'un auteur nommé Proust, évalué par un expert
identifié par :math:`x` et nommé :math:`n`.

.. math::
  
      Manuscrit (\_, \text{'Proust'}, t, x, \_) \land Expert (x, n)

Notez que la variable :math:`x` est utilisée à la fois dans ``Manuscrit`` et dans
``Expert``. Cela contraint une valeur de :math:`x` à être *à la fois* un identifiant
d'un expert dans ``Expert``, et la valeur de la clé étrangère de cet expert dans
``Manuscrit`` Autrement dit l'énoncé de cette formule lie un manuscrit à l'expert
qui l'a évalué. Ce mécanisme de lien par partage de valeur, nommé *jointure*  est fondamental dans l'interrogation
de bases relationnelles; nous aurons l'occasion d'y revenir longuement.

Voici une dernière formule qui illustre l'utilisation des quantificateurs.

.. math::

    Expert (x, n) \land \exists Manuscrit (\_, \text{'Proust'}, \_, x, \_) 

Cette formule s'énonce ainsi: tous les experts :math:`n` qui ont évalué *au moins* 
un manuscrit d'un auteur nommé Proust. Notez encore une fois la présence de l'identifiant
de l'expert dans les deux nuplets libres, sur Expert et Manuscrit.

Logique et bases de données
===========================

Ce qui précède  peut sembler inutilement conceptuel ou compliqué, surtout au vu de 
la simplicité des exemples donnés jusqu'à présent. Il faut bien réaliser que  ces exemples
ne sont qu'une illustration
d'une méthode d'interrogation très générale dans laquelle on demande au système de nous fournir,
à partir des nuplets de la base (ceux considérés comme vrais), toutes les informations qui 
satisfont une propriété logique. Cette propriété s'exprime dans le langage de la logique
formelle, ce qui offre des avantages décisifs:

  - la signification d'une formule et précise, non ambiguë;
  - il existe des algorithmes efficaces pour évaluer la valeur de vérité d'une formule;
  - le langage est robuste, universellement connu et adopté, ce qui permet d'obtenir
    un mode d'interrogation *normalisé*.
  - enfin, ce langage est totalement *déclaratif*: exprimer une formule
    ne donne  aucune indication sur la manière dont le système doit trouver le résultat.

SQL, dans sa forme déclarative, qui est la forme d'origine, est un langage concret pour écrire
des formules logiques que le SGBD se charge d'interpréter et de calculer. Reprenons la
formule:

.. math::

       Compose (x, \text{Don Giovanni})

Voici la requête SQL
correspondante.

.. code-block:: sql
    
       select compositeur
       from Compose
       where oeuvre='Don Giovanni'

Et voici la forme SQL des deux dernières formules sur les experts (avec jointure)

.. code-block:: sql
    
       select titre, nom
       from Expert, Manuscrit
       where Expert.id_expert = Manuscrit.id_expert
       and auteur = 'Proust'

.. code-block:: sql
    
       select nom
       from Expert
       where exists (select *
                    from Manuscrit
                    where Expert.id_expert = Manuscrit.id_expert
                    and auteur = 'Proust')

Maîtriser l'expression
des formules et, surtout, comprendre leur signification précisément, est donc une condition
pour utiliser SQL correctement.

Quiz
====


.. eqt:: calcul1

    Parmi les énoncés ci-dessous, lesquels sont des propositions?
    
    A) :eqt:`C` Je suis inscrit au Cnam
    #) :eqt:`I` A quelle heure commence le cours?
    #) :eqt:`C` J'ai rencontré des extraterrestres

.. eqt:: calcul2

    Un connecteur "ou" est exclusif si exactement l'une des deux propositions est vraie.
    Le "ou" logique présenté ci-dessus est-il exclusif?
    
    A) :eqt:`C` Non
    #) :eqt:`I` Oui

.. eqt:: calcul6

    Qu'est-ce qu'un nuplet fermé?

    A) :eqt:`C` C'est un nuplet sans variable
    #) :eqt:`I` C'est un nuplet liant un nombre fixe d'entités
    #) :eqt:`I` C'est un nuplet liant 0 entités

.. eqt:: calcul7

    Qu'est-ce qu'une variable libre?

    A) :eqt:`I` Une variable représentant n'importe quelle entité du prédicat
    #) :eqt:`C` Une variable non liée par un quantificateur
    #) :eqt:`I` C'est une variable externe au prédicat

.. eqt:: calcul8

    Quel est le rôle des variables libres dans un contexte de base de données?

    A) :eqt:`I` Elles représentent les valeurs auxquelles on ne s'intéresse pas
    #) :eqt:`C` Elles représentent les valeurs qui satisfont le prédicat
    #) :eqt:`I` Elles représentent les valeurs pour lesquelles on ne sait pas si le prédicat est vrai ou faux

.. eqt:: calcul9

    Quellles valeurs de :math:`x` satisfont la formule suivante:
    
    .. math::
      
           Compose (x, x)

    A) :eqt:`I` Aucune, car cette formule n'a pas de sens
    #) :eqt:`C` Les compositeurs qui ont le même nom qu'une de leur composition
    #) :eqt:`I` Cette formule est vraie pour toutes les valeurs de :math:`x` 

******************
S2: SQL conjonctif
******************

.. admonition::  Supports complémentaires:

    * `Diapositives: SQL conjonctif <http://sql.bdpedia.fr/files/slsqlconjonctif.pdf>`_
    * `Vidéo sur la première partie de SQL <https://mediaserver.cnam.fr/videos/sql-conjonctif/>`_ 


Cette session présente le langage SQL dans sa version déclarative, chaque requête s'interprétant
par une formule logique. La base de données est constituée d'un ensemble de relations
vues comme des prédicats. Ces relations contiennent des nuplets (fermés, sans variable).

.. note:: Prédicats ou relations ?

   Un prédicat énonce une propriété liant des objets, et est donc synonyme de *relation*
   au sens mathématique du terme. Les deux termes peuvent être utilisés de manière interchangeable.

Pour illustrer les requêtes et leur interprétation, nous prenons la base des voyageurs présentée
dans le chapitre :ref:`chap-modrel`. Vous pouvez expérimenter toutes les  requêtes présentées
(et d'autres) directement sur note site http://deptfod.cnam.fr/bd/tp. Voir également
l'atelier SQL proposé en fin de chapitre.

Cette session se limite à la partie dite "conjonctive" de SQL,
celle où toutes les requêtes peuvent s'exprimer sans négation. La prochaine session complètera le langage.

Requête mono-variable
=====================

Dans les requêtes relationnelles, les variables ne désignent pas des valeurs individuelles,
mais des nuplets libres. Une variable-nuplet :math:`t` a donc des composants :math:`a_1, a_2, \dots a_n`
que l'on désigne par :math:`t.a_1, t.a_2, \cdots, t.a_n`. Par souci de simplicité,
on nomme souvent les variables comme les attributs du schéma, mais ce n'est pas
une obligation.

Commençons par étudier les requêtes utilisant une seule variable. Leur forme générale est

.. code-block:: sql

     select [distinct] t.a1, t.a2, ..., t.an
     from T as t
     where <condition>
     
Ce "bloc" SQL comprend trois clauses:  le ``from`` définit la variable libre et 
ce que nous appellerons la  *portée* de cette variable, le 
``where`` exprime les conditions sur la variable libre, enfin le ``select``, accompagné
du mot-clé optionnel ``distinct``,  construit le nuplet 
constituant le résultat. Cette requête correspond à la formule :

.. math::

     \{ t.a_1, t.a_2, \cdots, t.a_n | T(t) \land F_{cond}(t) \}

L'interprétation est la suivante: je veux constituer tous les nuplets
*fermés* :math:`(t.a_1, t.a_2, \cdots, t.a_n)` dont les
valeurs satisfont la formule :math:`T(t) \land F_{cond}`.
Cette formule comprend toujours deux parties: 
 
    - La première, :math:`T(t)` indique que la variable :math:`t` est un nuplet de la relation :math:`T`. 
      Autrement dit  :math:`T(t)` est vraie si  :math:`t \in T`. Nous appelons donc
      cette partie la *portée*.
    - La seconde, :math:`F_{cond}(t)`, est une formule logique sur :math:`t`, 
      que nous appellons la *condition*.

.. important:: La portée définit les variables libres de la formule, celles pour lesquelles
   on va chercher l'affectation qui satisfait la condition :math:`F_{cond}(t)`, et à partir desquelles on va construire
   le nuplet-résultat. Reportez-vous à la session précédente pour la notion de variable libre
   dans une formule et leur rôle dans un système d'interrogation.

À propos du ``distinct``
------------------------

Une relation ne contient pas de doublon. La présence de doublons (deux unités d'information
indistinguables l'une de l'autre) dans un système d'information est une anomalie. Pour
prendre quelques exemples applicatifs, on ne veut pas envoyer deux fois le même
message, on ne veut pas produire deux fois la même facture, on ne veut
pas afficher deux fois le même document, etc. Vous pouvez vérifier que votre moteur
de recherche préféré applique ce principe.

Les relations de la base sont en première forme normale, et la présence de doublons est
évitée par la présence d'au moins une clé. Qu'en est-il des relations calculées,
autrement dit le résultat des requêtes? 
Supposons que l'on souhaite connaître tous
les types de logements. Voici la requête SQL sans ``distinct``: 

.. code-block:: sql

    select type
    from Logement
    
On obtient une relation avec deux nuplets identiques.

 .. csv-table:: 
    :header:   "type"
    :widths:  15

    Gîte
    Hôtel
    Auberge
    Hôtel

Sans ``distinct``, SQL peut produire des relations avec doublons. Du point de vue logique,
cela montre simplement que l'on a établi le même fait de deux manières différentes, mais cela
ne sert à rien d'afficher ce fait deux fois (ou plus).
Si on ajoute ``distinct``

.. code-block:: sql

    select distinct type
    from Logement
    
on obtient

.. csv-table:: 
    :header:   "type"
    :widths:  15

    Gîte
    Hôtel
    Auberge

Pourquoi SQL n'élimine-t-il pas systématiquement les doublons?
En premier lieu parce que cette élimination 
implique un algorithme potentiellement  coûteux si la relation en entrée
est très grande. Il faut en effet effectuer un tri suivi 
d'une élimination des nuplets identiques. 
Sur des petites relations, la différence en temps d'exécution
est indiscernable, mais elle peut devenir  significative 
quand on a des centaines de milliers de nuplets ou plus.
Les concepteurs du langage SQL  ont fait le choix, par défaut,
d'éviter d'appliquer cet algorithme, ce qui revient à accepter 
de produire éventuellement des doublons.

Une seconde raison pour ne pas appliquer systématiquement l'algorithme d'élimination
de doublons est que certaines requêtes, par construction, produisent un résultat
sans doublons. Voici un exemple très simple

.. code-block:: sql

    select code, type
    from Logement

Inutile dans ces cas-là d'utiliser ``distinct`` (voyez-vous pourquoi?). En d'autres termes: SQL nous
laisse la charge de décider quand une requête risque de produire des doublons,
et si nous souhaitons les éliminer. *Dans tout ce cours nous utilisons* ``distinct``
*chaque fois que c'est nécessaire pour toujours obtenir un résultat en première forme
normale, sans doublon.*


.. admonition:: Comment savoir si une requête risque de produire des doublons?

   C'est une bonne question. L'exemple donné ci-dessus nous donne une piste: il nous
   faut des dépendances fonctionnelles dans le résultat! Voir l'atelier en fin de chapitre.

Il est par ailleurs très utile, quand on exprime une requête, de réfléchir à la possibilité
qu'elle produise ou non des doublons et donc à la nécessité
d'utiliser ``distinct``. Si une requête produit potentiellement
des doublons, il est sans doute pertinent de se demander 
quel est le sens du résultat obtenu. 

Exemples
--------

Voici une première requête concrète sur notre base. On veut le nom et le type des logements corses.


.. code-block:: sql

      select t.code, t.nom, t.type
      from Logement as t
      where t.lieu = 'Corse'

.. note:: Pour distinguer les chaînes de caractères des noms d'attribut, on les encadre
   par des apostrophes simples.

Elle correspond à la formule:
      
.. math::

     \{ t.code, t.nom, t.type | Logement(t) \land t.lieu=\text{'Corse'} \}

.. note:: SQL permet, quand c'est possible, quelques légères simplifications syntaxiques. La forme 
   simplfiée de la requête précédente est donnée ci-dessous. 

   .. code-block:: sql

      select code, nom, type
      from Logement
      where lieu = 'Corse'

   On peut donc omettre de spécifier le nom de la variable quand il n'y a pas d'ambiguité, notamment l'interprétation
   du nom des champs.

Elle s'interprète de la manière suivante: on cherche les affectations d'une variable :math:`t`
parmi les nuplets de la relation ``Logement``, telle que ``t.lieu`` ait pour valeur "Corse".

De cette interprétation, assez évidente pour l'instant, il faut retenir qu'une table mentionnée dans
le ``from`` de SQL définit en fait une variable dont la portée est la table (ici, ``Logement``). Parmi
toutes les affectations possibles de cette variable, on ne conserve que celles qui satisfont
la condition exprimée par le reste de la formule. 

Le système d'évaluation peut donc considérer que :math:`t` est affectée à n'importe lequel
des nuplets de la table, et évaluer si cette affectation satisfait la condition. Dans la table
ci-dessous, la croix indique à quel nuplet :math:`t` est affectée. Ici, la condition n'est clairement
pas satisfaite.


.. csv-table:: 
   :header:  "t", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 4, 15, 5, 10, 15

   ,pi, U Pinzutu,  10,  Gîte, Corse
   ,ta, Tabriz,  34,  Hôtel, Bretagne
   X ,ca, Causses,  45,  Auberge, Cévennes
   ,ge, Génépi,  134, Hôtel, Alpes

En revanche, quand l'affectation est faite comme indiquée ci-dessous, la condition est satisfaite. 
L'affectation de la variable :math:`t` satisfait alors l'ensemble 
de la formule et sert à construire le nuplet-résultat.

.. csv-table:: 
   :header:  "t", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 4, 15, 5, 10, 15

   X ,pi, U Pinzutu,  10,  Gîte, Corse
   ,ta, Tabriz,  34,  Hôtel, Bretagne
   ,ca, Causses,  45,  Auberge, Cévennes
   ,ge, Génépi,  134, Hôtel, Alpes


À partir de là, il suffit de savoir exprimer  une formule pour spécifier correctement une requête SQL. 

Voici quelques exemples. Cherchons d'abord quels hôtels sont dans les Alpes. La requête SQL est:
  
.. code-block:: sql

        select t.code, t.nom
        from Logement as t
        where t.type = 'Hôtel' and t.lieu = 'Alpes'
        
Elle correspond à la requête logique 

.. math::

     \{ t.code, t.nom | Logement(t) \land t.type=\text{'Hôtel'} \land t.lieu=\text{'Alpes'}\}

La condition à satisfaire pour un nuplet de la relation ``Logement`` 
est :math:`t.type=\text{'Hôtel'} \land t.lieu=\text{'Alpes'}`. C'est seulement le cas pour 
le dernier nuplet. Cherchons maintenant les hôtels qui, soit sont en Bretagne, soit
ont au moins 100 chambres. La version SQL:

  
.. code-block:: sql

        select t.code, t.nom
        from Logement as t
        where t.type = 'Hôtel' and (t.lieu = 'Alpes' or t.capacité >= 100)

Et sa version logique:

.. math::

     \{ t.code, t.nom | Logement(t) \land t.type=\text{'Hôtel'}  \land (t.lieu=\text{'Alpes'} \lor t.capacité \geq 100)\}

Requêtes multi-variables
========================

Voypns maintenant le cas général où on s'autorise à utiliser plusieurs variables. Pour simplifier
la notation, nous allons étudier les requêtes avec exactement deux variables. Il est facile
ensuite de généraliser.

Leur forme est

.. math::

     \{ t_1.a_1, \cdots, t_1.a_n, t_2.b_1, \cdots, t_2.b_m | T_1(t_1) \land T_2(t_2) \land F_{cond}(t_1, t_2) \}

On retrouve dans la formule les deux parties: la portée indique les relations respectives
qui servent de domaine d'affectation pour :math:`t_1` et :math:`t_2`; la condition
est une formule avec  :math:`t_1` et :math:`t_2` comme variables libres.


La transcription en SQL est presque littérale.

.. code-block:: sql

     select [distinct] t1.a1, ..., t1.an, t2.b1, ..., t2.bm
     from T1 as t1, T2 as t2
     where <condition>

L'interprétation est exactement la même que pour les requêtes mono-variables, légèrement
généralisée: *parmi toutes les affectations possibles des variables, 
on ne conserve que celles qui satisfont la condition exprimée par le reste de la formule*.

Il n'y a rien de plus à comprendre. Il suffit de considérer toutes les affectations possibles de
:math:`t_1` et :math:`t_2` et de ne garder que celles pour lesquelles la formule de condition
est satisfaite. 

Voici quelques exemples. On veut les noms des logements où on peut pratiquer le ski. Nous 
avons besoin de deux variables:

  - la première s'affecte aux nuplets de la table ``Activité``; on ne veut que 
    ceux dont le code est ``Ski``.
  - la seconde s'affecte aux nuplets de la table ``Logement``
  
Enfin, une condition doit lier les deux variables: on veut qu'elles soient relatives
au même logement, et donc que le code logement soit identique.
Voici la formule, suivie de la requête SQL. 

.. math::

     \{ l.code, l.nom | Logement(l) \land Activité(a) \land l.code = a.codeLogement \land a.codeActivité=\text{'Ski'} \}

Remarquons au passage que le nom  que l'on donne aux variables n'a aucune importance. 
Nous utilisons ``l`` pour le logement, ``a``  pour l'activité.

.. code-block:: sql

     select l.code, l.nom
     from Logement as l, Activité as a
     where l.code = a.codeLogement
     and   a.codeActivité = 'Ski'

Les seules affectations  de :math:`l` et :math:`a` satisfaisant la formule
sont marquées par des croix dans les tables ci-dessous
(les champs concernés ont de plus été mis en gras). 
Prenez, si nécessaire, le temps de bien comprendre
que d'une part la formule de condition est bien satisfaite, et d'autre part qu'il n'y a pas d'autre solution
possible.

.. csv-table:: 
   :header:  "l", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 4, 15, 5, 10, 15

    ,pi, U Pinzutu,  10,  Gîte, Corse
   ,ta, Tabriz,  34,  Hôtel, Bretagne
   ,ca, Causses,  45,  Auberge, Cévennes
   X ,**ge**, Génépi,  134, Hôtel, Alpes

.. csv-table:: 
   :header:  "a", "codeLogement",  "codeActivité", "description"
   :widths: 2, 4, 7, 10
   
   ,pi, Voile, "Pratique du dériveur et du catamaran"
   ,pi, Plongée, "Baptèmes et préparation des brevets"
   ,ca, Randonnée, "Sorties d'une journée en groupe"
   X, **ge**, **Ski**, "Sur piste uniquement"
   ,ge, Piscine, "Nage loisir non encadrée"

A partir de ces deux affectations, on construit le résultat.

.. csv-table:: 
   :header:   "code",  "nom"
   :widths: 4, 15

   ge, Génépi

Pour maîtriser cette partie de SQL (sans doute la plus couramment utilisée), il faut bien comprendre 
le mécanisme mis en œuvre. Pour construire un nuplet du résultat, nous avons besoin de 1, 2 ou plus
nuplets provenant de la base. Il faut identifier ces nuplets, les conditions qu'ils doivent satisfaire, et
les valeurs qu'ils partagent. Ici:

   - nous avons besoin d'un nuplet de la relation ``Activité``, tel que le code soit ``Ski``;
   - nous avons besoin d'un nuplet de la relation ``Logement``, puisque nous souhaitons
     obtenir le nom du logement en sortie;
   - enfin ces nuplets doivent être relatifs au même logement, et partager donc la même valeur
     sur l'attribut qui identifie ce logement, respectivement ``code`` dans ``Logement`` 
     et ``codeLogement`` dans ``Activité``.
     
Ce raisonnement est très général et permet d'exprimer des requêtes SQL puissantes. Les seules
conditions sont de formuler rigoureusement la requête et de comprendre le schéma de la base. 

Prenons un autre exemple montrant que l'on peut utiliser la même portée pour des variables
différentes. On veut
obtenir les paires de logements qui sont du même type. Puisqu'il nous faut deux logements, 
nous avons besoin de deux variables, ayant chacune pour portée la table ``Logement``. Ces
deux variables doivent partager la même valeur pour l'attribut ``type``. Voici la formule:

.. math::

     \{ l_1.nom, l_2.nom | Logement(l_1) \land Logement(l_2) \land l_1.type = l_2.type \}

Les deux variables ont été nommées respectivement :math:`l_1` et :math:`l_2`. La syntaxe SQL est donnée ci-dessous.

.. code-block:: sql

     select distinct l1.nom as nom1, l2.nom as nom2
     from Logement as l1, Logement as l2
     where l1.type = l2.type

.. note:: Dans la syntaxe SQL, il faut résoudre les ambiguités éventuelles sur les
   noms d'attributs avec ``as``. Ici, on a nommé le nom du premier
   logement ``nom1`` et celui du second ``nom2`` pour obtenir en sortie
   une relation de schéma ``(nom1, nom2)``.
   
Il existe plusieurs affectations  de ``l1`` et ``l2`` pour lesquelles la formule
est satisfaite. La première est donnée ci-dessous: ``l1`` est affectée à la seconde ligne
et ``l2`` à la quatrième.

.. csv-table:: 
   :header:  "l1", "l2", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 2, 4, 15, 5, 10, 15

   , ,pi, U Pinzutu,  10,  Gîte, Corse
   X, ,ta, Tabriz,  34,  Hôtel, Bretagne
   , ,ca, Causses,  45,  Auberge, Cévennes
   , X , ge, Génépi,  134, Hôtel, Alpes

Mais la formule est également satisfaite si on inverse les affectations: ``l1`` est à la quatrième ligne
et ``l2`` à la seconde. 

.. csv-table:: 
   :header:  "l1", "l2", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 2, 4, 15, 5, 10, 15

   , ,pi, U Pinzutu,  10,  Gîte, Corse
   , X,ta, Tabriz,  34,  Hôtel, Bretagne
   , ,ca, Causses,  45,  Auberge, Cévennes
   X,  , ge, Génépi,  134, Hôtel, Alpes

Et, surprise, elle est également satisfaite si les deux variables sont affectées au *même* nuplet.


.. csv-table:: 
   :header:  "l1", "l2", "code",  "nom", "capacité", "type", "lieu"
   :widths: 2, 2, 4, 15, 5, 10, 15

   X, X ,pi, U Pinzutu,  10,  Gîte, Corse
   , ,ta, Tabriz,  34,  Hôtel, Bretagne
   , ,ca, Causses,  45,  Auberge, Cévennes
   ,  , ge, Génépi,  134, Hôtel, Alpes

Pour éviter les inversions et auto-égalités,  on peut ajouter une condition:


.. code-block:: sql

     select distinct l1.nom as nom1, l2.nom as nom2
     from Logement as l1, Logement as l2
     where l1.type = l2.type
     and l1.nom < l2.nom

Le résultat de cette requête est alors:


.. csv-table:: 
   :header:  "nom1", "nom2"
   :widths:  8, 8

   Génépi, Tabriz


.. admonition:: Interprétation d'une requête SQL

   En résumé, *quelle que soit sa complexité*, l'interprétation d'une requête SQL peut *toujours*
   se faire de la manière suivante.

     - Chaque variable du ``from`` peut être affectée à tous les nuplets
       de sa portée.
     - Le ``where`` définit une condition sur ces variables: seules
       les affectations satisfaisant cette condition sont conservées
     - Le nuplet résultat est construit à partir de ces affectations

Remarquez que ce mode d'interrogation n'indique en aucune manière, même de très loin, comment
le résultat est calculé. On est (pour insister) dans une approche purement *déclarative* où
le système est totalement libre de déterminer la méthode la plus efficace.

Quiz
====

.. eqt:: conjonctif1

    Une variable en SQL désigne
    
    A) :eqt:`C` Un nuplet
    #) :eqt:`I` Une valeur d'attribut
    #) :eqt:`I` Une table

.. eqt:: conjonctif2

    Quand faut-il appliquer un ``distinct`` ?
    
    A) :eqt:`I` Toujours
    #) :eqt:`C` Quand on risque d'obtenir des doublons dans le résultat
    #) :eqt:`I` Quand il y a des doublons dans la table

.. eqt:: conjonctif3

    Le nom d'une variable doit-il être la première lettre du nom de la table?
    
    A) :eqt:`I` Oui
    #) :eqt:`C` Non

.. eqt:: conjonctif3bis

    Si :math:'x' et :math:'y' sont deux variables, alors toute égalité 
    :math:`x.a=y.b`dans la clause ``where`` doit se faire sur des clés primaires et étrangères

    A) :eqt:`I` Oui
    #) :eqt:`C` Non


.. eqt:: conjonctif4

    Que représente le nombre de variables dans une requête?
    
    A) :eqt:`I` Le nombre de tables auxquelles on accède
    #) :eqt:`C` Le nombre de nuplets nécessaire pour exprimer la requête
    #) :eqt:`I` Le nombre de valeurs dans le nuplet-résultat

.. eqt:: conjonctif5

    Pour une table ``T`` donnée, combien de variables dans une requête peuvent-elles
    avoir ``T``  pour portée?
    
    A) :eqt:`I` Une
    #) :eqt:`I` Deux 
    #) :eqt:`C` Un nombre quelconque, mais fixé par la requête
    #) :eqt:`I` Un nombre quelconque et variable

.. eqt:: conjonctif6

    À quoi sert le ``as`` dans le ``from``?
    
    A) :eqt:`I` À renommer la table
    #) :eqt:`I` À renommer des attributs pour éviter les doublons
    #) :eqt:`C` À définir une variable nuplet dont la portée est la table
    #) :eqt:`I` À copier une table dans une autre

.. eqt:: conjonctif7

    À quoi sert le ``as`` dans le ``select``?
    
    A) :eqt:`I` À renommer la table
    #) :eqt:`C` À renommer des attributs pour éviter les doublons
    #) :eqt:`I` À définir une variable nuplet dont la portée est la table
    #) :eqt:`I` À copier une table dans une autre

*******************************
S3: Quantificateurs et négation
*******************************


.. admonition::  Supports complémentaires:

    * `Diapositives: SQL: quantificateurs et négation <http://sql.bdpedia.fr/files/slnegation.pdf>`_
    * `Vidéo sur les quantificateurs et la négation dans SQL <https://mediaserver.cnam.fr/videos/quantificateurs-et-negation/>`_ 


Jusqu'à présent les seules variables que nous utilisons sont des variables libres de la formule,
définies dans la clause ``from`` de la syntaxe SQL. Nous n'avons pas encore rencontré de variable liée
parce que nous n'avons pas utilisé les quantificateurs.

SQL propose uniquement le quantificateur existentiel. Le quantificateur universel
peut être obtenu en le combinant avec la négation. Rappelons que les quantificateurs
servent à exprimer des conditions sur l'ensemble d'une relation (qui peut être une relation en base, ou 
une relation calculée). Ils sont particulièrement utiles pour les requêtes qui comportent
des *négations* ("je *ne* veux *pas* des objets qui ont telle ou telle propriété dans mon résultat").

Le quantificateur ``exists``
============================

Reprenons simplement la requête qui demande les logements où l'on peut faire du ski.
La formule donnée précédemment est la suivante:

.. math::

     \{ l.nom | Logement(l) \land Activité(a) \land l.code = a.codeLogement \land a.codeActivité=\text{'Ski'} \}

On remarque que la variable libre :math:`a` n'est pas utilisée dans la construction du nuplet-résultat
(qui ne contient que ``l.nom``). 
On pourrait donc affecter le nuplet ``a`` à une variable liée, ce qui
revient à formuler la requête légèrement différemment: "donnez-moi le nom
des logements pour lesquels *il existe une activité* Ski".

Ce qui donne la formule suivante:

.. math::

     \{ l.nom | Logement(l) \land \exists a (Activité(a) \land l.code = a.codeLogement \land a.codeActivité=\text{'Ski'})\}

On a introduit la sous-formule suivante:

.. math::

     \exists a (Activité(a) \land l.code = a.codeLogement \land a.codeActivité=\text{'Ski'})

Cette sous-formule est satisfaite dès que l'on a trouvé *au moins* un nuplet qui satisfait les conditions
demandées, à savoir un code activité égal à ``Ski``, et le même code logement
que celui de la variable :math:`l`.

Qui dit sous-formule dit logiquement sous-requête en SQL. Voici la syntaxe:


.. code-block:: sql

     select distinct l.nom
     from Logement as l
     where exists (select ''
                   from Activité as a
                   where l.code = a.codeLogement
                   and a.codeActivité = 'Ski')

Le résultat est construit à partir du ``select`` de premier niveau, qui ne peut accéder qu'à la variable 
``l``, et pas à la variable (liée) ``a``. 

.. note:: La clause du ``select`` imbriquée ne sert donc absolument
   à rien d'autre qu'à respecter la syntaxe SQL, et on peut utiliser ``select ''``, ``select *`` 
   ou n'importe quoi d'autre.

Cet exemple montre qu'il est possible d'exprimer une même requête avec des syntaxes différentes, que ce soit
au niveau de la formulation en langage naturel ou de l'expression formelle (logique ou SQL).

Les quantificateurs permettent d'imbriquer des formules dans des formules, sans limitation
de profondeur. En SQL, on peut de même avoir des imbrications de requêtes sans limitation. La
lisibilité et la compréhension en sont quand même affectées.

Prenons une requête un peu plus complexe: je veux les noms des voyageurs qui sont allés dans les Alpes.
Une première formulation, complètement "à plat" est la suivante:

.. code-block:: sql

     select distinct v.prénom, v.nom
     from Voyageur as v, Séjour as s, Logement as l
     where v. idVoyageur=s.idVoyageur
     and   s.codeLogement = l .code
     and   l.lieu = 'Alpes'
     
Ni la variable ``s``, ni la variable ``l``  ne sont utilisées
pour construire le nuplet-résultat. On peut donc  l'exprimer ainsi: "je veux les noms des voyageurs pour lesquels il existe un séjour dans les Alpes".
Ce qui donne:

.. code-block:: sql

     select distinct v.prénom, v.nom
     from Voyageur as v
     where exists (select '' 
                   from Séjour as s, Logement as l
                   where v. idVoyageur=s.idVoyageur
                   and   s.codeLogement = l .code
                   and   l.lieu = 'Alpes')

On pourrait même aller encore plus loin dans l'imbrication avec la requête suivante:


.. code-block:: sql

     select distinct v.prénom, v.nom
     from Voyageur as v
     where exists (select '' 
                   from Séjour as s
                   where v. idVoyageur=s.idVoyageur
                   and exists (select '' 
                               from  Logement as l
                                where s.codeLogement = l .code
                                and   l.lieu = 'Alpes')
                    )

La troisième version correspond à la formulation "Les voyageurs tels *qu'il existe* un de leurs séjours 
tels que le logement *existe* dans  les Alpes". Elle n'est pas très naturelle, et, de plus, probablement
la plus difficile à comprendre, ce qui ne plaide pas
en sa faveur. 

Quantificateurs et négation
===========================

Il nous reste à découvrir les requêtes probablement les plus complexes, celle où l'on exprime
une négation. Voici un premier exemple:on veut les logements qui ne proposent pas de Ski. En reprenant
la requête "positive" étudiée précédemment, il suffit d'ajouter une négation devant le quantificateur
existentiel. 

.. math::

     \{ l.nom | Logement(l) \land \not \exists a (Activité(a) \land l.code = a.codeLogement \land a.codeActivité=\text{'Ski'})\}

On a donc formulé la requête en termes logiques: "je veux les logements tels
*qu'il n'existe pas* d'activité Ski".
Voici la requête SQL.

.. code-block:: sql

     select distinct l.nom
     from Logement as l
     where not exists (select ''
                      from Activité as a
                      where l.code = a.codeLogement
                      and a.codeActivité = 'Ski')

C'est la seule manière de l'exprimer correctement. Elle donne le résultat suivant:

..  csv-table::
    :header: nom

    Causses
    U Pinzutu
    Tabriz


Vous devriez ête convaincus que la requête suivante
est très différente (et ne correspond pas à ce que l'on souhaite). L'opérateur ``!=`` signifie
*différent de* en SQL.

.. code-block:: sql

     select l.nom
     from Logement as l
     where  exists (select ''
                      from Activité as a
                      where l.code = a.codeLogement
                      and a.codeActivité != 'Ski')

Dont le résultat est:

..  csv-table::
    :header: nom

    Causses
    Génépi
    U Pinzutu

Réfléchissez au sens de cette requête, trouvez le résultat sur notre petite base. Rappelez-vous que les quantificateurs
servent à exprimer une condition sur un ensemble de nuplets, pas sur chaque nuplet en particulier.

Le ``not exists``  est la porte d'entrée pour exprimer le quantificateur universel. Supposons que l'on
cherche les voyageurs qui sont allés dans *tous* les logements. On reformule cette requête avec 
deux négations: on cherche les voyageurs tels *qu'il n'existe pas* de logement où *ils ne sont pas* allés.
    

.. code-block:: sql

     select distinct v.prénom, v.nom
     from Voyageur as v
     where  not exists (select ''
                        from Logement as l
                        where not exists  (select ''
                                           from Séjour as s
                                           where l.code = s.codeLogement
                                           and   v.idVoyageur = s.idVoyageur)
                        )

Vous devriez obtenir:

..  csv-table::
    :header: prénom, nom

    Nicolas , Bouvier

Vous savez maintenant tout sur la version déclarative de SQL, qui n'est
rien d'autre qu'une syntaxe concrète pour exprimer des formules ouvertes sur une base de données. 
Tout ce qui peut s'exprimer par une formule logique est exprimable en SQL. Ni plus, ni moins.
Inversement, tout ce qui ne s'exprime pas par une formule (boucles, incrémentations, etc.)
ne s'exprime pas en SQL.


Dans le prochain chapitre, nous verrons la version procédurale, mais il est important de préciser
qu'elle n'apporte *rien* en terme de possibilités d'expression. En d'autres termes, vous avez déjà, avec
ce que nous venons d'étudier, la capacité d'exprimer toutes les requêtes possibles
(à l'exception des agrégations). La version
procédurale n'est qu'une manière alternative de concevoir l'interrogation d'une base relationnelle.

Prenez le temps de bien maîtriser ce qui précède, car la compréhension du *sens* de ce que l'on exprime
avec les formules de logique des prédicats est la condition nécessaire et suffisante pour utiliser
correctement SQL.

Quiz
====



.. eqt:: negation1

    La quantification apporte un nouveau moyen d'expression. Comment le qualifier?
    
    A) :eqt:`I` C'est la possibilité de vérifier une propriété sans accéder à la base?
    #) :eqt:`C` C'est la possibilité d'exprimer une condition sur un ensemble de nuplets, et 
       pas sur un seul
    #) :eqt:`I` C'est la possibilité de créer deux formules indépendantes


.. eqt:: negation2

    L'utilisation de la quantification existentielle implique que
    
    A) :eqt:`C` On ne veut pas utiliser la variable liée (celle du bloc imbriqué)
       pour construire le nuplet résultat
    #) :eqt:`C` Le résultat de la requête imbriquée ne doit contenir qu'un seul nuplet 
       pour que la clause ``exists`` soit considérée comme vraie
    #) :eqt:`I` Les conditions sur la variable liée sont toujours indépendantes de celles sur les variables libres


.. eqt:: negation3

    Deux requêtes syntaxiquement différentes sont *équivalentes* si
    
    A) :eqt:`I` Elles peuvent donner le même résultat
    #) :eqt:`C` Elles donnent toujours le même résultat
    #) :eqt:`I`  Elles sont exactement écrites de la même manière
	# ) :eqt:`I` Le temps d'exécution est le même

.. eqt:: negation4

    Les deux requêtes suivantes
    
      - Je veux les voyageurs qui ne sont pas allés en Corse
      - Je veux les voyageurs qui sont allés ailleurs qu'en Corse
    
    sont-elles équivalentes?
    
    A) :eqt:`I` Oui
    #) :eqt:`C` Non

.. eqt:: negation5

    Interprétons la requête
    
    .. code-block:: sql
    
         select * from Logement as l 
         where not exists (select * from Activité as a 
                           where a.activité='Ski')"
    
    A) :eqt:`I` Les logements où on fait du ski
    #) :eqt:`C` Tous les logements, s'il en existe un où on fait du ski
    #) :eqt:`I` Les logements où on ne fait pas de ski
    #) :eqt:`I` Les logements tels qu'il en existe un autre où on fait du ski


    Vous pouvez exprimer la requête SQL pour chacune.

.. eqt:: negation6

    La requête "Les régions qui proposent tous les types de logement"
    
    A) :eqt:`I` Ne peut pas s'exprimer en SQL à cause de l'absence de quantification universelle
    #) :eqt:`I` Est interdite car trop coûteuse à évaluer
    #) :eqt:`C` Peut s'exprimer avec négation et quantification existentielle



********************************
S4: Conception d'une requête SQL
********************************

.. admonition::  Supports complémentaires:

    * `Diapositives: SQL: construction d'une requête <http://sql.bdpedia.fr/files/slconstrsql.pdf>`_
    * `Vidéo sur la construction d'une requête SQL  <https://mediaserver.cnam.fr/videos/construction-dune-requete-sql/>`_ 


Vous devriez à ce stade connaître et comprendre l'interprétation d'une requête SQL. Redonnons-la
encore une fois sous une forme un peu différente:

     - Le *résultat* d'une requête est une relation constituée de nuplets.
     - Chaque nuplet du résultat est construit à partir d'un ensemble de :math:`n` nuplets 
       :math:`t_1, t_2, \cdots, t_n`  *provenant de la base de données*.
     - Ces  :math:`n` nuplets  doivent satisfaire un ensemble de *conditions* (exprimé par une formule):.

La *construction* d'une requête consiste 

  - à indiquer  de quels nuplets :math:`t_1, t_2, \cdots, t_n`   nous avons besoin, 
    et d'où chacun provient (c'est la clause ``from``) 
  - à exprimer les conditions avec la clause ``where``
  - à indiquer comment on construit un nuplet du résultat avec la clause ``select``.
  
C'est tout. Le système pour sa part se charge de trouver toutes les combinaisons possibles des 
:math:`t_1, t_2, \cdots, t_n`, de tester les conditions, de construire le résultat. Le tout
en choisissant la méthode la plus efficace.


Nous sommes maintenant en mesure de tenter de décrire le processus mental qui nous permet
de construire une requête SQL pour répondre à un besoin donné. 
Le processus que nous décrivons s'appuie sur une vision de la structure de la base qui comprend,
au minimum, la liste des tables, leurs clés primaires et les clés étrangères. On établit cette vision
à partir du schéma, comme le montre par exemple la :numref:`construireSQLBase` pour trois tables de la base
des films. La bonne connaissance du schéma, et sa compréhension, sont des pré-requis pour exprimer
des requêtes SQL correctes.

.. _construireSQLBase:
.. figure:: ./figures-sql/construireSQL1.png
      :width: 80%
      :align: center
   
      La base des films "vue" comme un graphe dont les arêtes sont les liens
      clé étrangère - clé primaire.

Commençons par les requêtes  conjonctives, dans lesquelles la principale difficulté est
de construire les jointures.

.. important:: La méthode décrite ci-dessus repose sur la forme déclarative de SQL que
   nous avons étudiée dans ce chapitre. Le chapitre prochain présentera une approche alternative,
   basée sur des opérations, qui est à mon avis beaucoup moins adéquate pour apprendre à maîtriser SQL.
   
Conception d'une jointure
==========================

Le mécanisme de base consiste donc à se représenter les nuplets qui permettront de construire
un des nuplets du résultat. Dans les cas les plus simples, un seul suffit. Pour la
requête "Quelle est l'année de naissance de G. Depardieu" par exemple, on construit
un nuplet du résulat à partir d'un nuplet de la table Artiste, dont l'attribut "nom"
est "Depardieu", et dont l'attribut "âge" est l'information qui nous intéresse. On désigne
ce nuplet par un nom, par exemple *a*. L'image mentale 
à construire est celle de la :numref:`construireSQLDepardieu`.

.. _construireSQLDepardieu:
.. figure:: ./figures-sql/construireSQLDepardieu.png
      :width: 30%
      :align: center
   
      Interrogation avec un seul nuplet

C'est très élémentaire (pour l'instant) mais toute la requête SQL est déjà codée dans
cette représentation. 

  - Chaque nuplet désigné doit être défini dans le ``from``.
  - Les contraintes satisfaites par ce nuplet constituent le ``where`` (nom='Depardieu'). 
  - La clause ``select`` est toujours triviale (on choisit les attributs à conserver).  
  
Ce qui donne sur ce premier exemple:

.. code-block:: sql

     select annéeNaissance
     from Artiste as a
     where a.nom='Depardieu'

Entrons dans le vif du sujet avec la requête "Titre des films avec pour acteur Depardieu".
Cette fois l'image mentale 
à construire est celle de la :numref:`construireSQLDepardieuFilm`. Nous avons besoin, pour construire chaque
nuplet du résultat, de trois nuplets de la base: un film, un artiste, un rôle. Dès que nous avons
plusieurs nuplets, il faut indiquer de quelle manière ils sont liés: ici les liens sont (comme à peu près toujours)
définis par le critère d'égalité des clés primaires et clés étrangères.

.. _construireSQLDepardieuFilm:
.. figure:: ./figures-sql/construireSQLDepardieuFilm.png
      :width: 80%
      :align: center
    
      Les nuplets impliqué dans la recherche des films avec Depardieu

On a donné un nom à chaque nuplet, soit *f*, *r* et *a*.  La construction de la requête
s'ensuit quasiment automatiquement. 

.. code-block:: sql

     select f.titre
     from Artiste as a, Rôle as r, Film as f
     where a.nom='Depardieu'
     and a.idArtiste = r.idActeur
     and r.idFilm = f.idFilm

Notez que les contraintes sur les nuplets sont soit des égalités entre attributs, soit
l'égalité entre un attribut et une constante. Quand nous ajouterons la négation, un troisième
type de contrainte apparaîtra, celui de l'existence ou non d'un résultat pour une sous-requête. 

Remarquez également comment on se repose sur l'interpéteur SQL pour faire l'essentiel du travail:
trouver les nuplets satisfaisant les constraintes, énumérer toutes les combinaisons valides
à partir de la base, et construire le résultat.

Voici un exemple un peu plus compliqué qui ne change rien au raisonnement: on veut les titres
de film avec Depardieu et Deneuve. L'image à construire est celle de la :numref:`construireSQLDepardieuDeneuveFilm`.
Ici il faut concevoir qu'il nous faut deux nuplets de la table Artiste, l'un avec pour nom
Depardieu (*a1*), et l'autre avec pour nom Deneuve (*a2*).  Ces deux nuplets sont liés
à deux nuplets *distincts* de la table Rôle, nommons-les *r1* et *r2*. Ces deux derniers nuplets
sont liés au *même* film *f* .


.. _construireSQLDepardieuDeneuveFilm:
.. figure:: ./figures-sql/construireSQLDepardieuDeneuveFilm.png
      :width: 80%
      :align: center
   
      Les nuplets impliqué dans la recherche des films avec Depardieu et Deneuve

À partir de la  :numref:`construireSQLDepardieuDeneuveFilm`, la construction syntaxique
de la requête SQL est encore une fois directe: énumération des variables-nuplets dans le
``from``, contraintes dans le ``where``, clause ``select`` selon les besoins.

.. code-block:: sql

     select * 
     from Artiste as a1, Artiste as a2, Rôle as r1, Rôle as r2, Film as f
     where a1.nom='Depardieu'
     and a2.nom='Deneuve'
     and a1.idArtiste = r1.idActeur
     and a2.idArtiste = r2.idActeur
     and r1.idFilm = f.idFilm
     and r2.idFilm = f.idFilm

Voici deux exemples complémentaires. Le premier recherche les films réalisés par Q. Tarantino en 1994. 
L'image mentale est celle de la :numref:`construireSQLTarantinoFilm`.

.. _construireSQLTarantinoFilm:
.. figure:: ./figures-sql/construireSQLTarantinoFilm.png
      :width: 80%
      :align: center
   
      Recherche les films réalisés par Q. Tarantino en 1994

La requête correspondante est bien entendu celle-ci.

.. code-block:: sql

     select * 
     from Artiste as a, Film as f
     where a.nom='Tarantino'
     and  f.année = 1994
     and a.idArtiste = f.idRéalisateur

Le second exemple recherche les films réalisés par Q. Tarantino en 1994 dans lesquels il joue
lui-même dans tant qu'acteur. Je vous laisse étudier et interpréter  la :numref:`construireSQLTarantinoFilmArtiste`
et exprimer vous-même la requête SQL.

.. _construireSQLTarantinoFilmArtiste:
.. figure:: ./figures-sql/construireSQLTarantinoFilmArtiste.png
      :width: 80%
      :align: center
   
      Recherche les films réalisés par Q. Tarentino  en 1994 dans lequels il joue

Conception des requêtes imbriquées
==================================

Que se passe-t-il en cas de requête imbriquée, et surtout en cas de nécessité d'exprimer une négation? Les principes
précédents restent valables: on identifie les nuplets de la base qui permettent de produire un nuplet du résultat, 
on construit la requête comme précédemment, *et la requête imbriquée n'est qu'une contrainte supplémentaire
sur ces nuplets*. La seule particularité des requêtes imbriquées est que la contrainte porte sur 
un ensemble, et pas sur une valeur atomique.

Prenons un exemple: je veux les titres de film avec Catherine Deneuve mais sans Gérard Depardieu. On commence
par la solution partielle qui consiste à trouver les films avec Deneuve

.. code-block:: sql

     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and a.nom='Deneuve'
     
Maintenant on ajoute la contrainte suivante sur le film *f*: ``dans l'ensemble des acteurs du film *f*, on
ne doit pas trouver Gérard Depardieu``. L'ensemble des acteurs du film *f* qui se nomment
Depardieu est obtenu par une requête fonction de *f*, cette requête est 
ajoutée dans le ``where`` et  on obtient la requête complète

.. code-block:: sql

     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and a.nom='Deneuve'
     and not exists (select * from Rôle as r2, Artiste as a2 
                      where f.idFilm=r2.idFilm and r2.idActeur=a2.idActeur
                      and a2.nom='Depardieu')
                      
Il faut bien être conscient que cette condition supplémentaire porte sur le film *f*, et que *f*
doit impérativement intervenir dans la requête imbriquée. La requête suivante par exemple est fausse:

.. code-block:: sql

     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and a.nom='Deneuve'     
     and not exists (select * from Rôle as r2, Artiste as a2 
                      where r2.idActeur=a2.idActeur
                      and a2.nom='Depardieu')

La requête imbriquée est ici indépendante des nuplets de la variable principale, et on peut donc
évaluer son résultat dès le début: soit il existe un acteur nommé Depardieu (*quel que
soit le film*), le ``not exists`` est
toujours faux et le résultat est toujours vide; soit il n'en existe pas, le ``not exists`` est
toujours vrai et ne sert donc à rien. 

La disjonction
==============

Reste à discuter de la disjonction. Il existe une propriété assez utile des formules logiques: on peut toujours
les mettre sous une forme dite "normale disjonctive", autrement dit comme la disjonction de conjonctions
(voir les exercices). En pratique cela implique que toute requête comprenant un "ou" peut s'écrire
comme l'union de requêtes écrites sans "ou". Cherchons les films avec Deneuve ou Depardieu. 

.. code-block:: sql

     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and a.nom='Deneuve'
       union
     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and a.nom='Deneuve'
       
Ce n'est pas très concis. Il est à peu près toujours possible de trouver une formulation plus condensée
avec le "or". Ici ce serait:
       
.. code-block:: sql

     select f.titre
     from Film as f, Rôle as r, Artiste as a
     where f.idFilm=r.idFilm
     and r.idActeur = a.idArtiste
     and (a.nom='Deneuve' or nom='Depardieu')

Il n'existe pas de règle générale permettant de trouver la bonne formulation sans réfléchir. La bonne maîtrise
des principes de logique, d'équivalence de formule et d'interprétation sont les connaissances clés. 

Les principes exposés ici sont très importants. Même s'ils peuvent vous sembler parfois éloignés de vos objectifs pratiques,
tout ce qui précède devrait j'espère vous convaincre que maîtriser SQL, c'est d'abord être capable d'aborder
la formulation des requêtes de manière rigoureuse, pas de produire une syntaxe finalement relativement simple.
À vous de jouer.


Quiz
====


.. eqt:: constrSQL1

    .. _construireSQLQuiz1:
    .. figure:: ./figures-sql/construireSQLQuiz1.png
      :width: 80%
      :align: center
   
      La visualisation d'une requête. Laquelle ?

    La :numref:`construireSQLQuiz1` montre une requête visualisée sur la base des films. C'est le nuplet *a1* qui est cherché.
    Quelle est cette requête?
    
    A) :eqt:`I` Les acteurs qui ont tourné avec Tarantino, soit dans un film de 1992, soit dans un film de 1994 
    #) :eqt:`C` Les acteurs qui ont tourné deux fois avec Tarantino, une fois en 1992 et une autre en 1994
    #) :eqt:`I` Les paires d'acteurs qui ont tourné avec Tarantino, le premier en 1992, le second en 1994


.. eqt:: constrSQL2

    .. _construireSQLQuiz2:
    .. figure:: ./figures-sql/construireSQLQuiz2.png
      :width: 80%
      :align: center
   
      La visualisation d'une autre requête. Laquelle ?

    La :numref:`construireSQLQuiz2` montre une autre requête visualisée sur la base des films. C'est le nuplet *a1* qui est cherché.
    Quelle est cette requête?
    
    A) :eqt:`I` Les acteurs qui ont tourné soit avec Tarantino, soit avec Coppola
    #) :eqt:`I` Les acteurs qui ont tourné avec Tarantino et Coppola  dans le même film
    #) :eqt:`C` Les acteurs qui ont tourné avec Tarantino et Coppola


.. eqt:: constrSQL3

    .. _construireSQLQuiz3:
    .. figure:: ./figures-sql/construireSQLQuiz3.png
      :width: 80%
      :align: center
   
      Encore une requête visualisée

    Même question pour la :numref:`construireSQLQuiz3`
    
    A) :eqt:`I` Les réalisateurs qui ont tourné deux fois avec Travolta
    #) :eqt:`C` Les réalisateurs qui ont tourné un film dans lequel Travolta joue deux rôles différents
    #) :eqt:`I` Les acteurs qui ont joué deux fois avec Travolta


.. eqt:: constrSQL4

    .. _construireSQLQuiz4:
    .. figure:: ./figures-sql/construireSQLQuiz4.png
      :width: 80%
      :align: center
   
      Une dernière requête visualisée

    Même question pour la :numref:`construireSQLQuiz4`. On cherche *a1* et *a2*
    
    A) :eqt:`I` Les paires d'acteurs qui ont tourné dans le même film
    #) :eqt:`I` Les films dans lesquels un rôle a pu être par un artiste ou par un autre
    #) :eqt:`C` Les films dans lesquels deux acteurs jouent le même rôle


.. eqt:: constrSQL5

    Je définis deux variables dont la portée est une même table. Par exemple, deux 
    variables *f1* et *f2* sur la table ``Film``. La clause SQL correspondante est
    donc ``from  Film as f1, Film as f2``. Quelle affirmation est vraie
    
    A) :eqt:`I` *f1* et *f2* peuvent désigner le même nuplet
    #) :eqt:`C` *f1* et *f2* désignent deux nuplets distincts
    #) :eqt:`I` L'ordre sur les clés primaires de *f1* et *f2* est celui défini par l'ordre des
       variables dans la clause ``from``


*********
Exercices
*********


.. _Ex-calcul-1:
.. admonition:: Exercice `Ex-calcul-1`_: un peu de réécriture

   Il est possible de mettre toute formule en forme normale conjonctive (FNC) :math:`(F_1) \land (F_2) \land \cdot \land F_n`
   où les :math:`F_i` sont des disjonctions de propositions, 
   de la forme :math:`p \lor q \lor ... \lor u`. La négation n'est possible que devant une proposition.
   Utilisez les règles d'équivalence pour obtenir la FNC des formules suivantes
    
     - :math:`((a \land b) \lor (q \land r)) \lor z`

   Application: on vous demande de trouver les films qui satisfont les critères suivants: soit ils ont
   été tournés en France, soit ils ont été tournés en Espagne après 2010. 
   
     - (pays = 'France') ou (pays='Espagne' et année > 2010)
     
    Réécrivez cette expression en FNC. 

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

         On effectue successivement les réécritures suivantes
         
            - Forme initiale: :math:`((a \land b) \lor (q \land r)) \lor z`
            - On applique la distribution à la première partie de la formule: :math:`(a \lor (q \land r)) \land  (b \lor (q \land r))  \lor z`
            - On continue: la première partie de la formule est alors en FNC: :math:`((a \lor q) \land (a \lor r) \land  (b \lor q) \land (b \lor r))  \lor z`
            - On finalise en distribuant la disjonction avec :math:`z`: :math:`(a \lor q \lor z) \land (a \lor r \lor z) \land  (b \lor q \lor z) \land (b \lor r \lor z)`

        Et voilà. Pour prendre une image: on "pousse" les disjonctions à l'intérieur des parenthèses,
        et on en sort les conjonctions. Ou, si on a en tête l'arbre syntaxique
        défini par les parenthèses: on pousse les disjonctions vers
        le bas, les conjonctions vers le haut. 
        
        En ce qui concerne
        
             - (pays = 'France') ou (pays='Espagne' et année > 2010)

        La réécriture est donc
        
             - (pays = 'France' ou pays='Espagne') et (pays = 'France' ou année > 2010)

.. _Ex-calcul-2:
.. admonition:: Exercice `Ex-calcul-2`_: le ou exclusif

   Quelle formule propositionnelle exprime le *ou* exclusif entre :math:`p` et :math:`q` ?

    .. ifconfig:: calcul in ('public')
    
         La formule est :math:`(p \land \neg q) \lor (\neg p \land q)`. On exclut
         donc le cas où les deux propositions sont fausses: :math:`\neg p \land \neg q`.

.. _Ex-calcul-3:
.. admonition:: Exercice `Ex-calcul-3`_: un peu de raisonnement

   Un connecteur peu utilisé en base de données est l'implication, noté :math:`\to`. 
   L'implication n'existe pas directement en SQL, mais
   la table des valeurs de vérité de :math:`p \to q` est la même que 
   celle de :math:`\neg p \lor q`, ce qui permet de faire du raisonnement en SQL
   avec un peu de réécriture.
   
    - Donner la table de vérité :math:`p \to q`. 
      Notez la valeur de vérité de :math:`p \to q` quand :math:`p` et :math:`q`
      sont faux et quand :math:`p`  est faux et :math:`q` est vrai. Est-ce cela correspondait
      à votre intuition?
    - Montrer que :math:`p \to q` est équivalent à :math:`\neg q \to  \neg p`. 
    
      Aide: deux possibilités. La première est de construire la table de vérité (laborieux),
      la seconde est d'utiliser la premère équivalence, :math:`\neg p \lor q` (plus élégant).

    - Montrer que :math:`p \to q` *n'est pas* équivalent à :math:`\neg p \to  \neg q`. Aide:
      il faut trouver un contre-exemple.
      
    - Application: prenons une implication du langage courant, par exemple "Si je t'aime,
      prend garde à toi". Supposons qu'elle est vérifiée (donc, si Carmen aime Don José,
      alors Don José prend garde à lui). Quelles sont les formes équivalentes?
      
         - Si Carmen n'aime pas Don José, alors Don José ne prend pas garde
         - Si Don José ne prend pas garde, c'est que Carmen ne l'aime pas
         - Carmen aime  Don José, ou Don José prend garde à lui
         - Carmen n'aime pas Don José, ou Don José prend garde à lui
         
      Vous pouvez appliquer la question à toute implication de votre choix (si tu me cherches, tu vas me trouver;
      si tu vas à Rio, alors n'oublie pas  de monter là-haut; si j'avais un marteau
      je frapperais le jour, je frapperais la nuit; si c'est flou, y'a un loup; etc.)
      
    - Et pour finir sur le sujet, nous savons maintenant exprimer l'implication  en SQL.
      Prenons par exemple l'affirmation "Si le logement est un gîte, il a moins de 5 chambres".
      Quelle est la requête  qui cherche tous les faits vérifiant cette affirmation? Et donc
      comment vérifier si cette affirmation est toujours vraie?
      
    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

         C'est donc la table de vérité de :math:`\neg p  \lor q`.
         
         .. list-table:: Valeurs de vérité pour l'implication
            :widths: 15 15 15 
            :header-rows: 1
   
            * - :math:`p`
              - :math:`q`  
              - :math:`p  \to q` (:math:`\neg p  \lor q`)
            * - V
              - V
              - V
            * - V
              - F
              - F
            * - F
              - V
              - V
            * - F
              - F
              - V

         On note que l'implication est vraie quand les deux propositions sont fausses. Cela
         peut sembler contre-intuitif. Cela correspond à une définition simple: si p
         est vraie alors q *doit* être vraie. Dans tout les autres cas (notamment quand 
         p est faux) on considère qu'il n'y a pas de problème.

         La seconde possibilité consiste à effectuer un raisonnement dit "symbolique"
         au lieu d'énumérer tous les cas (ce qui n'est ni très élégant, ni très efficace).
         Ce type de raisonnement s'appuie sur des équivalences, par
         exemple le fait que :math:`p  \to q`  est équivalent à :math:`\neg p  \lor q`. 
         En appliquant ces équivalences, on transforme symboliquement (c'est-à-dire en restant
         au niveau de la syntaxe, sans se poser de question sur les cas), une formule en une autre.
         
         Ici, on a donc :math:`p  \to q \equiv \neg p  \lor q` (NB: :math:`\equiv` dénote l'équivalence
         logique). On a de même :math:`\neg q  \to \neg p \equiv \neg (\neg q) \lor \neg p \equiv \neg p \lor q`.
         CQFD.
         
         Autre démonstration: posons :math:`P = \neg p` et :math:`Q = \neg q`. La formule s'écrit alors :math:`P \lor \neg Q`,
         autrement dit :math:`\neg Q \lor P`, autrement dit :math:`Q \to P`. CQFD.
         
         Dire: 'si X s'appelle Barnabé alors X est un scarabée'  est équivalent à dire 
         'si X  n'est pas un scarabée, alors il ne s'appelle pas Barnabé'

         Confondre :math:`p \to q` et :math:`\neg p \to  \neg q` est une erreur assez courante.
         Il suffit de prendre la troisième ligne de la table de vérité ci-dessus, q
         est vrai et p est faux. Alors :math:`p \to q` est vrai mais :math:`\neg p \to  \neg q`
         est faux. Cette ligne nous dit en fait qu'il existe des cas où q est vrai
         sans que p le soit, et ça ne remet pas en cause l'implication.

         Dire: 'si X s'appelle Barnabé alors X est un scarabée'  ne signifie pas
         que tous les scarabées s'appellent Barnabé.

         Pour Carmen et Don José: la seconde et la quatrième formulations
         sont équivalentes à la formule initiale. On appelle :math:`P` la proposition "Carmen
         aime Don José" et :math:`Q` la proposition "Don José prend garde à lui". On sait
         donc que :math:`P \to Q`, par hypothèse. 
         
         Une fois la situation modélisée, il suffit d'appliquer les règles.
         
           - la première affirmation revient à dire :math:`\neg P \to \neg Q`, pas équivalent à l'hypothèse
           - la seconde se modélise par :math:`\neg Q \to \neg P`, équivalent à l'hypothèse
           - la troisième est  :math:`P \lor Q`, pas équivalent
           - la troisième est  :math:`\neg P \lor Q`,  équivalent

         La requête qui cherche tous les faits vérifiant cette implication. 
          
         .. code-block:: sql
         
            select *
            from Logement 
            where not(type='Gîte') or capacité < 5
            

         Attention, c'est différent de ne chercher que les gîtes de moins de cinq places: 
         si le logement n'est pas un gîte, l'implication est vraie indépendamment de la capacité.

         Trouver des faits vérifiant une propriété ne signifie pas qu'elle est *toujours* vraie. 
         Il faut pour cela qu'il n'existe pas de cas où ele est fausse. On peut donc
         produire la requête qui effectue la négation de la précédente.
          
         .. code-block:: sql
         
            select *
            from Logement 
            where type='Gîte' and capacité >= 5
        
         Le résultat est vide si l'affirmation est vraie. 


.. _Ex-calcul-3bis:
.. admonition:: Exercice `Ex-calcul-3bis`_: aidons les Dupondt à bien raisonner

   Supposons les  prédicats suivants :
   
   - :math:`\rm{Competence}  (p,c)` indique que la personne :math:`p` a la compétence :math:`c`
   - :math:`\rm{OffreEmploi} (o,c)` indique que l'organisation :math:`o` offre un emploi pour la compétence :math:`c`
   - :math:`\rm{FaitLaffaire} (p,o)` indique que la personne :math:`p` fait l'affaire
     pour un emploi dans l'organisation :math:`o`.

  On suppose que la règle :math:`r` suivante est toujours vraie :

  ..  math::
  
       \rm{OffreEmploi} (o,c) \land \rm{Competence} (p,c) \to \rm{FaitLaffaire} (p,o)

  Voici une petite mise en application des règles de raisonnement que nous avons abordées.
  Si vous n'arrivez pas à exprimer une démonstration mathématique, essayez au moins de
  formuler des réponses intuitives (mais claires).
 
   - Reformulez la règle :math:`r` sans implication
   - Dans la figure ci-dessous, les Dupondt peuvent-ils considérer de manière
     certaine que le capitaine Haddock les traite de clowns? Formulez
     la phrase du capitaine selon les prédicats logiques ci-dessus, et 
     vérifiez si on peut en déduire que les Dupondt ont la compétence 'clown'.

      .. _haddock-cirque1:
      .. figure:: ./figures-sql/haddock-cirque1.jpeg
            :width: 80%
            :align: center
   
            La première expression du capitaine Haddock, apparemment insultante pour les Dupondt

  À tort ou a raison, les Dupondt se sentent offensés. Le capitaine 
  Haddock propose une reformulation (figure ci-dessous).

    .. _haddock-cirque2:
    .. figure:: ./figures-sql/haddock-cirque2.jpeg
          :width: 60%
          :align: center
   
          Les excuses (?)  du capitaine Haddock

  Cette reformulation revient-elle vraiment
  à dire que les Dupondt *ne sont pas* des clowns?
  
  Quelle serait la bonne formulation d'une phrase qui indiquerait
  explicitement que le capitaine ne considère pas les Dupondt comme des clowns?
     
  .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

		Correction
		
		  - :math:`p \to q` est équivalent à :math:`\neg p \lor q`. Donc :math:`r` est équivalent à 
		  
		   ..  math::
 
			    r \equiv \neg \rm{OffreEmploi} (o,c) \lor \neg \rm{Competence} (p,c) \lor \rm{FaitLaffaire} (p,o)
			  
		  - Le capitaine énonce la conjonction de deux faits: 

		   .. math::
 
			    \rm{OffreEmploi} (\rm{'Hipparque'}, \rm{'clown'}) \land \rm{FaitLaffaire} (\rm{'Dupondt'}, \rm{'Hipparque'})		  
			  
		   Si :math:`\rm{FaitLaffaire} (\rm{'Dupondt'}, \rm{'Hipparque'})` est vrai,
		   alors :math:`\neg \rm{Competence} (p,c)` peut être vrai ou 
		   faux sans remettre en question la vérité de la règle :math:`r`.  Rien dans notre
		   modèle logique ne permet donc d'en déduire 
		   que les Dupondt sont des clowns ! Il faudrait pour cela que notre règle 
		   :math:`r` soit une *équivalence*, pas une *implication*. 
    
		  - Cette fois le capitaine énonce les faits  

		   ..  math::
 
			    \neg \rm{OffreEmploi} (\rm{'Hipparque'}, \rm{'clown'}) \land \neg \rm{FaitLaffaire} (\rm{'Dupondt'}, \rm{'Hipparque'})
			  
		   Ici encore, :math:`\neg \rm{Competence} (p,c)` peut être vrai ou 
		   faux sans remettre en question la vérité de la règle :math:`r`. Les Dupondt pourraient
		   être des clowns !

		  - Regardons notre règle formulée sans implication. Pour
		    que :math:`\neg \rm{Competence} (\rm{'Dupondt'},\rm{'clown'}))` soit vrai sans ambiguité
		    (donc les Dupondt ne sont pas des clowns),
		    il faut que :math:`\neg \rm{OffreEmploi}(\rm{'Hipparque'},\rm{'clown'})` soit faux et 
		    :math:`\rm{FaitLaffaire} (\rm{'Dupondt'},\rm{'Hipparque'})` soit faux également.

		   ..  math::
 
			    \rm{OffreEmploi}(\rm{'Hipparque'},\rm{'clown'}) \land \neg \rm{FaitLaffaire} (\rm{'Dupondt'},\rm{'Hipparque'})
			  
		   Le capitaine devrait dire : ``Le cirque Hipparque a besoin de deux clowns,
		   mais vous ne faites pas l'affaire''. CQFD. 

.. _Ex-calcul-4:
.. admonition:: Exercice `Ex-calcul-4`_: des équivalences

   Voici quelques critères de recherche exprimés sous deux formes en langage naturel. 
   Pour chacune: indiquez si elles sont équivalentes, et donnez la clause ``where`` correspondante,
   
   Aide: formaliser chaque sous la forme d'une formule propositionnelle, puis regarder si les deux
   formules sont équivalentes à l'aide des règles d'équivalence.
   
    
   .. eqt:: calcul4

    
         - Ce voyageur est français, et il est déjà allé  en Corse ou en Bretagne
         - Ce voyageur est français et il est allé en Corse, ou il est allé en Bretagne

       A) :eqt:`I` Oui
       #) :eqt:`C` Non

   .. eqt:: calcul5

    
         - Ce logement n'est pas en Corse et ce n'est pas un hôtel
         - Ce logement ne fait pas partie de ceux qui sont en Corse ou sont des hôtels 

       A) :eqt:`C` Oui
       #) :eqt:`I` Non
 
   .. eqt:: calcul3
    
        Un peu plus corsé (!): la seconde phrase comprend une implication !
       
         - Soit le logement est en Corse et c'est un hôtel, soit il est en Bretagne
         - Le logement est soit en Corse, soit en Bretagne, et s'il n'est pas en Bretagne, alors c'est un hôtel

        A) :eqt:`C` Oui
        #) :eqt:`I` Non

.. _Ex-calcul-4bis:
.. admonition:: Exercice `Ex-calcul-4bis`_: encore des équivalences

    On dispose de deux prédicats :math:`Auteur(o,x)` et :math:`Prop(o,x)` qui sont vrais si,
    respectivement, :math:`x` est auteur ou :math:`x` est propriétaire d'une œuvre d'art :math:`o`.

    - Quelle formule exprime la condition "Soit :math:`x`  est propriétaire, soit :math:`x` est auteur mais pas les deux"
      (pour une même œuvre :math:`o`)
    - Quelle est la négation de l'énoncé: "Soit :math:`x` est propriétaire, soit :math:`x` est auteur" (idem)
    - Comment exprimer l'énoncé suivant sans implication : "Si :math:`x` est auteur, alors :math:`x` n'est pas propriétaire"
      (idem; utiliser uniquement les connecteurs de SQL: and, or et not).

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

         Première question: c'est un ou exlusif, déjà vu plus haut. Donc la
         formule est :math:`(Auteur (o,x) \land \neg Prop (o,x)) \lor  (\neg Auteur (o,x) \land Prop (o,x)`
         
         Deuxième question: En français: :math:`x`  n'est ni auteur, ni propriétaire. Formellement:
         :math:`\neg Auteur (o,x) \land \neg Prop (o,x)`

         Troisième question: on  a une implication :math:`Auteur (o,x) \to \neg Prop (o,x)`,
         équivalente donc à  :math:`\neg Auteur (o,x) \lor \neg Prop (o,x)`. La traduction
         en SQL est directe avec les connecteurs not et or.
.. _Ex-calcul-5:
.. admonition:: Exercice `Ex-calcul-5`_: la quantification universelle

   Nous cherchons les logements dans lesquels tous les voyageurs sont allés. Quelle
   la formulation équivalente sans quantification universelle.
   
     - Les logements tel qu'il existe un voyageur qui y a effectué un séjour
     - Les logements tel qu'il n'existe pas de séjour qui n'a pas lieu dans ce logement
     - Les logements tel qu'il n'existe pas de voyageur  qui n'a pas séjourné 
       dans ce logement
     - Les logements tel qu'il n'existe pas de séjour  qui n'a pas concerné un voyageur
    
    Donnez la requête SQL correspondant à la bonne formulation

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction
      
         C'est la troisième formulation qui est la bonne. Quant à la requête SQL,
         elle prend les logements tels *qu'il n'existe pas* de voyageur tel *qu'il
         n'existe pas* de séjour de ce voyageur dans ce logement. Action:
         
         .. code-block:: sql

           select distinct l.nom
            from Logement as l
            where  not exists (select ''
                      from Voyageur as v
                      where not exists  (select ''
                                      from Séjour as s
                                      where l.code = s.codeLogement
                                      and   v.idVoyageur = s.idVoyageur)
                        
          

.. _Ex-calcul-6:
.. admonition:: Exercice `Ex-calcul-6`_: encore des dépendances fonctionnelles

    Comment vérifier une DF avec SQL? Prenons une table ``R(A,B)``
    et la dépendance fonctionnelle :math:`A \to B` 
    
      - Quelle est la formule qui exprime cette DF?
        (On peut utiliser l'implication maintenant que nous connaissons cet opérateur)
    
      - Donnez la requête SQL  qui vérifie que cette DF n'est pas violée 
        (aide: donner la requête 
        qui donne les cas où :math:`A \to B` n'est pas vérifée: le résultat devrait être vide!).
    
    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

           Avec l'implication: pour toute paire de nuplets :math:`t_1, t_2`, la formule
           suivante doit être vérifiée.
           
           - :math:`t_1.A=t_2.A \to t_1.B=t_2.B`
           - En réécrivant l'implication, on obtient: :math:`t_1.A \not= t_2.A \lor t_1.B = t_2.B` (en clair:
             cette formule est vraie si les valeurs de A sont distinctes ou si les valeurs de B sont égales).
           - La formule qui exprime que la DF est  violée  est la négation de la précédente, soit
             :math:`t_1.A = t_2.A \land t_1.B \not= t_2.B`. Ce qui donne en SQL:
             
             .. code-block:: sql
 
                select r1.A, r2.A 
                from r as r1, r as r2 
                where r1.A = r2.A and r1.B <> r2.B

             Un résultat vide indique que la DF est toujours respectée. 

.. _Ex-calcul-7:
.. admonition:: Exercice `Ex-calcul-7`_: interprétons SQL

    On reprend la requête constituant la liste des  
    logements avec leurs activités, légèrement modifiée.

    .. code-block:: sql
    
        select nom, codeActivité
        from   Logement as l, Activité as a, Séjour as s  
        where  l.code = a.codeLogement
       
    Qu'obtient-on dans les trois cas suivants :
    
          - la table ``Séjour`` contient 1 nuplet,
          - la table ``Séjour`` contient 100 000 nuplets,
          - la table ``Séjour`` est vide.

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

        Si elle est vide, on n'obtient rien. Sinon
        on obtient (1) la jointure (2) 100 000 doublons de la jointure. 
        
        Pour bien comprendre: l'évaluateur SQL var chercher tous les
        triplets de variables ``(l, a, s)`` qui satisfont la portée
        et la sélection. On va donc répeter chaque paire ``(l, a)`` qui satisfait 
        la condition de jointure autant de fois qu'il y a de nuplets dqns
        la table ``Séjour``. Et pour finir on va produire les nuplets-résultat
        qui vont contenir beaucoup de doublons, ou aucun selon le contenu de la
        table ``Séjour``.
        
        Cet exercice doit se comprendre comme une illustration de la nécessité
        d'interpréter une requête SQL dans un cadre rigoureux, qui s'appuie
        sur la définition que je résume une nouvelle fois: le ``from`` définit
        toutes les combinaisons de nuplets à considérer, le ``where`` restreint
        ces combinaisons de nuplets à celles satisfaisant des conditions exprimées
        par une formule, le ``select`` construit le résultat à partir des 
        combinaisons qui passent le test.

.. _Ex-calcul-8:
.. admonition:: Exercice `Ex-calcul-8`_: interprétons SQL, suite

    Soit trois tables  ``R``, ``S`` et ``T`` ayant chacune un seul
    attribut ``A``. On
    veut calculer l'intersection de ``R`` avec l'union de ``S``
    et ``T``, soit :math:`R \cap (S \cup T)` 
   
      - La requête suivante est-elle correcte ? Expliquez
        pourquoi.

        .. code-block:: sql
    
            select r:A 
            from R as r, S as S, T as t
            where r.A=s.A and r.A=t.A

      - Donnez la bonne requête.
      - Faut-il ajouter un ``distinct``? 

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

        - Non cette requête exprime l'intersection des trois tables
        - Il faut remplacer le ``and``par ``or``
        - Oui il faut un ``distinct``, sinon chaque nuplet dans :math:`R \cap S`
          est dupliqué autant de fois qu'il y a de nuplets dans ``T``, 
          et réciproquement.


.. _Ex-calcul-9:
.. admonition:: Exercice `Ex-calcul-9`_: construisons des requêtes SQL.

    Donnes les requêtes SQL correspondant aux :numref:`construireSQLTarantinoFilmArtiste`.
    :numref:`construireSQLQuiz1`, :numref:`construireSQLQuiz2` et :numref:`construireSQLQuiz3`.
    À chaque fois, la première clause  est ``select *``: vous devez compléter avec le
    ``from``   et le ``where``.

    .. ifconfig:: calcul in ('public')

      .. admonition:: Correction

          .. code-block:: sql 

              select *
              from Film as f, Rôle as r, Artiste as a
              where f.idFilm = r.idFilm 
              and r.idActeur = a.idArtiste
              and f.année = 1994
              and a.nom='Tarantino'
 
              select *
              from Film as f1, Film as f2, Rôle as r1, 
                  Rôle as r2, Artiste as a1, Artiste as a2
              where f1.idFilm = r1.idFilm 
              and   f2.idFilm = r2.idFilm 
              and   f1.idRéalisateur = a2.idArtiste
              and   f2.idRéalisateur = a2.idArtiste
              and r1.idActeur = a1.idArtiste
              and r2.idActeur = a1.idArtiste
              and f1.année = 1994
              and f2.année = 1992
              and a2.nom='Tarantino'

              select *
              from Film as f1, Film as f2, Rôle as r1, 
                  Rôle as r2, Artiste as a1, Artiste as a2, Artiste as a3
              where f1.idFilm = r1.idFilm 
              and   f2.idFilm = r2.idFilm 
              and r1.idActeur = a1.idArtiste
              and r2.idActeur = a1.idArtiste
              and f1.idRéalisateur = a2.idArtiste
              and f2.idRéalisateur = a3.idArtiste
              and a2.nom='Tarantino'
              and a3.nom='Coppola'
             
             
              select a1.*
              from Film as f1, Rôle as r1, 
                  Rôle as r2, Artiste as a1, Artiste as a2
              where f1.idFilm = r1.idFilm 
              and   f1.idFilm = r2.idFilm 
              and r1.idActeur = a2.idArtiste
              and r2.idActeur = a2.idArtiste
              and f1.idRéalisateur = a1.idArtiste
              and a2.nom='Travolta'

.. _atelier-calcul-A:

*******************************************
Atelier: requêtes SQL sur la base Voyageurs
*******************************************


Sur notre base des voyageurs en ligne (ou sur la vôtre, après installation d'un SGBD et chargement de nos
scripts), vous devez exprimer les requêtes suivantes:

   - Nom des villes
   - Nom des logements en Bretagne
   - Nom des logements dont la capacité est inférieure à 20
   - Description des activités de plongée
   - Nom des logements avec piscine
   - Nom des logements sans piscine
   - Nom des voyageurs qui sont allés en Corse
   - Les voyageurs qui sont allés ailleurs qu'en Corse
   - Nom des logements visités par un auvergnat
   - Nom des logements et des voyageurs situés dans la même région
   - Les paires de voyageurs (donner les noms) qui ont séjourné dans le même logement
   - Les voyageurs qui sont allés (au moins) deux fois dans le même logement
   - Les logements qui ont reçu (au moins) deux voyageurs différents 
   - ...

**Contrainte**:  n'utilisez pas l'imbrication, pour aucune requête ( et forcez-vous
à utiliser la forme déclarative, même si vous connaissez d'autres options que nous étudierons
dans le prochain chapitre).

    .. ifconfig:: calculTP1 in ('public')

      .. admonition:: Correction

        Pour chaque requête ou presque, d'autres syntaxes sont possibles. Le
        'as' par exemple est souvent optionnel (mais il ne gêne pas).
        
        .. code-block:: sql
        
            select ville from Voyageur
            
            select nom from Logement where lieu = 'Bretagne'

            select nom from Logement where capacité < 20
            
            select description from Activité where codeActivité = 'Plongée'

            select nom from Logement as l, Activité as a
            where l.code = a.codeLogement
            and a.codeActivité = 'Piscine'

            select v.prénom, v.nom 
            from Logement as l, Séjour as s, Voyageur as v 
            where l.code = s.codeLogement
            and s.idVoyageur =v.idVoyageur
            and lieu='Corse'

            select l.nom as nomLogement, v.nom
            from Logement as l, Séjour as s, Voyageur as v 
            where l.code = s.codeLogement
            and s.idVoyageur =v.idVoyageur
            and région='Auvergne'

            select l.nom as nomLogement, v.nom
            from Logement as l, Voyageur as v 
            where région=lieu

            select l.nom as nomLogement, v.nom, count(*) as nbVisites
            from Logement as l, Séjour as s, Voyageur as v 
            where l.code = s.codeLogement
            and s.idVoyageur =v.idVoyageur
            group by l.nom, v.nom
            having count(*) > 1

Pour les requêtes suivantes, en revanche, vous avez droit à l'imbrication (il serait difficile de faire
autrement).

   - Nom des voyageurs qui ne sont pas allés en Corse
   - Noms des voyageurs qui ne vont qu'en Corse s'ils vont quelque part.
   - Nom des voyageurs qui ne sont allés nulle part
   - Les logements où personne n'est allé
   - Les voyageurs qui n'ont jamais eu l'occasion de faire de la plongée

Vous pouvez finalement reprendre quelques-unes de requêtes précédentes et les exprimer avec
l'imbrication.

   .. ifconfig:: calculTP1 in ('public')

      .. admonition:: Correction

        .. code-block:: sql
        
             
            select v.prénom, v.nom 
            from Voyageur as v
            where not exists (select '' 
                from Logement as l, Séjour as s
                where l.code = s.codeLogement
                and s.idVoyageur =v.idVoyageur 
                and lieu='Corse')

            select v.prénom, v.nom 
            from Voyageur as v
            where not exists (select '' 
                from Logement as l, Séjour as s
                where l.code = s.codeLogement
                and s.idVoyageur =v.idVoyageur 
                and lieu != 'Corse')

            select v.prénom, v.nom 
            from Voyageur as v
            where not exists (select '' 
                  from Séjour as s
                  where  s.idVoyageur =v.idVoyageur)


***************************************
Atelier: requêtes sur la base des films
***************************************

Pour effectuer cet atelier, ouvrez avec un navigateur web le site 
http://deptfod.cnam.fr/bd/tp/. Aucun droit d’accès n’est nécessaire. 
Vous accédez à une interface
permettant d’entrer des requêtes SQL et de les exécuter sur 
quelques bases de données. 

Pour cet atelier nous vous proposons de travailler sur la 
base des films. Attention : seules les interrogations sont 
permises (pas de mise à jour).
À droite de la fenêtre dans laquelle vous pouvez entrer 
les requêtes SQL, vous trouvez le schéma de la base des films. 
Reportez-vous à ce schéma pour comprendre comment la base est structurée. 
Juste en dessous, une liste de requêtes vous est proposée : à 
vous de les exprimer en SQL et de vérifier que votre solution 
est correcte en l’entrant dans la fenêtre et en l’exécutant. 

Si vous ne trouvez pas la solution, ou si vous souhaitez vérifier 
que votre réponse était la bonne, chaque requête est associée 
à un bouton « Solution » qui vous permet de voir … la solution. 
Essayez de résister à la tentation de regarder cette 
solution trop rapidement.

À vous de jouer !


***************************************
Atelier: quand faut-il un ``distinct``?
***************************************

Difficile... A venir