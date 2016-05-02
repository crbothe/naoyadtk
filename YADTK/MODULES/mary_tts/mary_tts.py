# coding: utf-8
##############################################################################
# This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
# Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software. You can use,
# modify and/or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA (http://www.cecill.info).
#
# As a counterpart to the access to the source code and rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty and the software's author, the holder of the
# economic rights, and the successive licensors have only limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading, using, modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean that it is complicated to manipulate, and that also
# therefore means that it is reserved for developers and experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and, more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
##############################################################################

# This free software is registered at the Agence de Protection des Programmes.
# For further information or commercial purpose, please contact the author.

# TODO http://mary.dfki.de/

# http://www.web3.lu/marytts-text-speech/
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
	cprint(resulted, "green")
	cprint(outThis, "green")
	#print 'if',first, 'is related to', second, 'then', third, 'probably related to',  resulted


class MaryOutput(OutputPlugin):
    
    def output_method(self, data):
        # For example the YADE action is <speak text="Ok man, I can do that [nao:walk]"/>
        # Suppressing the command tags in the text
        tosay = re.sub(r"\[[^\]]*\]","", data)
	cprint(tosay, "green")
        result = re.search("\[nao:([A-Za-z_]*)\]", data)

        if result:
            # Executing the action if there is one
            command = result.group(1)

            if command == "getRelation":    getRelation()    #13

MaryOutput()
