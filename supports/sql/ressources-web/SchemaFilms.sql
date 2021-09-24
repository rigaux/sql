/*
   Commandes de création de la base Films,  testé avec MySQL et PostgreSQL.
   Pour Oracle, il suffit de remplacer le type TEXT par le type LONG dans 
   la table Film.
   Philippe Rigaux, 2004-2019
*/

/* Destruction éventuelle des tables existantes 

DROP TABLE  Notation;  
DROP TABLE  Role;  
DROP TABLE  Film;  
DROP TABLE Artiste;  
DROP TABLE  Internaute;  
DROP TABLE  Pays;  
DROP TABLE  Genre;  */

/* Creation des tables                           */   

 
create table Pays (code    varchar(4) NOT NULL,
                   nom  varchar (30) DEFAULT 'Inconnu' NOT NULL,
                   langue varchar (30) NOT NULL,
                   primary key (code));

create table Internaute (email varchar (40) NOT NULL, 
                         nom varchar (30) NOT NULL ,
                         prénom varchar (30) NOT NULL,
                         codePays varchar (4),
                         foreign key (codePays) references Pays(code),
                         primary key (email));

create table Artiste  (idArtiste integer NOT NULL,
                       nom varchar (30) NOT NULL,
                       prénom varchar (30) NOT NULL,
                       annéeNaiss integer,
                       primary key (idArtiste),
                       UNIQUE (nom, prénom));

create table Film  (idFilm integer NOT NULL,
                    titre    varchar (80) NOT NULL,
                    année    integer NOT NULL,
                    idRéalisateur    integer,
                    genre varchar (20) NOT NULL,
                    /* Remplacer TEXT par LONG pour ORACLE */
                    résumé      TEXT,
                    codePays    varchar (4),
                    primary key (idFilm),
                    foreign key (idRéalisateur) references Artiste(idArtiste),
                    foreign key (codePays) references Pays(code));

create table Notation (idFilm integer NOT NULL,
                       email  varchar (40) NOT NULL,
                       note  integer NOT NULL,
                       primary key (idFilm, email));

create table Rôle (idFilm  integer NOT NULL,
                   idActeur integer NOT NULL,
                   nomRôle  varchar(255), 
                   primary key (idActeur,idFilm),
                   foreign key (idFilm) references Film(idFilm),
                   foreign key (idActeur) references Artiste(idArtiste));
