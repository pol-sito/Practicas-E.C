.586
.MODEL FLAT, C

;************************************ SOLUCIÓ BASE *****************************************************

; Funcions definides en C
printChar_C PROTO C, value:SDWORD
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C
printMessage_C PROTO C


;Subrutines cridades des de C
public C showCursor, showNumber, showMatrix, copyMatrix, shiftNumbers, addPairs

                         
;Variables utilitzades - declarades en C
extern C m:WORD, mAux:WORD
extern C carac: BYTE, tecla: BYTE
extern C row: DWORD, col: DWORD,rowCursor: DWORD, colCursor: DWORD, rowScreen: DWORD, colScreen: DWORD, rowInsert: DWORD
extern C number: DWORD, score:DWORD, state:DWORD, pos:DWORD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Descripció de les variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; m: Matriu de 4x4 shorts que conté l'estat del tauler de joc
; mAux: Matriu de 4x4 shorts auxiliar
; carac: Variable on s'emmagatzema el caràcter a imprimir per pantalla
; tecla: Variable on s'emmagatzema el caràcter llegit del teclat
; row: Valor numèric de a fila on estem realitzant la jugada (0-3)
; col: Valor numèric de a columna on estem realitzant la jugada (0-3)
; rowCursor: Valor numèric de a fila on volem posar el cursor (0-3)
; colCursor: Valor numèric de a columna on volem posar el cursor (0-3)
; rowScreen: Fila on volem posicionar el cursor a la pantalla
; colScreen: Columna on volem posicionar el cursor a la pantalla
; rowInsert: Fila on farem la següent inserció d'un 2 per proseguir amb la partida
; number: Nombre que estem tractant per imprimir a pantalla
; score: puntúació total del joc
; state: Indica l'estat del joc (1-5)
; pos: Índex per a accedir a la matriu mBoard (resultat de calcIndex)
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Les subrutines que heu de modificar per la pràctica nivell básic son:
; showCursor
; showNumber
; showMatrix
; copyMatrix
; shiftNumbers
; addPairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code  
   
;;Macros que guardan y recuperan de la pila los registros de proposito general de la arquitectura de 32 bits de Intel    
Push_all macro

push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
endm


Pop_all macro

pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
endm
   
   


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATENCIÓ: NO PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funció gotoxy_C.
;
;Ús de la funció:
;Per fer ús de la funció gotoxy cal guardar els valors de rowScreen,colScreen i després fer la crida
;ex:
;  mov [rowScreen],eax ;carrega el valor de eax a la variable "rowScrenn"
;  mov [colScreen],ebx ;carrega el valor de ebx a la variable "colScrenn"
;  call gotoxy ;posicona el cursor a les coodenadres (rowScrenn,colScrenn) de pantalla
;
; Variables utilitzades:
; rowScreen: Fila on volem posicionar el cursor a la pantalla.
; colScreen: Columna on volem posicionar el cursor a la pantalla.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funció gotoxy_C(int row_num, int col_num) des d'assemblador
   ; els paràmetres s'han de passar per la pila
     
   mov eax, [colScreen]
   push eax
   mov eax, [rowScreen]
   push eax
   call gotoxy_C
   pop eax
   pop eax
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
gotoxy endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATENCIÓ: NO PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un caràcter, guardat a la variable carac a la pantalla en la posició on està  el cursor,  
; cridant a la funció printChar_C.
;
;Ús de la funció:
; Per fer ús de la funció printch cal guardar el valor ASCII del caràcter que volem imprimer a pantalla
; a la variable "carac" i després fer la crida a la funció
;ex:
;  mov [carac],al ;guarda el valor del registre al (al conté un codi ASCII ) a la variable "carac"
;  call printch ;imprimeix el caracter "carac" a la pantalla a la posició actual del cursor
;
; Variables utilitzades:
; carac: Variable on s'emmagatzema el caràcter a imprimir per pantalla
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqué
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funció  printch_C(char c) des d'assemblador,
 
   xor eax,eax ;esborrar eax
   mov  al, [carac] ;pasar el valor de carac al registre de 8bits 'al'
   push eax
   call printChar_C ;Crida la funció de 'c' per imprimir el caracter a la posició del cursor
 
   pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
