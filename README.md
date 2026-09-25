# 2048 en Ensamblador x86

Práctica de la asignatura **Estructura de Computadores** para implementar el funcionamiento interno del juego 2048 combinando **C++** y **Ensamblador x86 (MASM de 32 bits)**.

El entorno de ejecución, menús e interfaz por consola vienen preparados en C++, mientras que las funciones de gestión de memoria, dibujo en pantalla y la lógica de los movimientos se implementan a bajo nivel en ensamblador.

---

## Estructura del proyecto

* `main_NB.cpp`: Bucle principal, control del menú de opciones y llamadas a las funciones de ensamblador.
* `globals.h`: Definición de variables globales compartidas (matriz de juego `m`, matriz auxiliar `mAux`, cursores, puntuación...).
* `prac_NB - Alumne.asm`: Archivo de ensamblador donde se completan las subrutinas requeridas.

---

## Estado de implementación

- [x] **showCursor**: Posiciona el cursor en la consola a partir de la fila y columna del tablero.
- [x] **calcIndex**: Cálculo del índice de memoria para acceder a los elementos `short` de la matriz.
- [ ] **showNumber**: Imprime en consola números de hasta 4 dígitos en formato ASCII rellenando espacios a la izquierda.
- [ ] **showMatrix**: Recorrido de la matriz y dibujo del tablero completo.
- [ ] **copyMatrix**: Copia de los datos de `mAux` en `m`.
- [ ] **shiftNumbers**: Desplazamiento de números hacia la derecha rellenando huecos vacíos con ceros.
- [ ] **addPairs**: Fusión y suma de números contiguos idénticos.

---

## Cómo compilar y ejecutar

1. Abrir la solución en **Visual Studio**.
2. Comprobar que la configuración esté fijada en **x86** (o Win32).
3. Asegurarse de tener activada la dependencia de compilación de **MASM** (*Build Dependencies -> Build Customizations -> masm*).
4. Compilar con `Ctrl + Shift + B` y ejecutar con `F5` o `Ctrl + F5`.
