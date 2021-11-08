---
title: 'SQL, ANCIENNE VERSION'
---

Le langage SQL est l\'outil standard pour effectuer des recherches ou
mises à jour dans une base de données relationnelle. Ce chapitre est
consacré à la partie *Langage de Manipulation de Données* (LMD)
complémentaire de la partie *Langage de Définition de Données* (LDD)
présentée précédemment.

SQL est un langage relativement facile dans la mesure où il ne permet
que des opérations assez limitées: manipuler plusieurs tables en entrée
(celles de la base) pour obtenir une table en sortie (le résultat). La
seule véritable difficulté réside dans l\'interprétation des requêtes
complexes qui font parfois appel à des logiques sophistiquées. Par
ailleurs la multiplicité des variantes syntaxiques offre de nombreuses
manières d\'exprimer la même interrogation ce qui peut parfois troubler.
Nous avons donc choisi d\'insister sur la signification des opérations
SQL et sur la démarche de conception d\'une requête.

Nous utilisons le schéma de la base *Immeuble* du chapitre précédent et
l\'instance de base donnée ci-dessous. Ce schéma et cette base sont
fournis respectivement dans les scripts
[SchemaImmeuble.sql](http://sql.bdpedia.fr/files/SchemaImmeuble.sql) et
[BaseImmeuble.sql](http://sql.bdpedia.fr/files/BaseImmeuble.sql) sur
notre site si vous souhaitez effectuer réellement les requêtes proposées
parallèlement à votre lecture.

**La table Immeuble**

Voici le contenu de la table *Immeuble*.

  ------------------------------------------------------------------------
  id      nom                         adresse
  ------- --------------------------- ------------------------------------
  1       Koudalou                    3 Rue Blanche

  2       Barabas                     2 Allée Nikos
  ------------------------------------------------------------------------

**La table Appart**

Voici le contenu de la table *Appart*.

  ------------------------------------------------------------------------------
  id       no       surface                étage                  id\_immeuble
  -------- -------- ---------------------- ---------------------- --------------
  100      1        150                    14                     1

  101      34       50                     15                     1

  102      51       200                    2                      1

  103      52       50                     5                      1

  201      1        250                    1                      2

  202      2        250                    2                      2
  ------------------------------------------------------------------------------

**La table Personne**

Voici le contenu de la table *Personne*.

  -----------------------------------------------------------------------------
  id      prénom             nom                profession         id\_appart
  ------- ------------------ ------------------ ------------------ ------------
  1                          Ross               Informaticien      202

  2       Alice              Black              Cadre              103

  3       Rachel             Verte              Stagiaire          100

  4       William            Dupont             Acteur             102

  5       Doug               Ramut              Rentier            201
  -----------------------------------------------------------------------------

**La table Possede**

Voici le contenu de la table *Possede*.

  -----------------------------------------
  id\_personne   id\_appart   quote\_part
  -------------- ------------ -------------

  -----------------------------------------

Principes de SQL
================

Nous commençons par un abrégé d\'interprétation des requêtes SQL qui va
nous guider pendant tout ce chapitre. Il existe quelques principes
généraux qui s\'appliquent quelle que soit la complexité de la requête
et auxquels il est très utile de pouvoir se ramener en présence d\'un
cas complexe.

Forme de base et interprétation
-------------------------------

La recherche s\'effectue avec la commande `select` dont la forme de base
est:

``` {.sql}
select liste_expressions
from   source
[where liste_conditions]
```

L\'ordre des trois clauses `select` `from` et `where` est trompeur pour
la signification d\'une requête. En fait l\'inteprétation s\'effectue
*toujours* de la manière suivante:

> -   la clause `from` définit l\'espace de recherche en fonction d\'un
>     ensemble de sources de données: cet espace a *toujours*
>     conceptuellement la forme d\'une table relationnelle que nous
>     appellerons *Tfrom*;
> -   la clause `where` exprime un ensemble de conditions sur les lignes
>     de la table *Tfrom*: seules les lignes pour lesquelles ces
>     conditions sont satisfaites sont conservées;
> -   enfin la clause `select` consiste en une liste d\'expressions
>     appliquées à chaque ligne de *Tfrom* ayant passé le filtre du
>     `where`.

Nous vous conseillons de revenir toujours à la définition ci-dessus
quand vous avez un problème avec vos requêtes SQL. Elle permet de rendre
compte uniformément de leur signification de la requête la plus simple à
la plus complexe. Le sens de lecture `from where select` facilite la
conception et l\'interprétation. Voyons tout de suite concrètement comme
elle s\'applique à une requête très simple.

``` {.sql}
select nom adresse from Immeuble where id=1
```

Cette requête renvoie le résultat suivant.

  -----------------------------------------------------------------------
  nom                                 adresse
  ----------------------------------- -----------------------------------
  Koudalou                            3 Rue Blanche

  -----------------------------------------------------------------------

L\'espace de recherche est ici constitué d\'une seule table de la base
Immeuble. Il s\'agit du cas le plus simple et le plus courant. On évalue
ensuite pour toutes les lignes de cette table les conditions exprimées
dans le `where`: seules les lignes (une seule en l\'occurrence) pour
lesquelles l\'attribut `id` vaut 1 satisfont cette condition. Finalement
on extrait de cette ligne les valeurs des attributs `nom` et `adresse`.

L\'espace de recherche: clause `from`
-------------------------------------

L\'espace de recherche est défini dans la clause `from` par une table ou
une combinaison de plusieurs tables. Par \"table\" il ne faut pas ici
comprendre forcément \"une des tables de la base\" courante même si
c\'est le cas le plus souvent rencontré. SQL est beaucoup général que
cela: une table dans un `from` peut également être *résultat* d\'une
autre requête. On parlera de table *basée* et de table *calculée* pour
distinguer ces deux cas. Ce peut également être une table stockée dans
une autre base ou une table calculée à partir de tables basées dans
plusieurs bases ou une combinaison de tout cela.

La première requête effectuée ci-dessus ramène les immeubles dont l\'id
vaut 1. Il n\'aura pas échappé au lecteur attentif que le résultat est
lui-même une table calculée. Pourquoi ne pourrait-on pas interroger
cette table calculée comme une autre? C\'est possible en SQL comme le
montre l\'exemple suivant:

``` {.sql}
select * 
from (select nom adresse from Immeuble where id=1) as Koudalou
```

On a donc placé une requête SQL dans le `from` où elle définit un espace
de recherche constitué de son propre résultat. Le mot-clé `as` permet de
donner un nom temporaire au résultat. En d\'autres termes `Koudalou` est
le nom de la table calculée sur laquelle s\'effectue la requête. Cette
table temporaire n\'existe que pendant l\'exécution.

On peut aller un peu plus loin et donner définivement un nom à cette
requête qui sélectionne l\'immeuble. En SQL cela s\'appelle une *vue*.
On crée une vue dans un schéma avec la commande `create view` (les vues
sont traitées en détail plus loin). Par exemple:

``` {.sql}
create view Koudalou as 
       select nom adresse from Immeuble where id=1
```

Une fois créée une vue peut être utilisée comme espace de recherche
exactement comme une table basée. Le fait que son contenu soit calculé
reste transparent pour l\'utilisateur.

``` {.sql}
select nom adresse from Koudalou
```

  -----------------------------------------------------------------------
  nom                                 adresse
  ----------------------------------- -----------------------------------
  Koudalou                            3 Rue Blanche

  -----------------------------------------------------------------------

Encore une fois, l\'interprétation du `from` est indépendante de
l\'origine des tables: tables basées, tables calculées, et vues.

::: {.note}
::: {.title}
Note
:::

On peut également interroger les tables ou vues d\'une *autre* base
pourvu que l\'utilisateur connecté ait les droits suffisants. Dans ce
cas on préfixe le nom de la table par le nom de la base.
:::

Venons-en maintenant au cas où le `from` est défini par plusieurs
tables. Dans un tel cas les contenus des tables sont *toujours*
combinées de manière à définir une table virtuelle (le *Tfrom* évoqué
précédemment) qui tient lieu d\'espace de recherche par la suite. La
combinaison la plus simple de deux tables *A* et *B*, obtenue en
séparant les noms des tables par une virgule, consiste à effectuer
toutes les associations possibles d\'une ligne de *A* et d\'une ligne de
*B*. Voici par exemple ce que cela donne pour les tables *Immeuble* et
*Appart*.

``` {.sql}
select * from Immeuble, Appart
```

L\'affichage ci-dessus nous montre quel est l\'espace de recherche
*Tfrom* considéré quand on place ces deux tables dans un `from`.

  ---------------------------------------------------------------------------------------
  id     nom              adresse          id     surface   etage   id\_immeuble   no
  ------ ---------------- ---------------- ------ --------- ------- -------------- ------
  1      Koudalou         3 Rue Blanche    100    150       14      1              1

  2      Barabas          2 Allée Nikos    100    150       14      1              1

  1      Koudalou         3 Rue Blanche    101    50        15      1              34

  2      Barabas          2 Allée Nikos    101    50        15      1              34

  1      Koudalou         3 Rue Blanche    102    200       2       1              51

  2      Barabas          2 Allée Nikos    102    200       2       1              51

  1      Koudalou         3 Rue Blanche    103    50        5       1              52

  2      Barabas          2 Allée Nikos    103    50        5       1              52

  1      Koudalou         3 Rue Blanche    201    250       1       2              1

  2      Barabas          2 Allée Nikos    201    250       1       2              1

  1      Koudalou         3 Rue Blanche    202    250       2       2              2

  2      Barabas          2 Allée Nikos    202    250       2       2              2
  ---------------------------------------------------------------------------------------

La virgule est en fait un synonyme de `cross join`, terme qui indique
que l\'on effectue un produit cartésien (*cross product*) des deux
tables vues comme des ensembles. Reportez-vous au chapitre
`chap-alg`{.interpreted-text role="ref"} pour des explications
détaillées. La requête donnant le même résultat est donc:

``` {.sql}
select * from Immeuble cross join Appart
```

D\'autre types de combinaisons plus restrictives et souvent plus utiles
sont les *jointures*. Regardons à nouveau le résultat précédent. Le fait
d\'associer chaque ligne de *Immeuble* à chaque ligne de *Appart* nous
donne des résultats peu utiles à priori. La seconde ligne associe par
exemple le Barabas à un appartement du Koudalou. On ne voit pas quelle
application peut trouver intérêt à un tel regroupement. En revanche,
associer un appartement à l\'immeuble où il se situe est très utile (ne
serait-ce que pour trouver son adresse).

Un peu de réflexion suffit pour se convaincre que les lignes
intéressantes dans le résultat du produit cartésien sont celles pour
lesquelles l\'attribut `id` provenant de la table *Immeuble* est égal à
l\'attribut `id_immeuble` provenant de *Appart*. Un tel produit
cartésien \"restreint\" est une *jointure* dans la terminologie du
modèle relationnel. Une combinaison de deux tables par jointure doit
indiquer quelles sont les conditions d\'association de deux lignes. En
SQL on l\'exprime avec la syntaxe suivante:

``` {.sql}
table1 join table2 on (conditions)
```

Donc on peut effectuer la jointure dans la clause `from`. On obtient un
espace de recherche constitué des paires de lignes pour lesquelles la
condition de jointure est vraie.

``` {.sql}
select * 
from Immeuble join Appart on (Immeuble.id=Appart.id_immeuble)
```

On obtient le résultat suivant.

  ---------------------------------------------------------------------------------------
  id     nom              adresse          id     surface   etage   id\_immeuble   no
  ------ ---------------- ---------------- ------ --------- ------- -------------- ------
  1      Koudalou         3 Rue Blanche    100    150       14      1              1

  1      Koudalou         3 Rue Blanche    101    50        15      1              34

  1      Koudalou         3 Rue Blanche    102    200       2       1              51

  1      Koudalou         3 Rue Blanche    103    50        5       1              52

  2      Barabas          2 Allée Nikos    201    250       1       2              1

  2      Barabas          2 Allée Nikos    202    250       2       2              2
  ---------------------------------------------------------------------------------------

Les jointures seront revues plus loin. Comment souvent en SQL il existe
plusieurs moyens de les exprimer, la plus utilisée consistant à
effectuer un produit cartésien (virgules dans le `from`) suivi de
conditions de jointures exprimées dans le `where`.

Ce qu\'il faut retenir: le `from` consiste à définir un espace de
recherche qui est constitué par combinaison d\'une ou plusieurs tables
basées ou calculées provenant du même schéma ou d\'un autre schéma. Quel
que soit le cas cet espace est lui-même une table (calculée) dont on va
chercher à extraire une ou plusieurs lignes (par le `where`) puis une ou
plusieurs colonnes (par le `select`).

Beaucoup de difficultés d\'interprétation proviennent d\'une mauvaise
compréhension de l\'espace dans lequel on cherche les données. La
première étape pour les résoudre consiste à se poser correctement la
question: que signifie le `from` de ma requête.

Les conditions: la clause `where`
---------------------------------

La clause `where` permet d\'exprimer des conditions portant sur les
lignes de la table définie par la clause `from`. Ces conditions prennent
la forme classique de tests combinés par les connecteurs booléens
classiques `and`, `or` et `not`. Les règles de priorité sont exprimées
par des parenthèses. Voici quelques exemples simples de requêtes avec
leur résultat.

``` {.sql}
select * from Appart where surface > 50
```

  ------------------------------------------------------------------------------
  id       surface                etage                  id\_immeuble   no
  -------- ---------------------- ---------------------- -------------- --------
  100      150                    14                     1              1

  102      200                    2                      1              51

  201      250                    1                      2              1

  202      250                    2                      2              2
  ------------------------------------------------------------------------------

``` {.sql}
select * from Appart 
where surface > 50 
and etage > 3
```

  ------------------------------------------------------------------------------
  id       surface                etage                  id\_immeuble   no
  -------- ---------------------- ---------------------- -------------- --------
  100      150                    14                     1              1

  ------------------------------------------------------------------------------

``` {.sql}
select * from Appart 
where (surface > 50 and etage > 3) 
or id_immeuble=2
```

  ------------------------------------------------------------------------------
  id       surface                etage                  id\_immeuble   no
  -------- ---------------------- ---------------------- -------------- --------
  100      150                    14                     1              1

  201      250                    1                      2              1

  202      250                    2                      2              2
  ------------------------------------------------------------------------------

Il est également possible d\'exprimer des conditions sur des tables
calculées par d\'autre requêtes SQL incluses dans la clause `where` et
habituellement désignées par le terme de \"requêtes imbriquées\". On
pourra par exemple demander la liste des personnes dont l\'appartement
fait partie de la table calculée des appartements situés au-dessus du
troisième étage.

``` {.sql}
select * from Personne
where id_appart in (select id from Appart where etage < 3)
```

  -----------------------------------------------------------------------------------
  id       prenom                 nom                    profession      id\_appart
  -------- ---------------------- ---------------------- --------------- ------------
  1        null                   Ross                   Informaticien   202

  4        William                Dupont                 Acteur          102

  5        Doug                   Ramut                  Rentier         201
  -----------------------------------------------------------------------------------

Avec les requêtes imbriquées on entre dans le monde incertain des
requêtes qui semblent claires mais finissent par ne plus l\'être du
tout. La difficulté vient souvent du fait qu\'il faut raisonner
simultanément sur plusieurs requêtes qui, de plus, sont souvent
interdépendantes (les données sélectionnées dans l\'une servent de
paramètre à l\'autre). Il est très souvent possible d\'éviter les
requêtes imbriquées comme nous l\'expliquons dans ce chapitre.

Les expressions: la clause `select`
-----------------------------------

Finalement, une fois obtenues les lignes du `from` qui satisfont le
`where` on crée à partir de ces lignes le résultat final avec les
expressions du `select`. Le terme \"expression\" désigne ici, comme dans
tout langage, une construction syntaxique qui prend une ou plusieurs
valeurs en entrée et produit une valeur en sortie. Dans sa forme la plus
simple, une expression est simplement un nom d\'attribut ou une
constante comme dans l\'exemple suivant.

``` {.sql}
select surface etage 18 as 'Euros/m2' 
from Appart
```

  -----------------------------------------------------------------------
  surface     etage                         Euros/m2
  ----------- ----------------------------- -----------------------------
  150         14                            18

  50          15                            18

  200         2                             18

  50          5                             18

  250         1                             18

  250         2                             18
  -----------------------------------------------------------------------

Les attributs `surface` et `etage` proviennent de *Appart* alors que 18
est une constante qui sera répétée autant de fois qu\'il y a de lignes
dans le résultat. De plus, on peut donner un nom à cette colonne avec la
commande `as`. Voici un second exemple qui montre une expression plus
complexe. L\'utilisateur (certainement un agent immobilier avisé et
connaissant bien SQL) calcule le loyer d\'un appartement en fonction
d\'une savante formule qui fait intervenir la surface et l\'étage.

``` {.sql}
select no, surface, etage, 
        (surface * 18) * (1 (0.03 * etage)) as loyer 
from Appart
```

  -----------------------------------------------------------------------
  no                surface           etage             loyer
  ----------------- ----------------- ----------------- -----------------
  1                 150               14                3834.00

  34                50                15                1305.00

  51                200               2                 3816.00

  52                50                5                 1035.00

  1                 250               1                 4635.00

  2                 250               2                 4770.00
  -----------------------------------------------------------------------

SQL fournit de très nombreux opérateurs et fonctions de toute sorte qui
sont clairement énumérées dans la documentation de chaque système. Elles
sont particulièrement utiles pour des types de données un peu délicat à
manipuler comme les dates.

Une extension rarement utilisée consiste à effectuer des tests sur la
valeur des attributs à l\'intérieur de la clause `select` avec
l\'expression `case` dont la syntaxe est:

``` {.sql}
case 
  when test then expression
  [when ...]
  else  expression
end
```

Ces tests peuvent être utilisés par exemple pour effectuer un *décodage*
des valeurs quand celles-ci sont difficiles à interpréter ou quand on
souhaite leur donner une signification dérivée. La requête ci-dessous
classe les appartements en trois catégories selon la surface.

``` {.sql}
select no etage surface
      case when surface <= 50 then 'Petit'
           when surface > 50 and surface <= 100 then 'Moyen'
           else 'Grand'
      end as categorie
from Appart
```

  -----------------------------------------------------------------------
  no                etage             surface           catégorie
  ----------------- ----------------- ----------------- -----------------
  1                 14                150               Grand

  34                15                50                Petit

  51                2                 200               Grand

  52                5                 50                Petit

  65                12                70                Moyen

  65                12                70                Moyen

  1                 1                 250               Grand

  2                 2                 250               Grand
  -----------------------------------------------------------------------

Voici donc tout ce qu\'il faut savoir sur l\'interprétation des requêtes
SQL exprimées \"à plat\", sans requête imbriquée. Nous reprenons
maintenant la présentation du langage en apportant des précisions sur
chaque partie.

Recherche avec SQL
==================

La recherche la plus simple consiste à récupérer le contenu complet
d\'une table. On n\'utilise pas la clause `where` et le \* désigne tous
les attributs.

``` {.sql}
select * from Immeuble
```

  -----------------------------------------------------------------------
  id                      nom                     adresse
  ----------------------- ----------------------- -----------------------
  1                       Koudalou                3 Rue Blanche

  2                       Barabas                 2 Allée Nikos
  -----------------------------------------------------------------------

Construction d\'expressions
---------------------------

Si on indique explicitement les attributs au lieu d\'utiliser \*, leur
nombre détermine le nombre de colonnes de la table calculée. Le nom de
chaque attribut dans cette table est par défaut l\'expression du
`select` mais on peut indiquer explicitement ce nom avec `as`. Voici un
exemple qui illustre également une fonction assez utile, la
concaténation de chaînes.

``` {.sql}
select prenom || nom as 'Prenom et nom' 
from Personne
```

  -----------------------------------------------------------------------
  Prenom et nom
  -----------------------------------------------------------------------
  null

  Alice Black

  Rachel Verte

  William Dupont

  Doug Ramut
  -----------------------------------------------------------------------

Le résultat montre que l\'une des valeurs est à `null`. Le `null` en SQL
correspond à *l\'absence* de valeur. Logiquement toute opération
appliquée à un `null` renvoie un `null` en sortie puisqu\'on ne peut
calculer aucun résultat à partir d\'une valeur inconnue. Ici c\'est le
prénom de l\'une des personnes qui manque. La concaténation du prénom
avec le nom est une opération qui \"propage\" cette valeur à `null`.

La clause `where`
-----------------

Les conditions de la clause `where` suivent en général la syntaxe
`expr1 [not]` $\Theta$ `expr2`, où `expr1` et `expr2` sont deux
expressions construites à partir de noms d\'attributs de constantes et
des fonctions et $\Theta$ est l\'un des opérateurs de comparaison
classique *\<* *\>* *\<=* *\>=* *!=*.

Les conditions se combinent avec les connecteurs booléens `and` `or` et
`not`. SQL propose également un prédicat `in` qui teste l\'appartenance
d\'une valeur à un ensemble. Il s\'agit (du moins tant qu\'on n\'utilise
pas les requêtes imbriquées) d\'une facilité d\'écriture pour remplacer
le `or`. La requête

``` {.sql}
select * 
from Personne 
where profession='Acteur' 
or profession='Rentier'
```

s\'écrit de manière équivalente avec un `in` comme suit:

``` {.sql}
select * 
from Personne
where profession in ('Acteur', 'Rentier')
```

  -----------------------------------------------------------------------------
  id      prenom             nom                profession         id\_appart
  ------- ------------------ ------------------ ------------------ ------------
  4       William            Dupont             Acteur             102

  5       Doug               Ramut              Rentier            201
  -----------------------------------------------------------------------------

Pour les chaînes de caractères, SQL propose l\'opérateur de comparaison
`like`, avec deux caractères de substitution:

> -   le \"%\" remplace n\'importe quelle sous-chaîne;
> -   le \"\_\" remplace n\'importe quel caractère.

L\'expression `_ou%ou` est donc interprétée par le `like` comme toute
chaîne commençant par un caractère suivi de \"ou\" suivi de n\'importe
quelle chaîne suivie une nouvelle fois de \"ou\".

``` {.sql}
select * 
from Immeuble 
where nom like '_ou%ou'
```

  -----------------------------------------------------------------------
  id          nom                           adresse
  ----------- ----------------------------- -----------------------------
  1           Koudalou                      3 Rue Blanche

  -----------------------------------------------------------------------

Valeurs nulles
--------------

Il est impossible de déterminer quoi que ce soit à partir d\'une valeur
à `null`. Nous avons vu que toute opération appliquée à un `null`
renvoie `null`. Dans le cas des comparaisons, la présence d\'un `null`
renvoie un résultat qui n\'est ni `true` ni `false` mais `unknown`, une
valeur booléenne intermédiaire. Reprenons à nouveau la table *Personne*
avec un des prénoms à `null`. La requête suivante devrait ramener toutes
les lignes.

``` {.sql}
select * 
from Personne
where prenom like '%'
```

Mais la présence d\'un `null` empêche l\'inclusion de la ligne
correspondante dans le résultat.

  -----------------------------------------------------------------------------
  id      prenom             nom                profession         id\_appart
  ------- ------------------ ------------------ ------------------ ------------
  2       Alice              Black              Cadre              103

  3       Rachel             Verte              Stagiaire          100

  4       William            Dupont             Acteur             102

  5       Doug               Ramut              Rentier            201
  -----------------------------------------------------------------------------

Cependant la condition `like` n\'a pas été évaluée à `false` comme le
montre la requête suivante.

``` {.sql}
select  *
from Personne
where prenom not like  '%'
```

On obtient un résultat vide, ce qui montre bien que le `like` appliqué à
un `null` ne renvoie pas `false` (car sinon on aurait
`not false = true`). C\'est d\'ailleurs tout à fait normal puisqu\'il
n\'y a aucune raison de dire qu\'une absence de valeur ressemble à
n\'importe quelle chaîne.

Les tables de vérité de la logique trivaluée de SQL sont définies de la
manière suivante. Tout d\'abord on affecte une valeur aux trois
constantes logiques:

> -   `true` vaut 1
> -   `false` vaut 0
> -   `unknown` vaut 0.5

Les connecteurs booléens s\'interprètent alors ainsi:

> -   `val1 and val2` = max(val1 val2)
> -   `val1 or val2` = min(val1 val2)
> -   `not val1` = 1 - val1.

On peut vérifier notamment que `not unknown` vaut toujours `unknown`.
Ces définitions sont claires et cohérentes. Cela étant il faut mieux
prévenir de mauvaises surprises avec les valeurs à `null`, soit en les
interdisant à la création de la table avec les options `not null` ou
`default`, soit en utilisant le test `is null` (ou son complément
`is not null`). La requête ci-dessous ramène toutes les lignes de la
table, même en présence de `null`.

``` {.sql}
select *
from Personne
where prenom like '%' 
or prenom is null
```

  -----------------------------------------------------------------------------
  id      prenom             nom                profession         id\_appart
  ------- ------------------ ------------------ ------------------ ------------
  1       null               Ross               Informaticien      202

  2       Alice              Black              Cadre              103

  3       Rachel             Verte              Stagiaire          100

  4       William            Dupont             Acteur             102

  5       Doug               Ramut              Rentier            201
  -----------------------------------------------------------------------------

Attention le test `valeur = null` n\'a pas de sens. On ne peut pas être
égal à une absence de valeur.

Tri et élimination de doublons
------------------------------

SQL renvoie les lignes du résultat sans se soucier de la présence de
doublons. Si on cherche par exemple les surfaces des appartements avec

``` {.sql}
select surface 
from Appart
```

on obtient le résultat suivant.

  -----------------------------------------------------------------------
  surface
  -----------------------------------------------------------------------
  150

  50

  200

  50

  250

  250
  -----------------------------------------------------------------------

On a autant de fois une valeur qu\'il y a de lignes dans le résultat
intermédiaire après exécution des clauses `from` et `where`. En général,
on ne souhaite pas conserver ces lignes identiques dont la répétition
n\'apporte aucune information. Le mot-clé `distinct` placé juste après
le `select` permet d\'éliminer ces doublons.

``` {.sql}
select distinct surface   
from Appart
```

  -----------------------------------------------------------------------
  surface
  -----------------------------------------------------------------------
  150

  50

  200

  250
  -----------------------------------------------------------------------

Le `distinct` est à éviter quand c\'est possible car l\'élimination des
doublons peut entraîner des calculs coûteux. Il faut commencer par
calculer entièrement le résultat, puis le trier ou construire une table
de hachage, et enfin utiliser la structure temporaire obtenue pour
trouver les doublons et les éliminer. Si le résultat est de petite
taille cela ne pose pas de problème. Sinon, on risque de constater une
grande différence de temps de réponse entre une requête sans `distinct`
et la même avec `distinct`.

On peut demander explicitement le tri du résultat sur une ou plusieurs
expressions avec la clause `order by` qui vient toujours à la fin d\'une
requête `select`. La requête suivante trie les appartements par surface
puis, pour ceux de surface identique, par l\'étage.

``` {.sql}
select *  
from Appart 
order by surface etage
```

  ------------------------------------------------------------------------
  id      surface            etage              id\_immeuble       no
  ------- ------------------ ------------------ ------------------ -------
  103     50                 5                  1                  52

  101     50                 15                 1                  34

  100     150                14                 1                  1

  102     200                2                  1                  51

  201     250                1                  2                  1

  202     250                2                  2                  2
  ------------------------------------------------------------------------

Par défaut, le tri est en ordre ascendant. On peut inverser l\'ordre de
tri d\'un attribut avec le mot-clé `desc` .

``` {.sql}
select *  
from Appart 
order by surface desc,  etage desc
```

  ------------------------------------------------------------------------
  id      surface            etage              id\_immeuble       no
  ------- ------------------ ------------------ ------------------ -------
  202     250                2                  2                  2

  201     250                1                  2                  1

  102     200                2                  1                  51

  100     150                14                 1                  1

  101     50                 15                 1                  34

  103     50                 5                  1                  52
  ------------------------------------------------------------------------

Bien entendu, on peut trier sur des expressions au lieu de trier sur de
simples noms d\'attribut.

Jointures
=========

La jointure est une opération indisoensable dès que l\'on souhaite
combiner des données réparties dans plusieurs tables. À la base de la
jointure, on trouve le produit cartésien qui consiste à trouver toutes
les associations possibles d\'une ligne de la première table avec une
ligne de la seconde. La jointure consiste à restreindre le résultat du
produit cartésien en ne conservant que les associations qui sont
intéressantes pour la requête.

Il existe beaucoup de manières différentes d\'exprimer les jointures en
SQL. Pour les débutants, il est recommandé de se limiter à la forme de
base donnée ci-dessous qui est plus facile à interpréter et se
généralise à un nombre de tables quelconques.

Syntaxe classique
-----------------

La méthode la plus courante consiste à effectuer un produit cartésien
dans le `from` puis à éliminer les lignes inutiles avec le `where`

::: {.important}
::: {.title}
Important
:::

Attention, nous parlons ici de la manière dont on conçoit la requête pas
de l\'évaluation par le système qui essaiera en général d\'éviter le
calcul complet du produit cartésien.
:::

Prenons l\'exemple d\'une requête cherchant la surface et l\'étage de
l\'appartement de M. William Dupont. On doit associer deux tables. La
première est une table calculée contenant les informations sur William
Dupont. On l\'obtient par la requête suivante.

``` {.sql}
select *
from Personne
where prenom='William' 
and nom='Dupont'
```

  -----------------------------------------------------------------------------
  id      prenom             nom                profession         id\_appart
  ------- ------------------ ------------------ ------------------ ------------
  4       William            Dupont             Acteur             102

  -----------------------------------------------------------------------------

La seconde table est l\'ensemble des appartements. L\'association des
deux tables par un produit cartésien consiste simplement à les placer
toutes les deux dans le `from`.

``` {.sql}
select  p.id, nom, prenom, id_appart, a.id, surface, etage
from Personne as p, Appart as a
where prenom='William' and nom='Dupont'
```

Ce qui donne le résultat suivant:

  ----------------------------------------------------------------------------------
  id      nom               prenom            id\_appart   id      surface   etage
  ------- ----------------- ----------------- ------------ ------- --------- -------
  4       Dupont            William           102          100     150       14

  4       Dupont            William           102          101     50        15

  4       Dupont            William           102          102     200       2

  4       Dupont            William           102          103     50        5

  4       Dupont            William           102          201     250       1

  4       Dupont            William           102          202     250       2
  ----------------------------------------------------------------------------------

Une première difficulté à résoudre quand on utilise plusieurs tables est
la possibilité d\'avoir des attributs de même nom dans l\'union des
schémas, ce qui soulève des ambiguités dans les clauses `where` et
`select`. On résout cette ambiguité en préfixant les attributs par le
nom des tables dont ils proviennent. Ici, on a même simplifié
l\'écriture en donnant des *alias* aux nom des tables avec le mot-clé
`as`. La table *Personne* et la table *Appart* sont donc respectivement
référencées par `p` et `a`.

Notez que la levée de l\'ambiguité en préfixant par le nom ou l\'alias
de la table n\'est nécessaire que pour les attributs qui apparaissent en
double soit ici `id` qui peut désigner l\'identifiant de la personne ou
celui de l\'appartement.

On n\'a placé aucun critère de filtrage pour l\'association des lignes
provenant des deux tables. William Dupont est donc associé à toutes les
lignes de la table *Appart*. La jointure consiste à ajouter une
condition complémentaire dans le `where` exprimant le fait que
l\'appartement auquel on s\'intéresse (désigné par sa clé `a.id`) est
celui où habite William Dupont (désigné par la clé étrangère
`id_appart`). Le résultat de la requête précédente montre bien que la
seule ligne qui nous intéresse est celle où ces deux attributs ont la
même valeur. D\'où la requête donnant le bon résultat:

``` {.sql}
select  p.id, p.nom, p.prenom, p.id_appart, a.id, a.surface, a.etage
from Personne as p Appart as a   
where prenom='William' 
and nom='Dupont'
and   a.id = p.id_appart
```

  ----------------------------------------------------------------------------------
  id      nom               prenom            id\_appart   id      surface   etage
  ------- ----------------- ----------------- ------------ ------- --------- -------
  4       Dupont            William           102          102     200       2

  ----------------------------------------------------------------------------------

Comme dans la très grande majorité des cas la jointure consiste à
exprimer une égalité entre la clé primaire de l\'une des tables et la
clé étrangère correspondante de l\'autre. Un peu de réflexion permet de
réaliser que l\'on recrée ainsi le lien défini au niveau du modèle
entitéassociation. Mais SQL est plus puissant que cette reconstitution
puisqu\'on peut exprimer des conditions de jointure sur n\'importe quel
attribut et pas seulement sur ceux qui sont des clés.

Imaginons que l\'on veuille trouver les appartements d\'un même immeuble
qui ont la même surface. On veut associer une ligne de *Appart* à une
autre ligne de *Appart* avec les conditions suivantes:

> -   elles sont dans le même immeuble (attribut `id_immeuble`);
> -   elles ont la même valeur pour l\'attribut `surface`;
> -   elles correspondent à des appartements distincts (attributs `id`).

La requête exprimant ces conditions est donc:

``` {.sql}
select a1.id, a1.surface, a1.etage, a2.id, a2.surface, a2.etage
from Appart a1 Appart a2
where a1.id != a2.id
and a1.surface = a2.surface
and a1.id_immeuble = a2.id_immeuble
```

Ce qui donne le résultat suivant:

  -----------------------------------------------------------------------
  id          surface     etage       id          surface     etage
  ----------- ----------- ----------- ----------- ----------- -----------
  101         50          15          103         50          5

  103         50          5           101         50          15

  201         250         1           202         250         2

  202         250         2           201         250         1
  -----------------------------------------------------------------------

On peut noter que dans le résultat la même paire apparaît deux fois avec
des ordres inversés. On peut éliminer cette redondance en remplaçant
`a1.id != a2.id` par `a1.id < a2.id`.

Les alias `a1` et `a2` jouent le rôle de \"curseurs\" qui référencent, à
un moment donné, deux lignes de la table *Appart*. Ces deux lignes sont
associées et incluses dans le résultat si la condition du `where` est
satisfaite.

Voici quelques exemples complémentaires de jointures impliquant parfois
plus de deux tables exprimées par produit cartésien, puis restriction
avec `where`.

> -   Qui habite un appartement de plus de 200 m2?
>
>     ``` {.sql}
>     select prenom, nom, profession
>     from Personne, Appart
>     where id_appart = Appart.id
>     and  surface >= 200
>     ```
>
> > Attention à lever l\'ambiguité sur les noms d\'attributs quand ils
> > peuvent provenir de deux tables (c\'est le cas ici pour `id`).
>
> -   Qui habite le Barabas?
>
>     ``` {.sql}
>     select prenom, p.nom, no, surface, etage
>     from   Personne as p, Appart as a, Immeuble as i
>     where  p.id_appart=a.id
>     and    a.id_immeuble=i.id
>     and    i.nom='Barabas'
>     ```
>
> -   Qui habite un appartement qu\'il possède et avec quelle
>     quote-part?
>
> > ``` {.sql}
> > select prenom, nom, quote_part
> > from   Personne as p, Possede as p2, Appart as a
> > where  p.id=p2.id_personne /* p est propriétaire */
> > and    p2.id_appart=a.id   /* de l'appartement a */
> > and    p.id_appart=a.id   /* et il y habite     */
> > ```
>
> \- De quel(s) appartement(s) Alice Black
>
> :   est-elle propriétaire et dans quel immeuble?
>
>     Voici la requête sur les quatre tables avec des commentaires
>     inclus montrant les jointures.
>
>     ``` {.sql}
>     select i.nom, no, etage, surface
>     from  Personne as p, Appart as a, Immeuble as i, Possede as p2
>     where  p.id=p2.id_personne /* Jointure PersonnePossede */
>     and    p2.id_appart = a.id /* Jointure PossedeAppart */
>     and    a.id_immeuble= i.id /* Jointure AppartImmeuble */
>     and    p.nom='Black' and p.prenom='Alice'
>     ```
>
>     Attention à lever l\'ambiguité sur les noms d\'attributs quand ils
>     peuvent provenir de deux tables (c\'est le cas ici pour `id`).

La jointure classique \"à plat\" où toutes les tables sont placées dans
le `from` et associées par produit cartésien est une manière tout à fait
recommandable de procéder surtout pour les débutants SQL. Elle permet de
se ramener toujours à la même méthode d\'interprétation et consolide la
compréhension des principes d\'interrogation d\'une base relationnelle.

Toutes ces jointures peuvent s\'exprimer avec d\'autres syntaxes: tables
calculées dans le `from` opérateur de jointure dans le `from` ou (pas
toujours) requêtes imbriquées. À l\'exception notable des jointures
externes et des requêtes imbriquées avec négation, elles n\'apportent
aucune expressivité supplémentaire. Toutes ces variantes constituent des
moyens plus ou moins commodes d\'exprimer différemment la jointure.

Tables calculées dans le `from`
-------------------------------

La possibilité de placer des requêtes dans le `from` est prise en compte
depuis peu de temps par les SGBD relationnels. Cette option n\'apporte
rien en terme d\'expressivité mais elle peut (question de goût) parfois
être considérée comme plus claire ou plus proche du raisonnement
intuitif. Elle ne sert que dans les cas où il existe un critère de
sélection sur une table. En revanche les conditions de jointure restent
dans le `where`.

Nous reprenons quelques exemples de requêtes que nous avons déjà
résolues avec des jointures \"à plat\".

> -   Quel est l\'appartement où habite M. William Dupont?
>
>     ``` {.sql}
>     select no, surface, etage
>     from  Appart, (select id_appart from Personne
>                    where prenom='William' 
>                    and nom='Dupont') as Dupont
>     where id=id_appart
>     ```
>
>       -----------------------------------------------------------------------
>       no                      surface                 etage
>       ----------------------- ----------------------- -----------------------
>       51                      200                     2
>
>       -----------------------------------------------------------------------
>
>     Un (léger) avantage est de supprimer dans la table calculée les
>     attributs qui soulèvent des ambiguités (par exemple l\'id de la
>     personne qui ne sert à rien par la suite). Il faut *toujours*
>     donner un alias avec le mot-clé `as` à la table calculée.
>
> -   Qui habite un appartement de plus de 200 m2?
>
>     ``` {.sql}
>     select prenom, nom, profession
>     from Personne as p,  (select id from Appart where surface>=200) as a
>     where p.id_appart=a.id
>     ```
>
> -   Qui habite le Barabas?
>
>     Dernier exemple montrant la possibilité d\'effectuer une jointure
>     pour obtenir la table calculée.
>
>     ``` {.sql}
>     select prenom, nom, no, surface, etage
>     from    Personne p, (select Appart.id, no, surface, etage
>                         from Appart, Immeuble
>                         where id_immeuble=Immeuble.id
>                         and nom='Barabas') as a
>     where  p.id_appart=a.id
>     ```

Opérateurs de jointure
----------------------

La virgule séparant deux tables dans un `from` exprime un produit
cartésien: toutes les combinaisons de lignes sont considérées puis
soumises aux conditions du `where`. Comme nous l\'avons vu il s\'agit
d\'un moyen d\'effectuer la jointure. Mais SQL propose également des
opérateurs de jointure dans le `from` avec la syntaxe suivante:
`table1 opérateur table2 [condition]`

Les opérateurs disponibles sont:

> -   `cross join` le produit cartésien synonyme de la virgule;
> -   `join` la jointure accompagnée de conditions;
> -   `straight join` jointure forçant l\'ordre d\'accès aux tables
>     (déconseillé: mieux vaut laisser faire le système);
> -   `left [outer] join` et `right [outer] join`: jointures externes;
> -   `natural [left,right [outer]] join`: jointure \"naturelle\".

Le seul opérateur qui n\'est pas redondant avec des syntaxes présentées
précédemment est la jointure externe (`outer`). On peut à bon droit
considérer que cette multiplication de variantes syntaxiques ne fait que
compliquer le langage. Nous présentons dans ce qui suit les opérateurs
`join` et `outer join`. La jointure naturelle est une variante possible
quand la clé primaire et la clé étrangère ont le même nom.

L\'opérateur `join` permet d\'exprimer directement dans le `from` les
conditions de jointure. Il est très proche dans sa conception des
jointures à plat étudiées précédemment. Quelques exemples reprenant des
requêtes déjà exprimées suffiront pour comprendre le mécanisme.

> -   Quel est l\'appartement où habite M. William Dupont?
>
>     ``` {.sql}
>     select no, surface, etage
>     from Personne join Appart on (Personne.id_appart=Appart.id)
>     where prenom='William' and nom='Dupont'
>     ```
>
>     Il suffit de comparer avec la version combinant produit cartésien
>     et `where` pour se rendre compte que la différence est minime. On
>     peut tout à fait considérer que la version avec `join` est plus
>     claire.
>
> -   Qui habite un appartement de plus de 200 m2?
>
>     ``` {.sql}
>     select prenom, nom, profession
>     from Personne as p join Appart as a 
>             on (id_appart=a.id and surface>=200)
>     ```
>
>     Cet exemple illustre un \"détournement\" de la condition de
>     jointure. On y a inclus une condition de sélection (la surface
>     supérieure à 200). La requête est correcte mais il est possible
>     que la méthode d\'évaluation ne soit pas optimale.
>
>     Il faut souligner (nous y reviendrons) que ces variantes
>     alternatives représentent un défi pour le module chargé
>     d\'optimiser l\'évaluation des requêtes. Un avantage potentiel des
>     jointures à plat où tout est exprimé dans le `where` est qu\'elles
>     offrent une forme canonique à partir de laquelle un optimiseur
>     peut travailler avec un maximum de liberté.
>
> -   Qui habite le Barabas?
>
>     On peut composer deux opérateurs de jointure comme le montre ce
>     dernier exemple.
>
>     ``` {.sql}
>     select prenom, p.nom, no, surface, etage
>     from  Personne p join (Appart a join Immeuble i
>                             on id_immeuble=i.id)
>              on (id_appart=a.id)
>     where i.nom='Barabas'
>     ```

Contrairement aux jointures exprimées avec `join`, les jointures
externes ne peuvent pas s\'exprimer avec un `where`. Qu\'est-ce qu\'une
jointure externe? Effectuons la requête qui affiche tous les
appartements avec leur occupant.

``` {.sql}
select id_immeuble, no, etage, surface, nom, prenom
from  Appart as a join Personne as p on (p.id_appart=a.id)
```

Voici ce que l\'on obtient:

  --------------------------------------------------------------------------------
  id\_immeuble   no      etage   surface   nom                 prenom
  -------------- ------- ------- --------- ------------------- -------------------
  2              2       2       250       Ross                null

  1              52      5       50        Black               Alice

  1              1       14      150       Verte               Rachel

  1              51      2       200       Dupont              William

  2              1       1       250       Ramut               Doug
  --------------------------------------------------------------------------------

Il manque un appartement le 34 du Koudalou. En effet cet appartement
n\'a pas d\'occupant. Il n\'y a donc aucune possibilité que la condition
de jointure soit satisfaite.

La jointure externe permet d\'éviter cette élimination parfois
indésirable. On considère alors une hiérarchie entre les deux tables. La
première table (en général celle de gauche) est dite \"directrice\" et
toutes ses lignes, même celle qui ne trouvent pas de correspondant dans
la table de droite, seront prises en compte. Les lignes de la table de
droite sont en revanche optionnelle.

Si pour une ligne de la table de gauche on trouve une ligne satisfaisant
le critère de jointure dans la table de droite, alors la jointure
s\'effectue normalement. Sinon, les attributs provenant de la table de
droite sont affichés à `null`. Voici la jointure externe entre *Appart*
et *Personne*. Le mot-clé `outer` est optionnel.

``` {.sql}
select id_immeuble, no etage, surface, nom, prenom
from  Appart as a left outer join Personne as p on (p.id_appart=a.id)
```

  --------------------------------------------------------------------------------
  id\_immeuble   no      etage   surface   nom                 prenom
  -------------- ------- ------- --------- ------------------- -------------------
  1              1       14      150       Verte               Rachel

  1              34      15      50        null                null

  1              51      2       200       Dupont              William

  1              52      5       50        Black               Alice

  2              1       1       250       Ramut               Doug

  2              2       2       250       Ross                null
  --------------------------------------------------------------------------------

Notez les deux attributs `prenom` et `nom` à `null` pour l\'appartement
34.

Il existe un `right outer join` qui prend la table de droite comme table
directrice. On peut combiner la jointure externe avec des jointures
normales des sélections des tris etc. Voici la requête qui affiche le
nom de l\'immeuble en plus des informations précédentes et trie par
numéro d\'immeuble et numéro d\'appartement.

``` {.sql}
select i.nom, no, etage, surface, p.nom, prenom
from  Immeuble  as i  
       join 
           (Appart as a left outer join Personne as p
                      on (p.id_appart=a.id))
        on (i.id=a.id_immeuble)
order by i.id, a.no
```

Opérations ensemblistes
-----------------------

La norme SQL ANSI comprend des opérations qui considèrent les tables
comme des ensembles et effectuent des intersections des unions ou des
différences avec les mots-clé `union`, `intersect` ou `except`. Chaque
opérateur s\'applique à deux tables de schéma identique (même nombre
d\'attributs mêmes noms mêmes types).

L\'union est un opérateur peu utilisé car il est difficile de trouver
des cas où son application est justifiée. Voici un exemple montrant le
calcul de l\'union des noms d\'immeuble et des noms de personne.

``` {.sql}
select nom from Immeuble
 union
select nom from Personne
```

Le `except` exprime la différence entre deux ensembles. Il est
avantageusement remplacé par l\'utilisation des requêtes imbriquées et
des `not in` et `not exists` présentés ci-dessous.

Requêtes imbriquées
-------------------

Les requêtes peuvent être imbriquées les unes dans les autres de deux
manières:

> -   dans la clause `from`: la requête est placée entre parenthèses et
>     son résultat est vu comme une table;
> -   dans la clause `where` avec l\'opérateur `in` qui permet de tester
>     l\'appartenance de la valeur d\'un attribut à un ensemble calculé
>     par une requête.

Reprenons l\'exemple de la requête trouvant la surface et l\'étage de
l\'appartement de M. Dupont. On peut l\'exprimer avec une requête
imbriquée de deux manières:

``` {.sql}
select surface, etage
from Appart (select id_appart 
             from Personne
             where prenom='William' and nom='Dupont') as ri
where Appart.id = ri.id_appart

select surface, etage from Appart
where  id  in (select id_appart  
               from Personne
               where prenom='William' and nom='Dupont')
```

Le mot-clé `in` exprime la condition d\'appartenance de l\'identifiant
de l\'appartement à l\'ensemble d\'identifiants constitué avec la
requête imbriquée. Il doit y avoir correspondance entre le nombre et le
type des attributs auxquels s\'applique la comparaison par `in`.
L\'exemple suivant montre une comparaison entre des paires d\'attributs
(ici on cherche des informations sur les propriétaires).

``` {.sql}
select prenom, nom, surface, etage
from Appart as a join Personne as p on (a.id=p.id_appart)
where  (p.id p.id_appart)
          in (select id_personne id_appart from Possede)
```

  -------------------------------------------------------------------------
  prenom                    nom                       surface    etage
  ------------------------- ------------------------- ---------- ----------
  null                      Ross                      250        2

  Alice                     Black                     50         5

  Doug                      Ramut                     250        1
  -------------------------------------------------------------------------

Il est bien entendu assez direct de réécrire la requête ci-dessus comme
une jointure classique. Parfois l\'expression avec requête imbriquée
peut s\'avérer plus naturelle. Supposons que l\'on cherche les immeubles
dans lesquels on trouve un appartement de 50 m2. Voici l\'expression
avec requête imbriquée.

``` {.sql}
select * 
from Immeuble 
where id in (select id_immeuble from Appart where surface=50)
```

  -----------------------------------------------------------------------
  id          nom                           adresse
  ----------- ----------------------------- -----------------------------
  1           Koudalou                      3 Rue Blanche

  -----------------------------------------------------------------------

La requête directement réécrite en jointure donne le résultat suivant:

``` {.sql}
select i.* from Immeuble as i join Appart as a 
                 on (i.id=a.id_immeuble) 
where surface=50
```

  -----------------------------------------------------------------------
  id          nom                           adresse
  ----------- ----------------------------- -----------------------------
  1           Koudalou                      3 Rue Blanche

  1           Koudalou                      3 Rue Blanche
  -----------------------------------------------------------------------

On obtient deux fois le même immeuble puisqu\'il peut être associé à
deux appartements différents de 50 m2. Il suffit d\'ajouter un
`distinct` après le `select` pour régler le problème, mais on peut
considérer que dans ce cas la requête imbriquée est plus appropriée.
Attention cependant: il n\'est pas possible d\'obtenir dans le résultat
des attributs appartenant aux tables des requêtes imbriquées.

Le principe général des requêtes imbriquées est d\'exprimer des
conditions sur des tables calculées par des requêtes. Ces conditions
sont les suivantes:

> -   `exists R`: renvoie `true` si *R* n\'est pas vide `false` sinon.
> -   *t* `in R` où est une ligne dont le type (le nombre et le type des
>     attributs) est celui de *R*: renvoie `true` si *t* appartient à
>     *R* `false` sinon.
> -   *v* *cmp* `any R` où *cmp* est un comparateur SQL (*\<* *\>* *=*
>     etc.): renvoie `true` si la comparaison avec *au moins une* des
>     lignes de la table *R* renvoie `true`.
> -   *v* *cmp* `all R` où *cmp* est un comparateur SQL (*\<* *\>* *=*
>     etc.): renvoie `true` si la comparaison avec *toutes* les lignes
>     de la table *R* renvoie `true`.

De plus toutes ces expressions peuvent être préfixées par `not` pour
obtenir la négation. La richesse des expressions possibles permet
d\'effectuer une même interrogation en choisissant parmi plusieurs
syntaxes possibles. En général, tout ce qui n\'est pas basé sur une
négation `not in` ou `not exists` peut s\'exprimer *sans* requête
imbriquée.

Le cas du `all` correspond à une négation puisque si une propriété est
*toujours* vraie il n\'existe pas de cas où elle est fausse. La requête
ci-dessous applique le `all` pour chercher l\'étage le plus élevé de
l\'immeuble 1.

``` {.sql}
select * from Appart
    where id_immeuble=1
    and    etage >= all (select etage from Appart where id_immeuble=1)
```

Le `all` exprime une comparaison qui vaut pour *toutes* les lignes
ramenées par la requête imbriquée. Attention aux valeurs à `null` dans
ce genre de situation: toute comparaison avec une de ces valeurs renvoie
`UNKNOWN` et cela peut entraîner l\'échec du `all`. Il n\'existe pas
d\'expression avec jointure qui puisse exprimer ce genre de condition.

Requêtes correlées
------------------

Les exemples de requêtes imbriquées donnés précédemment pouvaient être
évalués indépendamment de la requête principale, ce qui permet au
système (s\'il le juge nécessaire) d\'exécuter la requête en deux
phases. La clause `exists` fournit encore un nouveau moyen d\'exprimer
les requêtes vues précédemment en basant la sous-requête sur une ou
plusieurs valeurs issues de la requête principale. On parle alors de
requêtes *correlées*.

Voici encore une fois la recherche de l\'appartement de M. William
Dupont exprimée avec `exists`:

``` {.sql}
select * from Appart
where  exists  (select * from Personne
                where  prenom='William' and nom='Dupont'
                and    Personne.id_appart=Appart.id)
```

On obtient donc une nouvelle technique d\'expression qui permet
d\'aborder le critère de recherche sous une troisième perspective: on
conserve un appartement si, *pour cet appartement*, l\'occupant
s\'appelle William Dupont. Il s\'agit assez visiblement d\'une jointure
mais entre deux tables situées dans des requêtes (ou plutôt des
\"blocs\") distinctes. La condition de jointure est appelée corrélation
d\'où le nom de ce type de technique.

Toutes les jointures peuvent d\'exprimer avec `exists` ou `in`. Voici
quelques exemples reprenant des requêtes déjà vues précédemment.

> -   Qui habite un appartement de plus de 200 m2?
>
>     Avec `in`:
>
>     ``` {.sql}
>     select prenom nom profession      
>     from Personne      
>     where id_appart in (select id from Appart where surface >= 200)
>     ```
>
>     Avec `exists`:
>
>     ``` {.sql}
>     select prenom nom profession      
>     from Personne  p    
>     where exists (select * from Appart a 
>                   where a.id=p.id_appart 
>                   and surface >= 200)
>     ```
>
> -   Qui habite le Barabas?
>
>     Avec `in`:
>
>     ``` {.sql}
>     select prenom p.nom no surface etage
>     from   Personne as p Appart as a
>     where  p.id_appart=a.id
>     and a.id_immeuble in 
>              (select id from Immeuble
>               where  nom='Barabas')
>     ```
>
>     Avec `exists`:
>
>     ``` {.sql}
>     select prenom p.nom no surface etage 
>     from Personne as p Appart as a 
>     where  p.id_appart=a.id 
>     and exists (select * from Immeuble i
>                 where  i.id=a.id_immeuble 
>                 and i.nom='Barabas')
>     ```

::: {.important}
::: {.title}
Important
:::

dans une sous-requête associée à la clause `exists` peu importe les
attributs du `select` puisque la condition se résume à: cette requête
ramène-t-elle au moins une ligne ou non? On peut donc systématiquement
utiliser `select *`.
:::

Enfin rien n\'empêche d\'utiliser plusieurs niveaux d\'imbrication au
prix d\'une forte dégradation de la lisibilité. Voici la requête \"De
quel(s) appartement(s) Alice Black est-elle propriétaire et dans quel
immeuble?\" écrite avec plusieurs niveaux.

``` {.sql}
select i.nom no etage surface
from  Immeuble as i Appart as a
where  a.id_immeuble= i.id
and    a.id in 
             (select id_appart from Possede
              where id_personne in
                       (select id from Personne
                        where  nom='Black' 
                        and prenom='Alice'))
```

En résumé une jointure entre les tables *R* et *S* de la forme:

``` {.sql}
select R.*
from R S
where R.a = S.b
```

peut s\'écrire de manière équivalente avec une requête imbriquée:

``` {.sql}
select [distinct] *
from R
where R.a in (select S.b from S)
```

ou bien encore sous forme de requête corrélée:

``` {.sql}
select [distinct] *
from R
where exists (select S.b from S where S.b = R.a)
```

Le choix de la forme est matière de goût ou de lisibilité, ces deux
critères relevant de considérations essentiellement subjectives.

Requêtes avec négation
----------------------

Les requêtes imbriquées sont en revanche irremplaçables pour exprimer
des négations. On utilise alors `not in` ou (de manière équivalente)
`not exists`. Voici un premier exemple avec la requête: *donner les
appartements sans occupant*.

``` {.sql}
select * from Appart
where  id not in (select id_appart from Personne)
```

  --------------------------------------------------------------------------
  id             surface        etage          id\_immeuble   no
  -------------- -------------- -------------- -------------- --------------
  101            50             15             1              34

  --------------------------------------------------------------------------

La négation est aussi un moyen d\'exprimer des requêtes courantes comme
celle recherchant l\'appartement le plus élevé de son immeuble. En SQL,
on utilisera typiquement une sous-requête pour prendre l\'étage maximal
d\'un immeuble, et on utilisera cet étage pour sélectionner un ou
plusieurs appartements, le tout avec une requête correlée pour ne
comparer que des appartements situés dans le même immeuble.

``` {.sql}
select *
from Appart as a1
where etage =  (select max(etage) from Appart as a2
                where a1.id_immeuble=a2.id_immeuble)
```

  --------------------------------------------------------------------------
  id             surface        etage          id\_immeuble   no
  -------------- -------------- -------------- -------------- --------------
  101            50             15             1              34

  202            250            2              2              2
  --------------------------------------------------------------------------

Il existe en fait beaucoup de manières d\'exprimer la même chose. Tout
d\'abord cette requête peut en fait s\'exprimer sans la fonction *max()*
avec la négation: si *a* est l\'appartement le plus élevé, c\'est
*qu\'il n\'existe pas* d\'étage plus elevé que *a*. On utilise alors
habituellement une requête dite \"corrélée\" dans laquelle la
sous-requête est basée sur une ou plusieurs valeurs issues des tables de
la requête principale.

``` {.sql}
select *
from Appart as a1
where not exists  (select * from Appart as a2
                   where a2.etage > a1.etage
                   and a1.id_immeuble = a2.id_immeuble)
```

Autre manière d\'exprimer la même chose: si l\'étage est le plus élevé,
tous les autres sont situés à un étage inférieur. On peut utiliser le
mot-clé `all` qui indique que la comparaison est vraie avec *tous* les
éléments de l\'ensemble constitué par la sous-requête.

``` {.sql}
select *
from Appart as a1
where etage >= all (select etage from Appart as a2
                where a1.id_immeuble=a2.id_immeuble)
```

Dernier exemple de négation: quels sont les personnes qui ne possèdent
aucun appartement même partiellement? Les deux formulations ci-dessous
sont équivalentes, l\'une s\'appuyant sur `not in`, et l\'autre sur
`not exists`.

``` {.sql}
select *
from Personne
where id not in (select id_personne from Possede)

select *
from Personne as p1
where not exists (select * from Possede as p2
                  where p1.id=p2.id_personne)
```

Agrégats
========

Les requêtes agrégat en SQL consistent à effectuer des regroupements de
lignes en fonction des valeurs d\'une ou plusieurs expressions. Ce
regroupement est spécifié par la clause `group by`. On obtient une
structure qui n\'est pas une table relationnelle puisqu\'il s\'agit
d\'un ensemble de groupes de lignes. On doit ensuite ramener cette
structure à une table en appliquant des *fonctions de groupes* qui
déterminent des valeurs agrégées calculées pour chaque groupe.

Enfin il est possible d\'exprimer des conditions sur les valeurs
agrégées pour ne conserver qu\'un ou plusieurs des groupes constitués.
Ces conditions portent sur des *groupes* de lignes et ne peuvent donc
être obtenues avec `where`. On utilise alors la clause `having`.

Les agrégats s\'effectuent *toujours* sur le résultat d\'une requête
classique `select - from`. On peut donc les voir comme une extension de
SQL consistant à partitionner un résultat en groupes selon certains
critères, puis à exprimer des conditions sur ces groupes, et enfin à
appliquer des fonctions d\'agrégation.

Il existe un groupe par défaut: c\'est la table toute entière. Sans même
utiliser `group by`, on peut appliquer les fonctions d\'agrégation au
contenu entier de la table comme le montre l\'exemple suivant.

``` {.sql}
select count(*), count(prenom), count(nom) 
from Personne
```

Ce qui donne:

  -----------------------------------------------------------------------
  count(\*)               count(prenom)           count(nom)
  ----------------------- ----------------------- -----------------------
  5                       4                       5

  -----------------------------------------------------------------------

On obtient 5 pour le nombre de lignes, 4 pour le nombre de prénoms, et 5
pour le nombre de noms. En effet, l\'attribut `prenom` est à `null` pour
la première personne et n\'est en conséquence pas pris en compte par la
fonction d\'agrégation. Pour compter toutes les lignes, on doit utiliser
`count(*)` ou un attribut déclaré comme `not null`. On peut aussi
compter le nombre de valeurs distinctes dans un groupe avec
`count(distinct <expression>)`.

La clause `group by`
--------------------

Le rôle du `group by` est de partitionner une table (calculée ou basée)
en fonction d\'un critère (un attribut ou plus généralement une
expression sur des attributs). Pour bien analyser ce qui se passe
pendant une requête avec `group by` on peut décomposer l\'exécution
d\'une requête en deux étapes. Prenons l\'exemple de celle permettant de
vérifier que la somme des quote-part des propriétaires est bien égale à
100 pour tous les appartements.

``` {.sql}
select  id_appart sum(quote_part)
from    Possede
group by id_appart
```

  -----------------------------------------------------------------------
  id\_appart                          sum(quote\_part)
  ----------------------------------- -----------------------------------
  100                                 100

  101                                 100

  102                                 100

  103                                 100

  201                                 100

  202                                 100
  -----------------------------------------------------------------------

Dans une première étape le système va constituer les groupes. On peut
les représenter avec un tableau comprenant, pour chaque ligne, d\'une
part la (ou les) valeur(s) du (ou des) attribut(s) de partitionnement
(ici `id_appart`), d\'autre part l\'ensemble de lignes dans lesquelles
on trouve cette valeur. Ces lignes \"imbriquées\" sont séparées par des
points-virgule dans la représentation ci-dessous.

  -----------------------------------------------------------------------
  id\_appart      Groupe                                  count
  --------------- --------------------------------------- ---------------
  100             (id\_personne=1 quote\_part=33 ;        2
                  id\_personne=5 quote\_part=67)          

  101             (id\_personne=1 quote\_part=100)        1

  102             (id\_personne=5 quote\_part=100)        1

  202             (id\_personne=1 quote\_part=100)        1

  201             (id\_personne=5 quote\_part=100)        1

  103             (id\_personne=2 quote\_part=100)        1
  -----------------------------------------------------------------------

Le groupe associé à l\'appartement 100 est constitué de deux
copropriétaires. Le tableau ci-dessus n\'est donc pas une table
relationnelle dans laquelle chaque cellule ne peut contenir qu\'une
seule valeur.

Pour se ramener à une table relationnelle, on transforme durant la
deuxième étape chaque groupe de lignes en une valeur par application
d\'une fonction d\'agrégation. La fonction `count()` compte le nombre de
lignes dans chaque groupe, `max()` donne la valeur maximale d\'un
attribut parmi l\'ensemble des lignes du groupe, etc. La liste des
fonctions d\'agrégation est donnée ci-dessous:

> -   `count(expression)`, Compte le nombre de lignes pour lesquelles
>     `expression` est `not null`.
> -   `avg(expression`), Calcule la moyenne de `expression`.
> -   `min(expression`), Calcule la valeur minimale de `expression`.
> -   `max(expression`), Calcule la valeur maximale de `expression`.
> -   `sum(expression`), Calcule la somme de `expression`.
> -   `std(expression`), Calcule l\'écart-type de `expression`.

