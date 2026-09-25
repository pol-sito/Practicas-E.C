

// Matriu 4x4 tipus short on guardem els números del joc.
// Accés a les matrius en C: utilitzem fila (0..[DimMatrix-1]) i 
// columna(0..[DimMatrix-1]) (m[fila][columna]).
// Accés a les matrius en assemblador: S'hi accedeix com si fos un vector 
// on indexMat (0..[DimMatrix*DimMatrix-1]). 
// indexMat=((fila*DimMatrix)+(columna))*2 (2 perquè la matriu és de tipus short).
// WORD[m+pos] (WORD perquè és de tipus short) 
extern "C" short m[4][4] = {{2,    2,     2,     2},
						{    0,    8,     8,     0},
						{    0,    0,     4,     4},
						{    4,    4,     2,     2} };

// Matriu aauxiliar
//extern "C" short mAux[4][4] = { {2,    8,    16,    2},
//							{    4,   16,     64,     8},
//							{    32,    8,     2,     64},
//							{    2,    4,     16,     64} };
extern "C" short mAux[4][4] = { {2,    4,     8,    16},
							{    32,   64, 1024,    256},
							{    2,    4,     8,   1024},
							{    4,    8,     0,    16} };

extern "C" char carac;			//Variable on s'emmagatzema el caràcter a imprimir per pantalla
extern "C" char tecla;			//Variable on s'emmagatzema el caràcter llegit del teclat
extern "C" int pos;				//Índex per a accedir a la matriu mBoard (resultat de calcIndex)

extern "C" int row;				//Valor numèric de a fila on estem realitzant la jugada (0-3)
extern "C" int col;				//Valor numèric de a columna on estem realitzant la jugada (0-3)

extern "C" int colCursor;		//Valor numèric de a columna on volem posar el cursor (0-3)
extern "C" int rowCursor;		//Valor numèric de a fila on volem posar el cursor (0-3)


extern "C" int rowScreen;		//Fila on volem posicionar el cursor a la pantalla
extern "C" int colScreen;		//Columna on volem posicionar el cursor a la pantalla

extern "C" int rowScreenIni;	//Fila de la primera posició de la matriu a la pantalla
extern "C" int colScreenIni;	//Columna de la primera posició de la matriu a la pantalla


extern "C" int rowInsert;		//Fila on farem la següent inserció d'un 2 per proseguir amb la partida

extern "C" int number;			//nombre que estem tractant per imprimir a pantalla
extern "C" int score;			//puntúació total del joc
extern "C" char state;			//Indica l'estat del joc (1-5)

