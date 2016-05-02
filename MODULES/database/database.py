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

import sqlite3

##############################################################################
## Checking global variables

try: DATABASE_BASE 
except: ERROR("ERROR: You must specify the name of the sqlite base")

print "   DATABASE_BASE = %s" % DATABASE_BASE

##############################################################################
## Loading the database

db_filename = "%s/MODULES/database/%s.db" % (YADTK_FOLDER, DATABASE_BASE)

if not os.path.isfile(db_filename):
    ERROR("ERROR: Can't open %s" % db_filename)

##############################################################################
## Database plugin

class DatabaseModule(TaskPlugin):
    
    def output_method(self, queue, data):
        
        match = re.search("request:.*", data)
        if not match: return
        
        base = sqlite3.connect(db_filename)
        
        ## Requête sur la ville seulement
        
        match = re.search("ville:([^:]*)\]", data)
        if match:
            ville = match.group(1)
            results = base.execute("SELECT Nom, Ville, Adresse FROM Hotels WHERE Ville = '%s'" % ville)
        
        ## Requête sur la ville et sur le nombre d'étoiles
        
        match = re.search("ville:([^:]*):etoiles:([^:]*)\]", data)
        if match:
            ville = match.group(1)
            stars = match.group(2)
            results = base.execute("SELECT Nom, Ville, Adresse FROM Hotels WHERE Ville = '%s' AND Etoiles = '%s'" % (ville, stars))
        
        ## Retour du résultat
        
        result = "[result"
        found = False
        for row in results:
            result += ":%s, %s" % (row[0],row[2])
            found = True
    
        if found:
            result += "]"
            queue.put(result.encode("utf-8"))
        else: queue.put("[noresult]")
        
        base.close()

##############################################################################

DatabaseModule()
