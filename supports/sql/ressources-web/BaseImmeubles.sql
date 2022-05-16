/*
* Données de la base Immeuble - - Cf. http://sql.bdpedia.fr
*/

insert into Immeuble (id, nom, adresse)
  values (1, 'Koudalou', '3, rue des Martyrs');
insert into Immeuble (id, nom, adresse)
  values (2, 'Barabas', '2, allée du Grand Turc');

insert into Appart(id, no, surface, niveau, idImmeuble)
values (100, 1, 150, 14, 1);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (101, 34, 50, 15, 1);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (102, 51, 200, 2, 1);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (103, 52, 50, 5, 1);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (104, 43, 75, 3, 1);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (200, 10, 150, 0, 2);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (201, 1, 250, 1, 2);
insert into Appart(id, no, surface, niveau, idImmeuble)
values (202, 2, 250, 2, 2);

insert into Personne (id, prénom, nom, profession, idAppart)
values (1, NULL, 'Prof', 'Enseignant', 202);
insert into Personne (id, prénom, nom, profession, idAppart)
values (2, 'Alice', 'Grincheux', 'Cadre', 103);
insert into Personne (id, prénom, nom, profession, idAppart)
values (3, 'Léonie', 'Atchoum', 'Stagiaire', 100);
insert into Personne (id, prénom, nom, profession, idAppart)
values (4, 'Barnabé', 'Simplet', 'Acteur', 102);
insert into Personne (id, prénom, nom, profession, idAppart)
values (5, 'Alphonsine', 'Joyeux', 'Rentier', 201);
insert into Personne (id, prénom, nom, profession, idAppart)
values (6, 'Brandon', 'Timide', 'Rentier', 104);
insert into Personne (id, prénom, nom, profession, idAppart)
values (7, 'Don-Jean', 'Dormeur', 'Musicien', 200);

insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (1, 100, 33);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (5, 100, 67);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (1, 101, 100);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (5, 102, 100);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (1, 202, 100);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (5, 201, 100);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (2, 103, 100);
insert into  Propriétaire (idPersonne, idAppart, quotePart)
values (2, 104, 100);