Dans la norme SQL l\'utilisation de fonctions d\'agrégation pour les
attributs qui n\'apparaissent pas dans le `group by` est *obligatoire*.
Une requête comme:

``` {.sql}
select  id, surface, max(etage)
from    Appart
group by surface
```

srea rejetée parce que le groupe associé à une même surface contient
deux appartements différents (et donc deux valeurs différentes pour
`id`), et qu\'il n\'y a pas de raison d\'afficher l\'un plutôt que
l\'autre.

La clause having
----------------

Finalement, on peut faire porter des conditions sur les groupes, ou plus
précisément sur le résultat de fonctions d\'agrégation appliquées à des
groupes avec la clause `having`. La clause `where` ne peut exprimer des
conditions que sur les lignes prises une à une. Par exemple, on peut
sélectionner les appartements pour lesquels on connaît au moins deux
copropriétaires.

``` {.sql}
select  id_appart, count(*)
from    Possede
group by id_appart
having count(*) >= 2
```

On voit que la condition porte ici sur une propriété de l\'*ensemble*
des lignes du groupe et pas de chaque ligne prise individuellement. La
clause `having` est donc toujours exprimée sur le résultat de fonctions
d\'agrégation.

Pour conclure, voici une requête sélectionnant la surface possédée par
chaque copropriétaire pour l\'immeuble 1. La surface possédée est la
somme des surfaces d\'appartements possédés par un propriétaire,
pondérées par leur quote-part. On regroupe par propriétaire et on trie
sur la surface possédée.