printch endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATENCIÓ: NO  PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un caràcter de teclat cridant a la funció getch_C i deixar-lo a la variable tecla.
;
;Ús de la funció:
; Per fer ús de la funció getch cal fer la crida a la funció i després es pot recuperar el valor de
; la tecla pulsada a la variable tecla
;ex:
;  call getch ;captura un caracter de teclat i el guarda a la variable "tecla"
;  mov al,[tecla] ;porta el valor de la variable tecla al registre al
;
; Variables utilitzades:
; tecla: Variable on s'emmagatzema el caràcter llegit del teclat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch proc
   push ebp
   mov  ebp, esp
   
   Push_all

   call getch_C
   mov [tecla],al
 
   Pop_all

   mov esp, ebp
   pop ebp
   ret
getch endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATENCIÓ;  A PARTIR D'AQUÍ HEU D'IMPLEMENTAR LES SUBRUTINES VOSLATRES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: showCursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A partir de la posició de la matriu row i col calcular la posició que ha d'ocupar aquesta
; component a la pantalla i posicionar el cursor a la posició corresponent posant els valors
; adequats a rowScreen i colScreen, i després cridant a la subrutina gotoxy.
;
; La posició a la pantalla (rowScreen, colScreen) que correspon al component (row, col) de la matriu
; ve determinada per les equacions:
;
; rowScreen = row*2 + 10
; colScreen = col*9 + 13
;
; HEU DE TENIR EN COMPTE EL TIPUS DE LES VARIABLES
; PER A DETERMINAR ELS REGISTRES QUE HEU DE FER SERVIR
;
; Variables utilitzades:  
; row: Valor numèric de a fila on estem realitzant la jugada (0-3)
; col: Valor numèric de a columna on estem realitzant la jugada (0-3)
; rowScreen: Fila on volem posicionar el cursor a la pantalla
; colScreen: Columna on volem posicionar el cursor a la pantalla
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor proc
    push ebp
mov  ebp, esp
;Inici codi d'alumne de la rutina
mov eax, [row];guardem la fila
imul eax, eax, 2
add eax, 10;acabem d'executar la formula rowScreen = row*2 + 10
mov [rowScreen], eax; guardem el resultat a rowScreen

mov eax, [col]
    imul eax, eax, 9
    add eax, 13;acabem d'executar la formula colScreen = col*9 + 13
    mov [colScreen], eax;guardem el resultat a colScreen

call gotoxy
;Fi codi d'alumne de la rutina
mov esp, ebp
pop ebp
ret

showCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: calcIndex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu.
; Calcula l’índex per a accedir a la matriu m en assemblador.
; m[row][col] en C, és [mBoard+pos] en assemblador.
;
; pos = (row*4 + col ) * TamanyDeDadaEnBytes.
;
; En el nostre cas TamanyDeDadaEnBytes serà 2 perquè m es una matriu de shorts
; i els bytes ocupen una posició de memòria.
;
; Variables utilitzades:
; row: Valor numèric de a fila on estem realitzant la jugada (0-3)
; col: Valor numèric de a columna on estem realitzant la jugada (0-3)
; pos: Índex per a accedir a la matriu m (resultat de calcIndex)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
push ebp
mov  ebp, esp
;Inici Codi de la pràctica
mov eax, [row];executem la formula pos = (row*4 + col ) * TamanyDeDadaEnBytes
mov ebx, 4
imul eax, ebx
add eax, [col]
mov ebx, 2
imul eax, ebx
mov [pos], eax;guarden el resultat a pos
  ;Fi Codi de la pràctica
mov esp, ebp
pop ebp
ret

