/**
* Implementació C de la pràctica.
* Des d'aquest codi es fan les crides a les subrutines d'assemblador que heu de completar.
* ATENCIÓ: Aquest codi és nomès de consulta.
* AQUEST CODI NO ES POT MODIFICAR I NO S'HA DE LLIURAR.
**/
#include <stdio.h>
#include <conio.h>

#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include "globals.h"

extern "C" {
	// Difinició de Subrutines en ASM
	int  gotoxy_C(int row_num, int col_num);	//
	void printChar_C(char c);
	char getch_C();
	void printMessage_C();

	int  clearscreen_C();
	int  printMenu_C();
	int  printBoard_C(int tries);


	/**
	 * Definició de les subrutines d'assemblador que es criden des de C.
	 */
	void showCursor();
	void showNumber();
	void copyMatrix();
	void showMatrix();
	void insertTile();
	void shiftNumbers();
	void addPairs();
	void rotateMatrix();
	void onePlay();
	void playGame();
}

/**
 * Constants.
 **/
#define DIMMATRIX 4

 /**
  * Definición de variables globales
  */

  /**
   * Definició de variables globals
   */

char carac;
char tecla;
int	 pos;
int  row;			//Fila de la matriu.
int  col;			//Columna de la matriu
int  rowCursor;		//Fila per a posicionar el cursor a la pantalla.
int  colCursor;		//Columna per a posicionar el cursor a la pantalla.
int  rowScreen;		//Fila per a posicionar el cursor a la pantalla.
int  colScreen;		//Columna per a posicionar el cursor a la pantalla.
int  rowScreenIni;	//Fila de la primera posició de la matriu a la pantalla
int  colScreenIni;	//Columna de la primera posició de la matriu a la pantalla
int  rowInsert;		//Fila en la que volem inserir fitxa
int  number;		//Numero que volem mostrar.
int  score;			// Punts acumulats al marcador.                    
int  opc;			//Opció del menú seleccionada
char state = '1';		// '0': Sortir, hem premut la tecla 'ESC' per a sortir.
						// '1': Continuem jugant.
						// '2': Continuem jugant però s'han fet canvis a la matriu.
						// '3': Hem fet un 2048
						// '4': No hem pogut inserir fitxa matriu plena
						// '5': No es pot moure. Patida perduda.



//Mostrar un caràcter
//Quan cridem aquesta funció des d'assemblador el paràmetre s'ha de passar a traves de la pila.
void printChar_C(char c) {
	putchar(c);
}

//Esborrar la pantalla
int clearscreen_C() {
	system("CLS");
	return 0;
}

int migotoxy(int x, int y) { //USHORT x,USHORT y) {
	COORD cp = { y,x };
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cp);
	return 0;
}

//Situar el cursor en una fila i columna de la pantalla
//Quan cridem aquesta funció des d'assemblador els paràmetres (row_num) i (col_num) s'ha de passar a través de la pila
int gotoxy_C(int row_num, int col_num) {
	migotoxy(row_num, col_num);
	return 0;
}


//Imprimir el menú del joc
int printMenu_C() {

	clearscreen_C();
	gotoxy_C(1, 1);
	printf("                                    \n");
	printf("           Developed by:            \n");
	printf("                                    \n");
	printf(" __________________________________ \n");
	printf("|                                  |\n");
	printf("|            MAIN MENU             |\n");
	printf("|__________________________________|\n");
	printf("|                                  |\n");
	printf("|         1. ShowCursor            |\n");
	printf("|         2. ShowNumber            |\n");
	printf("|         3. ShowMatrix            |\n");
	printf("|         4. CopyMatrix            |\n");
	printf("|         5. ShiftNumbers          |\n");
	printf("|         6. AddPairs              |\n");
	printf("|         0. Exit                  |\n");
	printf("|                                  |\n");
	printf("|                                  |\n");
	printf("|                                  |\n");
	printf("|__________________________________|\n");
	printf("|                                  |\n");
	printf("|            OPTION:               |\n");
	printf("|__________________________________|\n");
	return 0;
}


//Llegir una tecla sense espera i sense mostrar-la per pantalla
char getch_C() {
	DWORD mode, old_mode, cc;
	HANDLE h = GetStdHandle(STD_INPUT_HANDLE);
	if (h == NULL) {
		return 0; // console not found
	}
	GetConsoleMode(h, &old_mode);
	mode = old_mode;
	SetConsoleMode(h, mode & ~(ENABLE_ECHO_INPUT | ENABLE_LINE_INPUT));
	TCHAR c = 0;
	ReadConsole(h, &c, 1, &cc, NULL);
	SetConsoleMode(h, old_mode);

	return c;
}


/**
 * Mostrar el tauler de joc a la pantalla. Les li­nies del tauler.
 * Aquesta funcio es crida des de C i des d'assemblador,
 * i no hi ha definida una subrutina d'assemblador equivalent.
 * No hi ha pas de parametres.
 */
