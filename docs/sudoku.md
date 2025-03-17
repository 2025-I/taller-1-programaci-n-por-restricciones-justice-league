# Modelado del Sudoku como un Problema de Satisfacción de Restricciones (CSP)

## Descripción detallada del modelo CSP

### 1. Variables del problema

A continuación se describen las variables definidas en el modelo:

- **N:** Representa el tamaño total del tablero del Sudoku.
- **S:** Representa el tamaño de cada subcuadrícula (por ejemplo, un bloque de 3×3).

- **grid:**
  Es la matriz que contiene las variables de decisión, es decir, cada celda del Sudoku que se debe completar.

- **initial_values**
  Es la matriz que almacena los valores iniciales predefinidos del Sudoku.

### 2. Dominios asociados a cada variable

- **N:** Es una variable entera fija con valor 9.

- **S:** Es una variable entera fija con valor 3.

- **grid:** Cada elemento de la matriz es una variable cuyo dominio es el conjunto de enteros del 1 al 9. Esto significa que cada celda puede tomar cualquier valor entre 1 y 9.

- **initial_values:** Cada elemento es un entero que representa el valor inicial asignado a una celda. Aunque no se especifica explícitamente un dominio numérico en el modelo, se usa en la restricción para fijar el valor de las celdas en la matriz grid cuando es mayor a 0 (por lo general, los valores se esperan entre 0 y 9, donde 0 indica que la celda está vacía).

### 3. Restricciones

A continuación se describen las restricciones del modelo en texto normal:

- **Restricción de valores iniciales:**
  Para cada celda del tablero, si en la matriz de valores iniciales existe un número (es decir, el valor es mayor que 0), se debe fijar ese mismo valor en la celda correspondiente de la matriz de decisión. En otras palabras, si initial_values[i, j] > 0, entonces grid[i, j] debe ser igual a initial_values[i, j].

- **Restricción de filas:**
  Cada fila del tablero debe contener números distintos. Esto significa que, para cada fila, los 9 números asignados (uno en cada celda de la fila) deben ser todos diferentes.

- **Restricción de columnas:**
  De forma similar a las filas, cada columna del tablero debe tener números distintos. Cada una de las 9 columnas debe estar compuesta por números únicos, sin repeticiones.

- **Restricción de subcuadrículas:**
  El tablero se divide en 9 bloques o subcuadrículas de 3×3. En cada uno de estos bloques, los 9 números deben ser distintos. La restricción se formula utilizando índices que recorren cada subcuadrícula, garantizando que en cada bloque de 3 filas por 3 columnas no se repita ningún número.

## Código MiniZinc utilizado

A continuación, se muestra el código MiniZinc diseñado para modelar el Sudoku.

```minizinc
include "alldifferent.mzn";

% Variables

int: N = 9; % tamaño del tablero
int: S = 3; % tamaño de la subcuadrícula
array[1..N, 1..N] of var 1..9: grid; % matriz de variables

array[1..N, 1..N] of int: initial_values; % valores iniciales

% Restricciones
% restricción de valores iniciales
constraint forall(i in 1..N, j in 1..N) (
  initial_values[i, j] > 0 -> grid[i, j] = initial_values[i, j]
);

% restricción de filas
constraint forall(i in 1..N) (
  alldifferent([grid[i, j] | j in 1..N])
);

% restricción de columnas
constraint forall(j in 1..N) (
  alldifferent([grid[i, j] | i in 1..N])
);

% restricción de subcuadrículas
constraint forall(i in 1..S-1, j in 1..S-1) (
  alldifferent([grid[i*S + di, j*S + dj] | di in 1..S, dj in 1..S])
);

% Solución
solve satisfy;
%solve :: int_search(grid, first_fail, complete) satisfy;
%solve :: int_search(grid, smallest, complete) satisfy;
%solve :: int_search(grid, input_order, complete) satisfy;

% salida
output [
  if j == N then show(grid[i, j]) ++ "\n"
  else show(grid[i, j]) ++ " "
  endif
  | i in 1..N, j in 1..N
];
```

## Resultados obtenidos con las diferentes estrategias de distribución

## Análisis comparativo de las ventajas y desventajas de cada implementación