calcIndex endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: showNumber
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar per pantalla, a la posició del tauler corresponent, un valor sencer emmagatzemat
; a la variable number de tipus int (DWORD) de 4 dígits (number <= 9999).
; Si (number) és més gran que 9999 canviarem el valor a 9999.
; Per a poder treure per pantalla un valor numèric cal convertir-lo al conjunt de caràcters ASCII
; que representen aquest valor.
;Per exemple;
; Per mostar el nombre 1234 cal imprimir per pantalla els caràcters '1', '2', '3' i '4',un darrera l'altre.
; Si el número no té 4 dígits, els dígits de més a l'esquerra no s'han de mostrar.
; Per exemple el nombre 23 ha de ser ' ', ' ', '2' i '3'
; Si el nombre que hem de represetar és 0, s'han d'imprimir 4 espais ' ', ' ', ' ' i ' '.
; Hi ha diverses formes de fer aquest procés, però totes necessiten dividions per 10 (o potències de 10).
; S'han de mostrar els dígits (caràcter ASCII) a partir de la posició corresponent a row i col.
; Per a posicionar el cursor cal cridar a la subrutina showCursor i per a mostrar els caràcters
; a la subrutina printch.
; Quan es crida a la subrutina printch es treu un caràcter per pantalla i el cursor avança de forma
; automàtica a la posició següent de forma que no cal tornar a posicionar el cursor
;
; Variables utilitzades:  
; number: Nombre que estem tractant per imprimir a pantalla
; row: Valor numèric de a fila on estem realitzant la jugada (0-3)
; col: Valor numèric de a columna on estem realitzant la jugada (0-3)
; rowScreen: Fila on volem posicionar el cursor a la pantalla
; colScreen: Columna on volem posicionar el cursor a la pantalla
; carac: Variable on s'emmagatzema el caràcter a imprimir per pantalla
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showNumber proc
    push ebp
    mov  ebp, esp
;Inici codi d'alumne de la rutina

push ebx
push esi
push edi

call showCursor;posicionem el cursor on toca mostrar el numero

mov esi, [number]
cmp esi, 9999 ;si el nombre es superior al maxim (9999)
jbe numeroValido
mov esi, 9999 ; ajustem valor a 9999
mov [number], esi

numeroValido:
;Si es 0, imprimir 4 espais
cmp esi, 0; comprobar si el numero es 0
jne empezarConversion; si es major que 0, comencem la conversió

mov al, ' '
mov [carac], al
mov ecx, 4;contador de 4 espais

imprimirEspacios:
call printch
dec ecx
jnz imprimirEspacios;si hem imprimint 4 espais, sortim
jmp fiShowNumber;un cop hem acabat de mostrar el numero, sortim

empezarConversion:
;Empezamos por los miles
mov ebx, 1000; divisor inicial = 1000
mov edi, 0; comprovar si es 0 o espai

bucleDigitos:
; Dividir el numero por el divisor (1000, 100, 10, 1)
    mov eax, esi; pasem el numero a eax
    mov edx, 0
    div ebx ;eax =cuociente, edx = residuo

;Guardar el residuo para el siguiente dígito
mov esi, edx

; Comprobar si hay que imprimir un espacio
    cmp eax, 0; comprovem si el dígito es 0
    jne imprimirDigito;si es major que 0, imprimim el dígito
    cmp edi, 0; si es zero, comprobamos si ya hemos impreso algún dígito
    jne imprimirDigito; si edi es 1 imprimos digito
    ;si es un 0 y no hemos imprimido ningún dígito, imprimimos un espacio
    mov al, ' '
    mov [carac], al
    jmp imprimirCaracter

imprimirDigito:
    ; Convertir el digito a ASCII
    mov edi, 1 ;a partir de ahora cada 0 no será un espacio
    add al, 48 ;pasar a ASCII sumando 48 = "0"
    mov [carac], al

imprimirCaracter:
    ; Imprimir el caracter
    call printch

    ; dividir el divisor entre 10 para pasar al siguiente digito.
    mov eax, ebx;carreguem el divisor a eax
    mov edx, 0
    mov ecx, 10
    div ecx; divideix el divisor entre 10
    mov ebx, eax; actualitzem el divisor per al següent dígit
    cmp ebx, 0; comprovem si el divisor es 0
    jne bucleDigitos