void printBoard_C() {
	int i;

	clearscreen_C();
	gotoxy_C(1, 1);                                                  //ScreenRows   
	printf(" _________________________________________________  \n"); //01
	printf("|                                                  |\n"); //02
	printf("|                  2048 PUZZLE  v1.0               |\n"); //03
	printf("|                                                  |\n"); //04
	printf("|     Join the numbers and get to the 2048 tile!   |\n"); //05
	printf("|__________________________________________________|\n"); //06
	printf("|                                                  |\n"); //07
	printf("|            0        1        2       3           |\n"); //08
	printf("|        +--------+--------+--------+--------+     |\n"); //09
	printf("|      0 |        |        |        |        |     |\n"); //10
	printf("|        +--------+--------+--------+--------+     |\n"); //11
	printf("|      1 |        |        |        |        |     |\n"); //12
	printf("|        +--------+--------+--------+--------+-    |\n"); //13
	printf("|      2 |        |        |        |        |     |\n"); //14
	printf("|        +--------+--------+--------+--------+     |\n"); //15
	printf("|      3 |        |        |        |        |     |\n"); //16
	printf("|        +--------+--------+--------+--------+     |\n"); //17
	printf("|          Score:   ______                         |\n"); //18
	printf("|__________________________________________________|\n"); //19
	printf("|                                                  |\n"); //20
	printf("|  (q)Quit  (i)Up   (j)Left  (k)Down  (l)Right     |\n"); //21
	printf("|                                                  |\n"); //22
	printf("|                                                  |\n"); //23
	printf("|                                                  |\n"); //24
	printf("|__________________________________________________|\n"); //25

}

void printMessage_C() {
	switch (state) {
	case'0':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|             s'ha sortit del joc                  |\n"); //21
		break;
	case'1':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|               Continua jugant                    |\n"); //21
		break;
	case'2':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|      Continua jugant, s'han produit canvis       |\n"); //21
		break;
	case'3':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|          Has fet 2048, HAS GUANYAT!!!!!          |\n"); //21
		break;
	case'4':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|            Atencio, el tauler esta ple!          |\n"); //21
		break;
	case'5':
		gotoxy_C(23, 0);			//Situar el cursor per la selecció de menú inicial
		printf("|           Tauler bloquejat, has perdut!          |\n"); //21
	}
}
int main(void) {
	opc = 1;
	rowInsert = 0;
	while (opc != '0') {
		printMenu_C();				//Mostrar menú
		gotoxy_C(21, 20);			//Situar el cursor per la selecció de menú inicial
		opc = getch_C();			//Llegir una opció
		switch (opc) {
			//Opció del Menú --> 1. showCursor   ,posiciona el cursor a l posició 2,1 del tauler
		case '1':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();			//Mostrar el tauler
			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");

			row = 2;				//Fila inicial on volem que aparegui el cursor
			col = 1;				//Columna inicial on volem que aparegui el cursor
			showCursor();			//Posicionar el cursor a la fila i columna indicada

			getch_C();				//Esperar que es premi una tecla
			break;

			//Opció del Menú --> 2. showNumber   ,Mostrar Número
		case '2':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();   		//Mostrar el tauler.

			row = 2;				//Fila inicial on volem que aparegui el cursor
			col = 1;				//Columna inicial on volem que aparegui el cursor
			showCursor();			//Posicionar el cursor a la fila i columna indicada
			number = 1000;
			showNumber();			//Presenta el número de jugador a la casella Player

			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();				//Espera pulsació
			break;

			//Opció del Menú --> 3. ShowMatrix, Mostrar el contingut de la matriu.
		case '3':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();   		//Mostrar el tauler.

			showMatrix();			//

			getch_C();				//Captura un caracter per fer una espera i poder veure el moviment únic del cursor	
			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();				//Espera pulsació
			break;
			//Opció del Menú --> 4. CopyMatrix   ,Copiar matriu mAux a m
		case '4':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();   		//Mostrar el tauler.

			copyMatrix();			//
			showMatrix();			//


			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();
			break;

			//Opció del Menú --> 5. ShiftNumbers   ,Desplaça números a la dreta
		case '5':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();   		//Mostrar el tauler.

			showMatrix();			//
			getch_C();
			shiftNumbers();			//
			showMatrix();			//

			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();
			break;
			//Opció del Menú --> 6. AddPairs   ,Fer parelles
		case '6':
			clearscreen_C();  		//Esborra la pantalla
			printBoard_C();   		//Mostrar el tauler.

			showMatrix();			//
			getch_C();				//
			addPairs();				//
			showMatrix();			//

			gotoxy_C(24, 19);		//Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();
			break;
			//Opció del Menú --> 7. RotateMatrix   ,Rotar matriu en sentit del rellotge

		}
	}
	gotoxy_C(19, 1);						//Situar el cursor a la fila 19
	return 0;
}