/*
* Auteur : Philippe Rigaux (philippe.rigaux@cnam.fr)
* Objet : création du schéma de la base 'Messagerie'
* 
* create database Messagerie;
* grant select on Messagerie.* to lecteur identified by 'mdpLecteur'
* grant all on Messagerie.* to athénaïs identified by 'motdepasse'
* grant all on Messagerie.* to philippe identified by 'motdepasse'
*/

drop table Message;
drop table Contact;
drop table Envoi;

create table Contact (idContact integer not null,
                      nom varchar(30) not null,
                      prénom varchar(30)  not null,
                      email varchar(30) not null,
                      primary key (idContact),
                      unique (email)
                   );  

                   
create table Message (
  idMessage  integer not null,
  contenu text not null,
  dateEnvoi   datetime,
  idEmetteur int not null,
  idPrédecesseur int,
  primary key (idMessage),
  foreign key (idEmetteur) 
        references Contact(idContact),
  foreign key (idPrédecesseur) 
         references Message(idMessage)
);

create table Envoi ( 
    idMessage  integer not null,
    idDestinataire  integer not null,
    primary key (idMessage, idDestinataire),
    foreign key (idMessage) 
              references Message(idMessage),
    foreign key (idDestinataire) 
              references Contact(idContact)
);
               