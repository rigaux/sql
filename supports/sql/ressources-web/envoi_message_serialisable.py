import pymysql
import pymysql.cursors
from datetime import datetime

connexion = pymysql.connect('localhost', 'athénaïs', 
						 'motdepasse', 'Messagerie',
						 cursorclass=pymysql.cursors.DictCursor)


# Tous les messages non envoyés
messages = connexion.cursor()

messages.execute("SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE")
#messages.execute("select * from Message where dateEnvoi is null")

connexion.begin()

messages.execute("select * from Message")
for message in messages.fetchall():
	# Marquage du message

	maj = connexion.cursor()
	maj.execute ("Update Message set dateEnvoi='2018-12-31' "
				+ "where idMessage=%s", message['idMessage'])

	print ("Envoi du message ...", message['contenu'])
	envois = connexion.cursor()
	envois.execute("select * from Envoi as e, Contact as c "
                   +" where e.idDestinataire=c.idContact "
                   + "and  e.idMessage = %s", message['idMessage'])
	for envoi in envois.fetchall():
		print ("\tà ", envoi['prénom'])
	input('Appuyez sur une touche ...')

connexion.commit()

