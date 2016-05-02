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

def naoInitiative():
    global input_queue
    # Nao initiative simulation after 10 seconds
    time.sleep(10)
    input_queue.put("right_left_question")

multiprocessing.Process(target=naoInitiative).start()

##############################################################################

def print_green(text): cprint(text, "green")

def __output__(text):

    tosay = re.sub(r"\[[^\]]*\]","", text)
    if tosay: print_green(">>> Nao is saying: %s" % tosay)
    
    iter = re.finditer("\[nao:[A-Za-z_]*\]", text)
    for match in iter:
        command = match.group(0)
        
        if   command == "[nao:standup]":      print_green(">>> Nao is standing up...")
        elif command == "[nao:sitdown]":      print_green(">>> Nao is sitting down...")
        elif command == "[nao:turnLeft]":     print_green(">>> Nao is turning left...")
        elif command == "[nao:turnRight]":    print_green(">>> Nao is turning right...")
        elif command == "[nao:walkForward]":  print_green(">>> Nao is walking forward...")
        elif command == "[nao:walkBackward]": print_green(">>> Nao is walking backward...")
        elif command == "[nao:stop]":         print_green(">>> Nao is stopping...")

##############################################################################