``` {.sql}
select prenom nom,
       sum(quote_part * surface / 100) as 'Surface possédée'
from (Personne as p1 join Possede as p2 on (p1.id=p2.id_personne) )
          join  Appart as a on (a.id=p2.id_appart)
where id_immeuble = 1
group by p1.id
order by sum(quote_part * surface / 100)
```

On obtient le résultat suivant.

  -----------------------------------------------------------------------
  prénom                        nom                           Surface
                                                              possédée
  ----------------------------- ----------------------------- -----------
  Alice                         Black                         50.00000

  null                          Ross                          125.00000

  Doug                          Ramut                         275.00000
  -----------------------------------------------------------------------

Mises à jour
============

Les commandes de mise à jour (insertion, destruction, modification) sont
considérablement plus simples que les interrogations.

Insertion
---------

L\'insertion s\'effectue avec la commande `insert`, avec trois
variantes. Dans la première on indique la liste des valeurs à insérer
sans donner explicitement le nom des attributs. Le système suppose alors
qu\'il y a autant de valeurs que d\'attributs, et que l\'ordre des
valeurs correspond à celui des attributs dans la table. On peut indiquer
`null` pour les valeurs inconnues.

``` {.sql}
insert into Immeuble
values (1 'Koudalou' '3 Rue Blanche')
```

