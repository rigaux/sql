Correction de l\'examen
=======================

Conception
----------

Le schéma E/A est donné dans la `examen-blanc-2019`{.interpreted-text
role="numref"}. Notez que l\'on ne représente pas les clés étrangères
comme attributs des entités: les clés étrangères sont le mécanisme *du
modèle relationnel* pour représenter les liens entre entités. Dans le
*modele EA*, ces liens sont des associations, et il serait donc
redondant de faire figure également les clés étrangères

Le nommage des assocations et des attributs est libre, l\'important est
de privilégier la clarté et la précision, notamment pour les
associations.

> Le schéma E/A après rétro-conception

Le type d\'entité `Billet` est issu d\'une réification d\'une
association plusieurs-plusieurs. La principale différence est que les
billets ont maintenant leur identifiant propre, alors que l\'association
plusieurs-plusieurs est identifiée par la paire (idSpectacle,
idPersonne).

Voici la commande de création de la salle. On a choisi de mettre
`not null` partout pour maximiser la qualité de la base, ce sont des
contraintes que l\'on peut facilement lever si nécessaire.

``` {.sql}
create table Spectacle (id integer not null,
       idArtiste integer not null,
       idSalle integer not null,
       dateSpectacle date not null,
       nbBilletsVendus integer not null,
       primary key (id),
       foreign key (idArtiste) references Personne (id),
       foreign key (idSalle) references Salle (id)
       )
```

Dans le schéma relationnel proposé, il est possible d\'avoir plusieurs
billets (avec des identifiants distincts) pour le même spectacle et le
même spectateur. C\'est un effet de la réification: on a perdu la
contrainte d\'unicité sur la paire (idSpectacle, idPersonne).

On peut se poser la question d\'ajouter ou non cette contrainte. Si oui,
alors (idSpectacle, idSpectateur) devient une clé secondaire, que l\'on
déclare avec la clause `unique` dans la commande de création de la table
`Billet`.

``` {.sql}
create table Billet (id integer not null,
       idSpectacle integer not null,
       idSpectateur integer not null,
       catégorie varchar(4) integer not null,
       prix float non null,
       primary key (id),
       unique (idSpectacle, idSpectateur),
       foreign key (idSpectacle) references Spectacle (id),
       foreign key (idSpectateur) references Personne (id)
       )
```

SQL
---

Deux requêtes sont équivalentes si elles donnent toujours le même
résultat, quelle que soit la base.

``` {.sql}
select p.nom
from Personne as p, Spectacle s, Salle l
where p.id = s.idArtiste AND s.idSalle = l.id 
AND l.nom = 'Bercy' AND p.age >= 70
```

``` {.sql}
select p.nom as nomArtiste, s.nom as nomSalle, s.nbBilletsVendus
from Peronne as p, Spectacle as sp, Salle as s
where p.id = sp.idArtiste
and sp.idSalle = s.id
order by s.nbBilletsVendus
```

``` {.sql}
select prénom, nom
from Personne as p
where not exists (select '' from Billet where idSpectateur = p.id)
```

``` {.sql}
select p.nom, count(*), sum(prix)
from Personne as p, Billet as b
where p.id = b.idSpectateur
group by p.id, p.nom
having count(*) >= 10
```

Algèbre
-------

> -   La requête 4 renvoie 2 nuplets: (1,1) et (6,6)
> -   La requête renvoie 3 nuplets: (1,0,1), (1,0,7) et (4,1,2)
> -   La requête renvoie également 3 nuplets
> -   $\pi_{nom, prenom}(Personne \underset{id=idSpectateur}{\bowtie} \sigma_{prix > 500}(BILLET))$
> -   $\pi_{id}(Personne) - \pi_{idArtiste} (Spectacle)$

Transactions
------------

Le mode sérialisable entraîne des rejets de transactions.

Le nombre de billets vendus (`nbBilletsVendus` dans `Spectacle`) pour un
spectacle est égal au nombre de lignes dans `Billet` pour ce même
spectacle.

Autre possibilité: pas plus de billets vendus que de places dans la
salle.