fiShowNumber:
    ; Recuperar los registros
    pop edi
    pop esi
    pop ebx

;Fi codi d'alumne de la rutina
mov esp, ebp
pop ebp
ret

showNumber endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: showMatrix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar el contingut de la matriu (m) al Tauler de Joc
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el número d'aquella posició de la matriu.
;
; Per a posicionar el cursor heu de recorrer totes les files i columnes de la matriu de 1 en 1
; Alhora, heu d'anar passant d'element en element incrementant l'índex d'accés a la matriu
; de dos en dos perquè les dades son de tipus short.
; Un cop que teniu la fila (row) i columna (col) i el valor posat a (number)
; heu de cridar a showCursor i showNumber.
;
; Variables  utilitzades:  
; number: Nombre que estem tractant per imprimir a pantalla
; row: Valor numèric de a fila on estem realitzant la jugada (0-3)
; col: Valor numèric de a columna on estem realitzant la jugada (0-3)
; rowScreen: Fila on volem posicionar el cursor a la pantalla
; colScreen: Columna on volem posicionar el cursor a la pantalla
; m: Matriu de 4x4 shorts que conté l'estat del tauler de joc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showMatrix proc
    push ebp
    mov ebp, esp
    ;Inici codi d'alumne de la rutina

    ; Guardem ESI perque l'utilitzarem com a index
    push esi

    ; Comencem per la fila 0
    mov eax, 0
    mov [row], eax
bucle_files:
    ; A cada nova fila comencem per la columna 0
    mov eax, 0
    mov [col], eax


bucle_columnes:

    ; Calculem la posicio de m[row][col]
    call calcIndex

    ; Guardem pos a ESI, que sera l'index de la matriu
    mov esi, [pos]

    ; La matriu es de 16 bits i number es de 32 bits
    ; Posem EAX a 0 i carreguem el valor a AX
    mov eax, 0
    mov ax, [m + esi]

    ; Guardem el valor ja preparat a number
    mov [number], eax

    ; Mostrem el numero a la seva casella
    call showNumber

    ; Passem a la seguent columna
    mov eax, [col]
    inc eax
    mov [col], eax

    ; Si encara no hem arribat a 4, continuem
    cmp eax, 4
    jne bucle_columnes

    ; Passem a la seguent fila
    mov eax, [row]
    inc eax
    mov [row], eax

    ; Si encara no hem arribat a 4, continuem
    cmp eax, 4
    jne bucle_files

    ; Recuperem ESI
    pop esi

    ;Fi codi d'alumne de la rutina
    mov esp, ebp
    pop ebp
    ret

showMatrix endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: copyMatrix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copiar els valors de la matriu (mAux) a la matriu (m).
; La matriu (mAux) no s'ha de modificar,
; els canvis s'han de fer a la matriu (m).
; Per recórrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; No cal mostrar la matriu.
;
; Variables utilitzades:  
; m: Matriu de 4x4 shorts que conté l'estat del tauler de joc
; mAux: Matriu amb els nombres rotats a la dreta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copyMatrix proc
push ebp
mov  ebp, esp
push esi
;Inici codi d'alumne de la rutina
mov esi, 0; incialitzeme el desplaçament a 0
bucle:
mov ax, [mAux + esi] ;utilitzem ax, perque els espais son de 2 bytes, si utilitzes eax barrejariem valors
mov [m + esi], ax; carreguem la casella de 2 bytes
add esi, 2; apuntema  a la seguent
cmp esi, 32; comparem si hem acabat de copiar o no la matriu, 32 ja que te 16 caselles de 2 bytes
jl bucle
;Fi codi d'alumne de la rutina
mov esp, ebp
pop ebp
ret
copyMatrix endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: shiftNumbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Desplaça a la dreta els números de cada fila de la matriu (m), mantenint l'ordre dels números
; i posant els zeros a l'esquerra.
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Per recórrer la matriu en assemblador, en aquest cas, l'índex va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb decrements de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Si es desplaça un número (NO ELS ZEROS), posarem la variable (state) a '2'.
; A cada fila, si troba un 0, mira si hi ha un número diferent de zero,
; a la mateixa fila per a posar-lo en aquella posició.
; Si una fila de la matriu és: [2,0,4,0] i state = '1', quedarà [0,0,2,4]
; i state = '2'.
; Els canvis s'han de fer sobre la mateixa matriu.
;
; Variables globals utilitzades:  
; m: Matriu de 4x4 shorts que conté l'estat del tauler de joc
; state: Indica l'estat del joc (1-5) ('2': S'han fet moviments).
; mAux:         Matriu de suport on posar els nombres rotats a la dreta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
shiftNumbers proc
   push ebp
   mov  ebp, esp