Si on veut insérer dans une partie seulement des attributs, il faut
donner la liste explicitement.

``` {.sql}
insert into Immeuble (id nom adresse)
values (1 'Koudalou' '3 Rue Blanche')
```

Il est d\'ailleurs préférable de toujours donner la liste des attributs.
La description d\'une table peut changer par ajout d\'attribut, et
l\'ordre `insert` qui marchait un jour ne marchera plus le lendemain.

Enfin avec la troisième forme de `insert` il est possible d\'insérer
dans une table le résultat d\'une requête. Dans ce cas la partie
`values` est remplacée par la requête elle-même. Voici un exemple avec
une nouvelle table *Barabas* dans laquelle on insère uniquement les
informations sur l\'immeuble \"Barabas\".

``` {.sql}
create table Barabas (id int not null,
                     nom varchar(100) not null,
                     adresse varchar(200),
                     primary key (id)
)

insert into Barabas
select * from Immeuble where nom='Barabas'
```

Destruction
-----------

La destruction s\'effectue avec la clause `delete` dont la syntaxe est:

``` {.sql}
delete from table
where condition
```

`table` étant bien entendu le nom de la table, et `condition` toute
condition ou liste de conditions valide pour une clause `where`. En
d\'autres termes, si on effectue avant la destruction la requête

