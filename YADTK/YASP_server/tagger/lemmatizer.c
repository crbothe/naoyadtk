// #############################################################################
// This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
// Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
//
// This software is governed by the CeCILL license under French law and
// abiding by the rules of distribution of free software. You can use,
// modify and/or redistribute the software under the terms of the CeCILL
// license as circulated by CEA, CNRS and INRIA (http://www.cecill.info).
//
// As a counterpart to the access to the source code and rights to copy,
// modify and redistribute granted by the license, users are provided only
// with a limited warranty and the software's author, the holder of the
// economic rights, and the successive licensors have only limited
// liability.
//
// In this respect, the user's attention is drawn to the risks associated
// with loading, using, modifying and/or developing or reproducing the
// software by the user in light of its specific status of free software,
// that may mean that it is complicated to manipulate, and that also
// therefore means that it is reserved for developers and experienced
// professionals having in-depth computer knowledge. Users are therefore
// encouraged to load and test the software's suitability as regards their
// requirements in conditions enabling the security of their systems and/or
// data to be ensured and, more generally, to use and operate it in the
// same conditions as regards security.
//
// The fact that you are presently reading this means that you have had
// knowledge of the CeCILL license and that you accept its terms.
// #############################################################################

// This free software is registered at the Agence de Protection des Programmes.
// For further information or commercial purpose, please contact the author.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void openLexicon(char *name, FILE **fp)
{
	char fichier[256];
	sprintf(fichier, "%s/%s", getenv("LANG"), name);
	
	*fp = fopen(fichier, "r");
	if (!*fp)
	{
		fprintf(stderr, "ERROR Lemmatizer: Can't open the file %s\n", fichier);
		exit(1);
	}
}

void minuscule(char s[])
{
	int i;
	for (i = 0; s[i] != '\0'; i++)
		if (s[i] >= 'A' && s[i] <= 'Z')
			s[i]= s[i] - 'A' + 'a';
}

int validIdentifierStart(char ch)
{
	return (ch >= 'a' && ch <= 'z');
}

int estUnNombre(char ch)
{
	return (ch >= '0' && ch <= '9');
}

int search(char *fichier, char *graphie, int index)
{
	FILE *ptrfile;
	char ch1[50], ch2[50], ch3[50], reste[50];
	int find = 0;
	
	openLexicon(fichier, &ptrfile);
	while (!feof(ptrfile))
	{
		fscanf(ptrfile, "%[^;];%[^;];%[^\n]\n", ch1, ch2, ch3);
		//fprintf(stderr, "[%s] ", ch1);
		if (!strcmp(graphie, ch1))
		{
			printf("(lexeme (pos %d) (fin %d) (graphie \"%s\") (canonique \"%s\") (categorie %s))\n", index, index+1, graphie, ch3, ch2);
			find = 1;
		}
	}
	fclose(ptrfile);
	return find;
}

void lemmatiser(char *graphie, int index)
{
	int find = 0;
	char fichier[256] = "";
	
	fprintf(stderr, "[%s] ", graphie);
	
	// Identification du nom du fichier
	if (validIdentifierStart(graphie[0])) sprintf(fichier, "%c.txt", graphie[0]);
	else if ((unsigned char) graphie[0] == 195 && (unsigned char) graphie[1] == 160) strcpy(fichier, "a.txt");
	else if ((unsigned char) graphie[0] == 195 && (unsigned char) graphie[1] == 169) strcpy(fichier, "e.txt");
	
	// Recherche du grapheme et generation des faits CLIPS
	if ((strlen(fichier) > 0) && search(fichier, graphie, index)) find = 1;
	if (search("user.txt", graphie, index)) find = 1;
	
	// Est-ce un nombre ?
	if (estUnNombre(graphie[0]))
	{
		printf("(lexeme (pos %d) (fin %d) (graphie \"%s\") (canonique \"%s\") (categorie NUM))\n", index, index+1, graphie, graphie);
		find = 1;
	}
	
	if (!find)
	{
		fprintf(stderr, "NOT FOUND ");
		printf("(lexeme (pos %d) (fin %d) (graphie \"%s\"))\n", index, index+1, graphie);
	}
}

int main(void)
{	
	// Recuperation de la chaine dans stdin
	
	char chaine[1000];
	fgets(chaine, sizeof(chaine), stdin);
	
	int i = strlen(chaine) - 1;
	if (chaine[i] == '\n') chaine[i] = '\0'; // Remove newline if present
	
	// Tokenisation et lemmatisation de la chaine de caracteres
	
	char delims[] = " ";
	char *token;
	int index = 1;
	
	token = strtok(chaine, delims);
	while (token != NULL)
	{
		minuscule(token);
		lemmatiser(token, index);
		token = strtok(NULL, delims);
		index++;
	}
	fprintf(stderr, "\n");
	return 1;
}

