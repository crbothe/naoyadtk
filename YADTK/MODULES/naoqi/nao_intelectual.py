import re



def getanology(second, first, third):
	import word2vec
	# Import the word2vec binary file: dataset
	model = word2vec.load('/export/home/sysadmin/text8.bin')

	# We can do simple queries to retreive words related to "word"

	indexes, metrics = model.analogy(pos=[first, third], neg=[second], n=10)

	#model.vocab[indexes]
	related_word = model.vocab[indexes[0]]

	return related_word

def getRelation():
	global input
	#cprint("==> Test okay.", "green")
	import nltk

	sentence = input
	#sentence = 'relation tell me, if man is to king then woman'
	tokens = nltk.word_tokenize(sentence)

	ifIndex   = tokens.index('if')
	toIndex   = tokens.index('to')
	thenIndex = tokens.index('then')

	first  = tokens[ifIndex + 1] 
	second = tokens[toIndex + 1]
	third  = tokens[thenIndex + 1]
	
	resulted = getanology(first, second, third)


	outThis = str('if '+first +' is related to '+ second+ ', then '+ third+ ' probably related to '+  resulted)
	
#	execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_commands.py")
	talk(outThis)

	cprint(resulted, "green")
	cprint(outThis, "green")
	#print 'if',first, 'is related to', second, 'then', third, 'probably related to',  resulted