``` {.sql}
select * from table
where condition
```

on obtient l\'ensemble des lignes qui seront détruites par `delete`.
Procéder de cette manière est un des moyens de s\'assurer que l\'on va
bien détruire ce que l\'on souhaite.

Modification
------------

La modification s\'effectue avec la clause `update`. La syntaxe est
proche de celle du `delete`:

``` {.sql}
update table set A1=v1, A2=v2, ... An=vn
where condition
```

Comme précédemment `table` est la table, les `Ai` sont les attributs les
`vi` les nouvelles valeurs, et `condition` est toute condition valide
pour la clause `where`.

Les vues
========

Une requête SQL produit toujours une table. Cela suggère la possibilité
d\'ajouter au schéma des tables *calculées*, qui ne sont rien d\'autre
que le résultat de requêtes stockées. De telles tables sont nommées des
*vues* dans la terminologie relationnelle. On peut interroger des vues
comme des tables stockées et, dans certaines limites, faire des mises à
jour des tables stockées au travers de vues.

Une vue n\'induit aucun stockage puisqu\'elle n\'existe pas
physiquement. Elle permet d\'obtenir une représentation différente des
tables sur lesquelles elle est basée avec deux grands avantages:

> -   on peut faciliter l\'interrogation de la base en fournissant sous
>     forme de vues des requêtes prédéfinies;
> -   on peut masquer certaines informations en créant des vues et en
>     forçant par des droits d\'accès l\'utilisateur à passer par ces
>     vues pour accéder à la base.