;Inici codi d'alumne de la rutina
; Guardamos los registros que vamos a utilizar
    push ebx
    push esi
    push edi

    ; EBX guarda el inicio de cada fila.
    ; Empezamos por la fila 3, que empieza en la posicion 24
    mov ebx, 24

    ; Tenemos 4 filas
    mov ecx, 4

bucleFilasShift:
    ; ESI sera la posicion que estamos mirando.
    ; Nos ponemos en la ultima columna de la fila (+6) 3 * 2 bytes = 6
    mov esi, ebx
    add esi, 6

    ; EDI sera la posicion donde queremos colocar el siguiente numero
    mov edi, esi

buscarNumero:

    ; Cogemos el numero de la posicion actual
    mov ax, [m + esi]

    ; Si es 0 no tenemos que moverlo
    cmp ax, 0
    jne numeroEncontrado
    jmp siguientePosicion


numeroEncontrado:

    ; Si origen y destino son iguales, el numero ya esta bien colocado
    cmp esi, edi
    jne moverNumero
    jmp siguienteDestino


moverNumero:

    ; Ponemos el numero en la posicion libre de la derecha
    mov [m + edi], ax

    ; Dejamos un 0 en la posicion antigua
    mov dx, 0
    mov [m + esi], dx

    ; Indicamos que se ha producido un movimiento
    mov [state], 2


siguienteDestino:

    ; El siguiente numero tendra que colocarse 2 bytes a la izquierda
    sub edi, 2


siguientePosicion:

    ; Comprobamos si ya hemos llegado al inicio de esta fila
    cmp esi, ebx
    jne seguirIzquierda
    jmp finFila


seguirIzquierda:

    ; Miramos la siguiente casilla hacia la izquierda
    sub esi, 2
    jmp buscarNumero


finFila:

    ; La fila anterior empieza 8 bytes antes
    sub ebx, 8

    ; Nos queda una fila menos
    dec ecx
    cmp ecx, 0
    jne bucleFilasShift


    ; Recuperamos los registros
    pop edi
    pop esi
    pop ebx

;Fi codi d'alumne de la rutina
   mov esp, ebp
   pop ebp
   ret

shiftNumbers endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: addPairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aparellar nombres iguals des de la dreta de la matriu (m).
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Quan es trobi una parella, dos caselles consecutives amb el mateix número, ajuntem la parella
; posant la suma de la parella a la casella de la dreta i un 0 a la casella de l'esquerra.
;Per exemple:
; Si una fila de la matriu és: [8,4,4,2] i state = 1'',
; quedarà [8,0,8,2] i state = '2'.
; Per recórrer la matriu en assemblador, en aquest cas, l'índex va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb increments de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:  
; m: Matriu de 4x4 shorts que conté l'estat del tauler de joc
; state: Indica l'estat del joc (1-5). ('2': S'han fet moviments).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
addPairs proc
push ebp
mov  ebp, esp
Push_all
;Inici codi d'alumne de la rutina

; començem desde la primera fila (abaix del tot)
mov ecx, 3              

bucle_filas:
cmp ecx, 0 ; ecx = fila, si es < 0 significa que hemos visto todas
jl fin_addPairs          

