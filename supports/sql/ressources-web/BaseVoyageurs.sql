/*
* Auteur : Philippe Rigaux (philippe.rigaux@cnam.fr)
* Objet :  Création de la base Voayageurs. Cf. http://sql.bdpedia.fr
* 
*/


/* Table Voyageur         */

insert into Voyageur (idVoyageur, nom,  prénom, ville, région)
values (10, 'Fogg', 'Phileas', 'Ajaccio', 'Corse');
insert into Voyageur (idVoyageur, nom,  prénom, ville, région)
values (20, 'Bouvier', 'Nicolas', 'Aurillac', 'Auvergne');
insert into Voyageur (idVoyageur, nom,  prénom, ville, région)
values (30, 'David-Néel', 'Alexandra', 'Lhassa', 'Tibet');
insert into Voyageur (idVoyageur, nom,  prénom, ville, région)
values (40, 'Stevenson', 'Robert Louis', 'Vannes', 'Bretagne');

/* Table Logement                */

insert into Logement (code, nom, capacité, type, lieu)
  values     ('pi', 'U Pinzutu', 10, 'Gîte', 'Corse') ;
insert into Logement (code, nom, capacité, type, lieu)
  values     ('ta', 'Tabriz', 34, 'Hôtel', 'Bretagne') ;
insert into Logement (code, nom, capacité, type, lieu)
  values     ('ca', 'Causses', 45, 'Auberge', 'Cévennes') ;
insert into Logement (code, nom, capacité, type, lieu)
  values     ('ge', 'Génépi', 134, 'Hôtel', 'Alpes') ;

  
/* Table Séjour        */

insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (1, 10, 'pi', 20,  20);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (2, 20, 'ta', 21,  22);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (3, 30, 'ge', 2,  3);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (4, 20, 'pi', 19,  23);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (5, 20, 'ge', 22,  24);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (6, 10, 'pi', 10,  12);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (7, 30, 'ca', 13,  18);
insert into Séjour (idSéjour, idVoyageur, codeLogement, début, fin)
     values (8, 20, 'ca', 21,  22);

/*  Table Activité  */

insert into Activité (codeLogement, codeActivité, description)
   values ('pi', 'Voile', 'Pratique du dériveur et du catamaran');
insert into Activité (codeLogement, codeActivité, description)
    values ('pi', 'Plongée', 'Baptèmes et préparation des brevets');
insert into Activité (codeLogement, codeActivité, description)
    values ('ca', 'Randonnée', 'Sorties d’une journée en groupe');
insert into Activité (codeLogement, codeActivité, description)
    values ('ge', 'Ski', 'Sur piste uniquement');
insert into Activité (codeLogement, codeActivité, description)
    values ('ge', 'Piscine', 'Nage loisir non encadrée');