Les *vues* constituent donc un moyen complémentaire de contribuer à la
sécurité (par restriction d\'accès) et à la facilité d\'utilisation (en
offrant une \"schéma virtuel\" simplifié).

Création et interrogation d\'une vue
------------------------------------

Une vue est en tout point comparable à une table: en particulier on peut
l\'interroger par SQL. La grande différence est qu\'une vue est le
résultat d\'une requête avec la caractéristique essentielle que ce
résultat est réévalué à chaque fois que l\'on accède à la vue. En
d\'autres termes une vue est *dynamique*: elle donne une représentation
fidèle de la base au moment de l\'évaluation de la requête.

Une vue est essentiellement une requête à laquelle on a donné un nom. La
syntaxe de création d\'une vue est très simple:

``` {.sql}
create view nomvue ([listeattributs])
as          requete
[with check option]
```

Nous avons déjà vu au début de ce chapitre vl\'exemple d\'une vue sur la
table *Immeuble* montrant uniquement le Koudalou. En voici une nouvelle
version plus complète avec le nombre d\'appartements.

``` {.sql}
create Koudalou as 
     select nom, adresse, count(*) as nb_apparts 
     from Immeuble as i join Appart as a on (i.id=a.id_immeuble)
     where i.id=1
     group by i.id, nom, adresse
```

La destruction d\'une vue a évidemment beaucoup moins de conséquences
que pour une table puisqu\'on supprime uniquement la *définition* de la
vue pas son *contenu*.

On interroge la vue comme n\'importe quelle table.

``` {.sql}
select * from Koudalou
```

  -------------------------------------------------------------------------
  nom                           adresse                       nb\_apparts
  ----------------------------- ----------------------------- -------------
  Koudalou                      3 Rue Blanche                 4

  -------------------------------------------------------------------------

La vue fait maintenant partie du schéma. On ne peut d\'ailleurs
évidemment pas créer une vue avec le même nom qu\'une table (ou vue)
existante. La définition d\'une vue peut consister en un requête SQL
aussi complexe que nécessaire, avec jointures, regroupements, tris.

Allons un peu plus loin en définissant sous forme de vues un accès aux
informations de notre base *Immeuble*, mais restreint uniquement à tout
ce qui concerne l\'immeuble Koudalou. On va en profiter pour offrir dans
ces vues un accès plus facile à l\'information. La vue sur les
appartements, par exemple, va contenir contrairement à la table *Appart*
le nom et l\'adresse de l\'immeuble et le nom de son occupant.

``` {.sql}
create or replace view AppartKoudalou as 
   select no, surface, etage, i.nom as immeuble, adresse,
          p.prenom ||  p.nom as occupant 
   from (Immeuble as i join Appart as a on (i.id=a.id_immeuble))
             join Personne as p on (a.id=p.id_appart)
   where i.id=1 
```

On voit bien sur cet exemple que l\'un des intérêts des vues est de
donner une représentation \"dénormalisée\" de la base en regroupant des
informations par des jointures. Le contenu étant virtuel, il n\'y a ici
aucun inconvénient à \"voir\" la redondance du nom de l\'immeuble et de
son adresse. Le bénéfice, en revanche, est la possibilité d\'obtenir
très simplement toutes les informations utiles.

``` {.sql}
select * from AppartKoudalou
```

  ---------------------------------------------------------------------------
  no     surface   etage   immeuble         adresse          occupant
  ------ --------- ------- ---------------- ---------------- ----------------
  52     50        5       Koudalou         3 Rue Blanche    Alice Black

  1      150       14      Koudalou         3 Rue Blanche    Rachel Verte

  51     200       2       Koudalou         3 Rue Blanche    William Dupont
  ---------------------------------------------------------------------------

Le nom des attributs de la vue est celui des expressions de la requête
associée. On peut également donner ces noms après le `create view` à
condition qu\'il y ait correspondance univoque entre un nom et une
expression du `select`. On peut ensuite donner des droits en lecture sur
cette vue pour que cette information limitée soit disponible à tous.

``` {.sql}
grant select on Immeuble.Koudalou Immeuble.AppartKoudalou to adminKoudalou
```

Pour peu que cet utilisateur n\'ait aucun droit de lecture sur les
tables de la base *Immeuble*, on obtient un moyen simple de masquer et
restructurer l\'information.

Mise à jour d\'une vue
----------------------

L\'idée de modifier une vue peut sembler étrange puisqu\'une vue n\'a
pas de contenu. En fait il s\'agit bien entendu de modifier la table qui
sert de support à la vue. Il existe de sévères restrictions sur les
droits d\'insérer ou de mettre à jour des tables au travers des vues. Un
exemple suffit pour comprendre le problème. Imaginons que l\'on souhaite
insérer une ligne dans la vue *AppartKoudalou*.

``` {.sql}
insert into AppartKoudalou (no, surface, etage, immeuble, adresse, occupant) 
values (1, 12, 4, 'Globe', '2 Avenue Leclerc', 'Palamède')
```

Le système rejettera cette requête (par exemple, pour MySQL, avec le
message
`Can not modify more than one base table  through a join view 'Immeuble.AppartKoudalou'`).
Cet ordre s\'adresse à une vue issue de trois tables. Il n\'y a
clairement pas assez d\'information pour alimenter ces tables de manière
cohérente et l\'insertion n\'est pas possible (de même que toute mise à
jour). De telles vues sont dites *non modifiables*. Les règles
définissant les vues modifiables sont assez strictes et difficiles à
résumer simplement d\'autant qu\'elles varient selon l\'opération
(`update`, `delete`, ou `insert`). En première approximation on peut
retenir les points suivants qui donnent lieu à quelques exceptions sur
lesquelles nous reviendrons ensuite.

