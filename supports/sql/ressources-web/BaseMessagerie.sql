/*
* Auteur : Philippe Rigaux (philippe.rigaux@cnam.fr)
* Objet : création d'une mini base 'Messagerie'
*/

insert into Contact (idContact, prénom, nom,  email)
  values (1, 'Serge', 'A.', 'serge.a@inria.fr');
insert into Contact (idContact, prénom, nom,  email)
  values (2, 'Cécile', 'D.', 'cecile.d@cnrs.fr');
insert into Contact (idContact, prénom, nom,  email)
  values (3, 'Sophie', 'G.', 'sophie.g@typho.fr');
insert into Contact (idContact, prénom, nom,  email)
  values (4, 'Philippe', 'R.', 'philippe.r@cnam.fr');

insert into Message (idMessage, contenu, idEmetteur)
values (1, 'Hello Serge', 4);
insert into Message (idMessage, contenu, idEmetteur, idPrédecesseur)
values (2, 'Coucou Philippe', 1, 1);
insert into Message (idMessage, contenu, idEmetteur, idPrédecesseur)
values (3, 'Philippe a dit ...', 1, 1);
insert into Message (idMessage, contenu, idEmetteur, idPrédecesseur)
values (4, 'Serge a dit ...', 4, 2);

insert into Message (idMessage, contenu, idEmetteur, idPrédecesseur)
values (5, 'Message nul', 4, 2);


insert into Envoi (idMessage, idDestinataire) values (1, 1);
insert into Envoi (idMessage, idDestinataire) values (2, 4);
insert into Envoi (idMessage, idDestinataire) values (3, 3);
insert into Envoi (idMessage, idDestinataire) values (4, 2);
insert into Envoi (idMessage, idDestinataire) values (4, 3);
