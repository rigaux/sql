from django.shortcuts import render
from .models import Contact, Message

def contacts(request):
	contacts = Contact.objects.all()
	context = {'les_contacts': contacts}
	
	return render(request, 'messagerie/contacts.html', context)

def messages(request):
	messages = Message.objects.all()
	context = {'les_messages': messages}
	
	return render(request, 'messagerie/messages.html', context)