> -   la vue doit être basée sur une seule table; toute colonne non
>     référencée dans la vue doit pouvoir être mise à `null` ou disposer
>     d\'une valeur par défaut;
> -   on ne peut pas mettre à jour un attribut qui résulte d\'un calcul
>     ou d\'une opération.

On ne peut donc pas insérer ou modifier la vue *Koudalou* à cause de la
jointure et de l\'attribut calculé. La requête suivante serait rejetée.

``` {.sql}
insert into Koudalou (nom, adresse) 
values ('Globe', '2 Avenue Leclerc')
```

En revanche une vue portant sur une seule table avec un `select *` est
modifiable.

``` {.sql}
create view PossedeAlice 
   as select * from Possede 
  where id_personne=2

insert into PossedeAlice values (2 100 20)
insert into PossedeAlice values (3 100 20)
```

Maintenant, si on fait:

``` {.sql}
select * from PossedeAlice
```

On obtient:

  -----------------------------------------------------------------------
  id\_personne            id\_appart              quote\_part
  ----------------------- ----------------------- -----------------------
  2                       100                     20

  2                       103                     100
  -----------------------------------------------------------------------

L\'insertion précédente illustre une petite subtilité: on peut insérer
dans une vue sans être en mesure de voir la ligne insérée au travers de
la vue par la suite! On a en effet inséré dans la vue le propriétaire 3
qui est ensuite filtré quand on interroge la vue.