; en la fila actual empezamos desde la derecha
mov edx, 3              

bucle_columnas:
cmp edx, 0 ; edx = columna, si es < 0 debemos ir a la siguiente fila
jle siguiente_fila

; calcular casilla derecha memoria: (fila * 4 + columna) * 2
mov eax, ecx
imul eax, 4
add eax, edx
imul eax, 2
mov esi, eax ; esi = casilla derecha

; casilla izquierda = casilla derecha - 2
mov edi, esi
sub edi, 2 ; edi = casilla izquierda

mov ax, m[esi]           ; leemos el número de la derecha
mov bx, m[edi]           ; leemos el número de la izquierda

cmp ax, 0
je avanza_col            ; Si la casilla de la derecha es un 0 no se suma nada

cmp ax, bx
jne avanza_col           ; Si los dos números no son iguales no se suma nada

add ax, ax               ; por descarte son iguales, entonces * 2

mov m[esi], ax  ; guardamos la suma en la casilla de la derecha
mov m[edi], 0   ;un 0 en la casilla izquierda

mov [state], '2'   ; avisamos al juego de que el tablero ha cambiado

sub edx, 2 ; saltamos 2 columnas a la izquierda para no volver a sumar el mismo numero    
jmp bucle_columnas

avanza_col:
dec edx ; siguiente columna hacia la izquierda
jmp bucle_columnas

siguiente_fila:
dec ecx ; siguiente fila hacia arriba
jmp bucle_filas

fin_addPairs:
Pop_all
;Fi codi d'alumne de la rutina
mov esp, ebp
pop ebp
ret

addPairs endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: rotateMatrix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
; Rotar a la dreta la matriu (m), sobre la matriu (mAux). 
; La primera fila passa a ser la quarta columna, la segona fila passa 
; a ser la tercera columna, la tercera fila passa a ser la segona 
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu (m) no s'ha de modificar, els canvis s'han de fer a la matriu (mAux).
; Per a accedir a una posició concreta de la matriu des d'assemblador 
; cal tindre en compte que l'índex és:
; index_origen=(fila*DimMatrix+columna)*2)
; Es multipliquem per 2 perquè les dades son de tipus short 2 bytes.
; L'element [i][j] de la matriu original va a la posició rotada amb índex
; índex_rotat = (columna*DimMatrix+DimMatrix-1-fila)*2
; Un cop s'ha fet la rotació, copiar la matriu (mAux) a la matriu (m)
; cridant la subrutina copyMatrix.
; No s'ha de mostrar la matriu.
; 
; Variables utilitzades:   
; m:			Matriu de 4x4 shorts que conté l'estat del tauler de joc
; mAux:			Matriu de 4x4 shorts auxiliar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rotateMatrix proc
	push ebp
	mov  ebp, esp
	;Inici codi d'alumne de la rutina







 	;Fi codi d'alumne de la rutina
	mov esp, ebp
	pop ebp
	ret

rotateMatrix endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: insertTile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En aquesta subrutina s'insereix un nou element a la columna de més a l'esquerra
; de la matriu. L'element a inserir és sempre un valor 2.
; La fila en la que s'insereix l'element es va variant de forma
; rotativa, començant per la fila 0 al començament del programa.
; La següent vegada a la fila 1, i així successivament.
; Si la posició corresponent està plena es passa a la fila següent.
; Si no es pot inserir perquè estan les 4 posicions plenes
; es posa la variable (state) a 4.
;
; Variables globals utilitzades:   
; m:			Matriu de 4x4 shorts que conté l'estat del tauler de joc
; rowInsert:	Fila on farem la següent inserció d'un 2 per proseguir amb la partida
; state:		Indica l'estat del joc (1-5) ('4': NO S'ha pogut inserir --> matriu plena)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

insertTile proc
	push ebp
	mov  ebp, esp
	;Inici codi d'alumne de la rutina
    Push_all

    mov ebx, [rowInsert]
    mov edx, 0
    
    ;bucle de les 4 files a la columna rowInsert
