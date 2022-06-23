import pymysql
import pymysql.cursors

connexion = pymysql.connect('localhost', 'athénaïs', 
						 'motdepasse', 'Messagerie',
						 cursorclass=pymysql.cursors.DictCursor)

curseur = connexion.cursor()
curseur.execute("select * from Contact")

for contact in curseur.fetchall():
	print(contact['prénom'], contact['nom'])
