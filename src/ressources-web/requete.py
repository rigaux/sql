import pymysql

connexion = pymysql.connect('localhost', 'lecteur', 
						 'mdpLecteur', 'Messagerie')

cur = connexion.cursor()
cur.execute("SELECT prénom, nom from Contact")

contact = cur.fetchone()
    
print("Contact : " + contact[0] + ' ' + contact[1])

cur.execute("SELECT prénom, nom from Contact")

contacts = cur.fetchall()
for contact in contacts:
	print("{0} {1}".format(contact[0], contact[1]))