SQL propose l\'option `with check option` qui permet de garantir que
toute ligne insérée dans la vue satisfait les critères de sélection de
la vue.

``` {.sql}
create view PossedeAlice 
as select * from Possede 
where id_personne=2 
with check option
```

SQL permet également la modification de vues définies par des jointures.
Les restrictions sont essentielement les même que pour les vues
mono-tabulaires: on ne peut insérer que dans une des tables (il faut
donc préciser la liste des attributs) et tous les attributs `not null`
doivent avoir une valeur. Voici un exemple de vue modifiable basée sur
une jointure.

``` {.sql}
create or replace view ToutKoudalou
as select i.id as id_imm, nom, adresse, a.* 
   from Immeuble as i join Appart as a on (i.id=a.id_immeuble)
   where i.id=1
   with check option
```

Il est alors possible d\'insérer à condition d\'indiquer des attributs
d\'une seule des deux tables. La commande ci-dessous ajoute un nouvel
appartement au *Koudalou*.

``` {.sql}
insert into ToutKoudalou (id, surface, etage, id_immeuble, no)
values (104, 70, 12, 1, 65)
```

En conclusion, l\'intérêt principal des vues est de permettre une
restructuration du schéma en vue d\'interroger et/ou de protéger des
données. L\'utilisation de vues pour des mises à jour devrait rester
marginale.