Un `update` de `Spectacle` pour incrémenter `nbBilletsVendus`,

``` {.sql}
update Spectacle set nbBilletsVendus=nbBilletsVendus+1 where idSpectacle=v_idSpectacle
```

et un `insert` dans `Billet`.

``` {.sql}
insert into Billet (id, idSpectateur, idSpectacle, catégorie, prix)
value (1234, v_idSpectateur, v_idSpectacle, v_catégorie, v_prix)
```

Le `commit` vient à la fin car c\'est seulement à ce moment que la base
est à nouveau dans un état cohérent.

Corrigé
=======

Conception
----------

> -   Oui, la base permet de représenter un but marqué dans un match
>     opposant deux équipes dont aucune n\'est celle du joueur.
>
> -   Oui, par transitivité $But \to Match$, $Match \to Stade$ et
>     $Stade \to Ville$.
>
> -   Schéma
>
>     ``` {.sql}
>     CREATE TABLE Match(
>            id NUMBER(10), 
>           idStade NUMBER(10), 
>           dateMatch DATE, 
>           idEquipe1 NUMBER(10), 
>           idEquipe2 NUMBER(10), 
>           scoreEquipe1 NUMBER(10), 
>           scoreEquipe2 NUMBER(10),
>           PRIMARY KEY (id),
>           FOREIGN KEY (idStade) REFERENCES Stade(id),
>           FOREIGN KEY (idEquipe1) REFERENCES Equipe(id),
>           FOREIGN KEY (idEquipe2) REFERENCES Equipe(id)
>     );
>     ```
>
> -   
>
>     Le pays est clé candidate pour l\'équipe. Il faudrait alors l\'utiliser comme clé étrangère
>
>     :   partout.

SQL
---

``` {.sql}
select nom 
from Joueur as j, But as b
where j.id = b.idJoueur and j.âge > 30 and b.minute = 1

select nom 
from Joueur as j, Equipe as e
where j.idEquipe = e.id 
and e.pays = 'France' 
and j.id NOT IN (select idJoueur from But)

select prixBillet 
from Stade as s1
where not exists (select ''
             from Stade as s2
             where s2.prixBillet >= s1.prixBillet)

select entraineur, count(*)
from Equipe as e, Joueur as j, But as b
where e.id=j.idEquipe
and b.idJoueur = j.id
group by e.id, e.entraineur

select prénom, nom
from Match as m, Joueur as j, But as b
where e.id=j.idEquipe
and b.idJoueur = j.id
and m.id = b.idMatch
and e.id != m.idEquipe1
and e.id != e.idEquipe2
```

Il faut soit Match.equipe1=\'France\', soit Match.equipe2=\'France\'.

``` {.sql}
select j.nom
from Match m, Equipe e1, Equipe e2, Joueur j, Stade s, But b
where m.idEquipe1 = e1.id 
and m.idEquipe2 = e2
and ((e1.pays = 'France' id and e2.pays='Suisse' and e1.id = j.idEquipe)
      or
  (e2.pays = 'France' id and e1.pays='Suisse' and e2.id = j.idEquipe))
and m.idStade = s.id 
and s.ville = 'Lille' 
and b.idJoueur = j.id 
and b.idMatch = m.id )
```

Algèbre
-------

$$\pi_{nom}(\sigma_{age > 30} (Joueur) \underset{id=idJoueur}{\bowtie} \sigma_{minute = 1}(But) )$$

Joueurs français:

> A = s[igma](){pays=\'France\'}(Joueur;j) underset{j.idEquipe =
> e.id}{bowtie} Equipe;e)

Joueurs français qui ont marqué au moins un but :

$$B = \sigma_{pays='France'}(But\;b \underset{b.idJoueur = j.id}{\bowtie} Joueur\;j) \underset{j.idEquipe = e.id}{\bowtie} Equipe\;e)$$

Résultat:

$$Resultat := A - B$$

Les matchs nuls 0-0 pour lequel il existe quand même un but.

``` {.sql}
select idMatch
from But as b, Match as m
where b.idMatch=m.id
and m.scoreEquipe1=0 
and m.scoreEquipe2=0
```
