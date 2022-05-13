from django.db import models

class Contact(models.Model):
	email = models.CharField(max_length=200)
	prenom = models.CharField(max_length=200)
	nom = models.CharField(max_length=200)
	
	def __str__(self):
		return self.prenom + ' ' + self.nom

	class Meta:
		db_table = 'Contact'

class Message(models.Model):
	emetteur = models.ForeignKey(Contact, on_delete=models.CASCADE, related_name='messages_emis')
	contenu = models.TextField()
	date_envoi = models.DateTimeField()
	predecesseur = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='successeurs')

	class Meta:
		db_table = 'Message'
		
	def __str__(self):
		return self.contenu

class Envoi(models.Model):
	destinataire = models.ForeignKey(Contact, on_delete=models.CASCADE,)
	message = models.ForeignKey(Message, on_delete=models.CASCADE, related_name='destinataires')
	
	class Meta:
		db_table = 'Envoi'
		
	def __str__(self): 
		return self.destinataire
