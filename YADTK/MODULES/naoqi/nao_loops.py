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

## Alternative = programmation par évènements
## http://doc.aldebaran.com/2-1/dev/python/reacting_to_events.html#python-reacting-to-events

##############################################################################
## Some loops

def behaviourLoop():
    while True:
        time.sleep(1)
        # Describe the behaviour here

def naoInitiative():
    global input_queue # All inputs must go through the queue
    
    # Nao initiative simulation after 5 seconds
    time.sleep(5)
    input_queue.put("right_left_question")

multiprocessing.Process(target=behaviourLoop).start()
multiprocessing.Process(target=naoInitiative).start()

##############################################################################
## Perception boolean functions

def check_sensor1(): # Must return True or False
    return False

def check_sensor2(): # Must return True or False
    return False

def check_sensor3(): # Must return True or False
    return False

##############################################################################
## The perception loop

def perceptionLoop():
    global input_queue # All inputs must go through the queue
    
    flag1 = False # Flag initialisation for sensor 1
    flag2 = False # Flag initialisation for sensor 2
    flag3 = False # Flag initialisation for sensor 3
    
    while True:
        time.sleep(0.5)        
        
        if not flag1 and check_sensor1(): flag1 = True; input_queue.put("rule_trigger_from_sensor_1")
        if not flag2 and check_sensor2(): flag2 = True; input_queue.put("rule_trigger_from_sensor_2")
        if not flag3 and check_sensor3(): flag3 = True; input_queue.put("rule_trigger_from_sensor_3")
        
        if flag1 and not check_sensor1(): flag1 = False
        if flag2 and not check_sensor2(): flag2 = False
        if flag3 and not check_sensor3(): flag3 = False

multiprocessing.Process(target=perceptionLoop).start()
