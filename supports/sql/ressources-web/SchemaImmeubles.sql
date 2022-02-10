/*
* Schéma de la base "Immeubles" - Cf. http://sql.bdpedia.fr
* 
* create database Immeubles;
* grant select on Immeubles.* to lecteur identified by 'mdpLecteur'
*/

create table Immeuble (id integer not null,
                       nom varchar(100) not null,
                       adresse varchar(255) not null,
                       primary key (id)            
);

create table Appart (id integer not null,
                     no integer not null,
                     surface integer not null,
                     niveau      integer not null,
                     idImmeuble integer not null,
                     primary key (id), 
                     
                     foreign key (idImmeuble) references Immeuble(id), 
                     unique (idImmeuble, no)
);

create table Personne (id integer not null AUTO_INCREMENT,
                   prénom varchar(50),
                   nom varchar(50) not null,
                   profession varchar(50),
                   idAppart integer,
                   primary key (id),
                   foreign key (idAppart) references Appart(id)
);

create table Propriétaire (idPersonne integer not null,
                      idAppart integer not null,
                       quotePart integer not null,
                      primary key (idPersonne, idAppart),
                      foreign key (idPersonne) references Personne(id),
                      foreign key (idAppart) references Appart(id)
) ;