bucle_insert:
	cmp edx, 4 ;si hem revisat les 4 files saltem
	jge tauler_ple

    mov esi, ebx
    imul esi, 8 ;calculem la casella corresponent (offset)

    mov ax, m[esi] ;obtenim el valor de la casella i el guardem
    cmp ax, 0 ;si es 0 aquella es la posició que anirà el 2
    je posicio_lliure
    
    ;si no salta hem de comprovar la fila seguent
    inc ebx ;passem a la fila seguent
    cmp ebx, 4 ;si arribem a la ultima fila tornem a la 0
    jl seguent_intent
    mov ebx, 0 ;si es 4 tornem a la fila 0

seguent_intent:
    inc edx ;sumem 1 al comptador de les files
    jmp bucle_insert ;comprovem la seguent fila

posicio_lliure:
    mov ax, 2 ;carreguem el valor 2 a inserir
    mov m[esi], ax ;inserim el 2 a la casella lliure

    ;actualitzem rowInsert a la següent fila de forma circular
    inc ebx ;passem a la fila seguent per a la proxima jugada
    cmp ebx, 4 ;comprovem si hem passat de la fila 3
    jl guardar_fila
    mov ebx, 0 ;si es 4 tornem a la fila 0

guardar_fila:
    mov [rowInsert], ebx ;guardem la nova fila a rowInsert
    jmp fi_insertTile ;sortim de la subrutina

tauler_ple:
    mov [state], '4' ;si les 4 files estan plenes posem state a '4'

fi_insertTile:
    Pop_all
 	;Fi codi d'alumne de la rutina
	mov esp, ebp
	pop ebp
	ret

insertTile endp






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: onePlay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En primer lloc cal mostrar la matriu al tauler cridant a showMatrix.
; Llegir una tecla cridant la subrutina getch, que es guarda a la variable (carac).
; Segons la tecla llegida cridarem a les subrutines corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)] 
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrix), per
; a poder fer els desplaçaments dels números cap a la dreta 
; (shiftNumbers), fer les parelles cap a la dreta (addPairs) i 
; tornar a desplaçar els nombres cap a la dreta (shiftNumbers) 
; amb les parelles fetes, després seguir rotant cridant (rotateMatrix) 
; fins deixar la matriu en la posició inicial. 
; Per a la tecla 'l' (dreta) no cal fer rotacions, per a la resta 
; s'han de fer 4 rotacions.
;    '<q>Quit' posar (state = '0') per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant la 
; subrutina showMatrix.
;
; Variables globals utilitzades:
; tecla:		Variable on s'emmagatzema el caràcter llegit del teclat
; state:		Indica l'estat del joc (1-5). ('0':sortir (Quit premut), '1':jugar)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

onePlay proc
	push ebp
	mov  ebp, esp
	;Inici codi d'alumne de la rutina





 	;Fi codi d'alumne de la rutina
	mov esp, ebp
	pop ebp
	ret

onePlay endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rutina: PlayGame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Joc del 2048
; Subrutina principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state='1')
; 
; Mentre (state) <> '0'
;	cridar onePlay
;	cridar printMessage_C
; Fi mentre.
; cridar printMessage_C
;
; Mostra un missatge a sota del tauler segons el valor de la variable 
; (state). (cridar la funció printMessage_C).
; Sortir: 
; S'acabat el joc.
;
; Variables utilitzades:
; state: Indica l'estat del joc (0-5).
;              '0': Sortir, hem premut la tecla ‘q’).
;              '1': Continuem jugant.
;              '2': Continuem jugant però s'han fet canvis a la matriu.
;              '3': Has guanyat, has fet 2048
;              '4': Taulell ple
;              '5': Tauler bloquejat, has perdut
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playGame proc
	push ebp
	mov  ebp, esp
	;Inici codi d'alumne de la rutina







 	;Fi codi d'alumne de la rutina
	mov esp, ebp
	pop ebp
	ret

playGame endp



END