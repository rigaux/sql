/*
* Auteur : Philippe Rigaux (philippe.rigaux@cnam.fr)
* Objet : création du schéma de la base 'Voyageurs'
* 
* create database Voyageurs;
* grant select on Voyageurs.* to lecteur identified by 'mdpLecteur'
*/

drop table Séjour;
drop table Activité;
drop table Voyageur;
drop table Logement;


create table Voyageur (idVoyageur integer not null,
                      nom varchar(30) not null,
                      prénom varchar(30)  not null,
                      ville varchar(30) not null,
                      région varchar(30) not null,
                      primary key (idVoyageur)
                   );  

                   
create table Logement (code varchar(4) not null,
                       nom varchar(50) not null,
                       capacité   integer not null,
                       type varchar(10) default 'Hôtel',
	                    lieu varchar(30) not null,
	                    primary key (code)
                    );

                    
create table Séjour  (idSéjour integer not null,
                      idVoyageur integer not null,
                      codeLogement varchar (4) not null,
                      début integer not null,
                      fin integer not null,
                      primary key (idSéjour),
                      foreign key (idVoyageur) references Voyageur(idVoyageur),
                      foreign key (codeLogement) references Logement(code)
                      );


create table Activité (codeLogement varchar (4) not null,
                       codeActivité      varchar(30) not null,
                       description       varchar(255) not null,
                       primary key (codeLogement, codeActivité),
                       foreign key (codeLogement) references Logement(code)
                         on delete cascade
                      );
