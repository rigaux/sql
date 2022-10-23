import pymysql
import pymysql.cursors
from datetime import  datetime

connexion = pymysql.connect('localhost', 'athénaïs', 
						 'motdepasse', 'Messagerie',
						 cursorclass=pymysql.cursors.DictCursor)


class Contact:
	 def __init__(self,id,prenom,nom,email):
                self.id=id
                self.prenom=prenom
                self.nom=nom
                self.email=email
    
curseur = connexion.cursor()
curseur.execute("select * from Contact")

for cdict in curseur.fetchall():
	
	cobj = Contact(cdict["idContact"], cdict["prénom"], 
				cdict["nom"], cdict["email"])
	
	print(cobj.prenom, cobj.nom)


class Message:
	id = 0
	# Emetteur: un objet 'Contact'
	emetteur = Contact(0, "", "", "")
	contenu = ""
	dateEnvoi = datetime.now()
	# Prédecesseur: peut ne pas exister
	predecesseur = None
	# Liste des destinataires = des objets 'Contacts'
	destinataires = []

	# La méthode d'envoi de message
	def envoi(self):
		self.dateEnvoi 
		for dest in self.destinaires:
			mail(dest.email, self.contenu)