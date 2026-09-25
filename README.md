# 🎮 2048 Puzzle — x86 Assembly (Nivel Básico)

Implementación en lenguaje ensamblador **x86 (MASM de 32 bits)** integrada con una interfaz en **C++** en modo consola para el clásico juego **2048**[cite: 2, 4].

Este proyecto forma parte de las prácticas de la asignatura de **Estructura de Computadores**[cite: 4].

---

## 📋 Descripción del Proyecto

El objetivo es programar a bajo nivel las rutinas encargadas de la manipulación de la memoria, posicionamiento de pantalla, formateo de números en ASCII y la lógica algorítmica de desplazamiento y fusión de fichas sobre una cuadrícula de $4 \times 4$[cite: 1, 3, 4].

* La interfaz de consola y el menú interactivo están gestionados desde **C++** (`main_NB.cpp`).
* Los cálculos de pantalla, manipulación de matrices y la lógica de juego se desarrollan en **Ensamblador x86** (`prac_NB - Alumne.asm`)[cite: 2, 3].

---

## 🛠️ Tecnologías y Entorno

* **Lenguaje:** C++ y Ensamblador x86 (Intel Syntax, MASM)[cite: 2, 3]
* **Arquitectura:** 32 bits (x86 / IA-32)[cite: 3]
* **Entorno de desarrollo:** Visual Studio[cite: 2]
* **Sistema Operativo:** Windows (Consola Win32)[cite: 2]

---

## 📁 Estructura del Repositorio

| Archivo | Descripción |
| :--- | :--- |
| `globals.h` | Declaración de variables globales compartidas (`m`, `mAux`, cursores, estado)[cite: 1]. |
| `main_NB.cpp` | Código maestro en C++: bucle del juego, menú interactivo y llamadas a ASM[cite: 2]. |
| `prac_NB - Alumne.asm` | Subrutinas en ensamblador a implementar por el alumno[cite: 3]. |

---

## ⚙️ Subrutinas Implementadas y Requeridas

* [x] **`showCursor`**: Traduce las coordenadas lógicas de matriz `(row, col)` a coordenadas de pantalla `(rowScreen, colScreen)` e invoca `gotoxy`[cite: 3, 4].
* [x] **`calcIndex`**: Calcula el desplazamiento en bytes dentro del vector contiguo de enteros cortos (`short`, 2 bytes) para acceder a `m[row][col]`[cite: 1, 3, 4].
* [ ] **`showNumber`**: Descompone un entero en millares, centenas, decenas y unidades, convirtiéndolos a código ASCII alineado a la derecha en 4 caracteres[cite: 3, 4].
* [ ] **`showMatrix`**: Recorre los 16 elementos de la matriz e imprime todo el tablero en pantalla[cite: 3, 4].
* [ ] **`copyMatrix`**: Copia en memoria el contenido de la matriz de respaldo `mAux` en la matriz de juego `m`[cite: 3, 4].
* [ ] **`shiftNumbers`**: Desplaza los números no nulos de cada fila hacia la derecha, rellenando con ceros a la izquierda[cite: 3, 4].
* [ ] **`addPairs`**: Detecta fichas contiguas con idéntico valor en la misma fila y las fusiona sumándolas hacia la derecha[cite: 3, 4].

---

## 🚀 Compilación y Ejecución en Visual Studio

1. **Abrir el proyecto:** Crear un proyecto vacío de C++ en Visual Studio.
2. **Habilitar MASM:** Clic derecho sobre el proyecto $\rightarrow$ *Dependencias de compilación* (*Build Dependencies*) $\rightarrow$ *Personalizaciones de compilación...* $\rightarrow$ Marcar **masm**.
3. **Ajustar la arquitectura:** Seleccionar **x86** (o **Win32**) en la barra superior.
4. **Añadir archivos:** Agregar `globals.h` a *Archivos de encabezado*, y `main_NB.cpp` junto a `prac_NB - Alumne.asm` a *Archivos de origen*.
5. **Tipo de compilador:** Asegurarse de que las propiedades del archivo `.asm` tengan el campo *Tipo de elemento* establecido en **Microsoft Macro Assembler**.
6. **Compilar y Ejecutar:** Presionar `Ctrl + F5` para lanzar el menú interactivo[cite: 2].

---

## 🎮 Controles del Menú Principal

```text
 __________________________________ 
|                                  |
|            MAIN MENU             |
|__________________________________|
|                                  |
|         1. ShowCursor            |
|         2. ShowNumber            |
|         3. ShowMatrix            |
|         4. CopyMatrix            |
|         5. ShiftNumbers          |
|         6. AddPairs              |
|         0. Exit                  |
|__________________________________|
