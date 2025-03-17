# Modelado del Sudoku como un Problema de Satisfacción de Restricciones (CSP)

- **Autor(es):** Diego Alejandro Tolosa Sanchez, Juan Esteban López Aránzazu, Victor Manuel Álzate Morales.
- **Curso:** Programación por Restricciones
- **Profesor:** Carlos Andrés Delgado S.

---

## Descripción detallada del modelo CSP

### 1. Variables del problema

A continuación, se describen las variables definidas en el modelo:

- **N:** Representa el tamaño total del tablero del Sudoku.
- **S:** Representa el tamaño de cada subcuadrícula (por ejemplo, un bloque de 3×3).

- **grid:**
  Es la matriz que contiene las variables de decisión, es decir, cada celda del Sudoku que se debe completar.

- **initial_values**
  Es la matriz que almacena los valores iniciales predefinidos del Sudoku.

### 2. Dominios asociados a cada variable

A continuación, se describen los dominios de las variables en el modelo:

- **N:** Es una variable entera fija con valor 9.

- **S:** Es una variable entera fija con valor 3.

- **grid:** Cada elemento de la matriz es una variable cuyo dominio es el conjunto de enteros del 1 al 9. Esto significa que cada celda puede tomar cualquier valor entre 1 y 9.

- **initial_values:** Cada elemento es un entero que representa el valor inicial asignado a una celda. Aunque no se especifica explícitamente un dominio numérico en el modelo, se usa en la restricción para fijar el valor de las celdas en la matriz grid cuando es mayor a 0 (por lo general, los valores se esperan entre 0 y 9, donde 0 indica que la celda está vacía).

### 3. Restricciones

A continuación, se describen las restricciones del modelo:

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

### 1. Estrategia de Búsquedad `first_fail`.

`first_fail` implementa la heurística del "primero en fallar". Esta estrategia elíge primero la variable con menor número de valores posibles, lo que suele reducir el espacio de búsquedad al resolver las variables más restringidas antes.

![Arbol Sudoku First_fail](/docs/images/arbol-sudoku-first_fail.jpg)

El análisis del árbol de búsqueda con la estrategia `first_fail` muestra una profundidad de 20, indicando que el algoritmo tuvo que tomar hasta 20 decisiones consecutivas en el peor caso antes de alcanzar una solución o detectar un fallo.

Se exploraron 1372 nodos, de los cuales 1110 representan estados válidos donde las restricciones del Sudoku se cumplen parcialmente. Sin embargo, hubo 263 fallos (backtracking), lo que significa que en esos puntos el algoritmo encontró asignaciones incorrectas y tuvo que retroceder.

### 2. Estrategia de Búsquedad `Smallest`.

`Smallest` selecciona primero el valor más pequeño disponible en el dominio de una variable. Esta estrategia permite explorar primero las opciones más bajas, lo que puede ser útil en ciertos problemas donde los valores pequeños tienen más probabilidades de formar parte de la solución.

![Arbol Sudoku Smallest](/docs/images/arbol-sudoku-smallest.jpg)

### 3. Estrategia de Búsquedad `Input_order`.

`Input_order` Sigue el orden en el que las variables aparecen en la entrada del problema. Es decir, se resuelven las celdas en el mismo orden en que fueron leídas, sin priorizar aquellas con menos opciones disponibles. Sigue un enfoque directo y secuencial.

![Arbol Sudoku Input_order](/docs/images/arbol-sudoku-input_order.jpg)

## Análisis comparativo de las ventajas y desventajas de cada implementación

| Estrategia de Búsquedad  | :white_check_mark: Ventajas | :x: Desventajas |
| -| - | - |
| **First_fail**| :heavy_check_mark: Reduce el espacio de búsquedad al enfocarse en las variables más restricitvas primero. <br> :heavy_check_mark: Disminuye el número de fallos y retrocesos (backtracking). <br> :heavy_check_mark: Es eficiente en problemas donde algunas variables tiene dominios muy pequeños o están altamente restringidas. <br> :heavy_check_mark: Puede acelerar la búsqueda en problemas donde hay pocas soluciones posibles.| :x: Puede requerir cálculos adicionales para determinar qué variable tiene el menor número de valores posibles. <br> :x: Aunque encuentra una solución rápidamente, no necesariamente es la más óptima en términos de calidad. <br> :x: En problemas con muchas soluciones, puede hacer que se explore más de lo necesario.| 
| **Smallest**             | :heavy_check_mark: Explora primero los valores más bajos, lo que puede llevar a soluciones más naturales en ciertos problemas. <br> :heavy_check_mark: Puede ser útil en problemas donde los valores más pequeños tienen mayor probabilidad de ser parte de la solución. <br> :heavy_check_mark: En problemas numéricos, puede generar soluciones con valores más pequeños, que podrían ser preferibles en algunos casos. <br>   | :x: No tiene en cuenta las restricciones del problema al seleccionar los valores. Lo que puede resultar en una exploración menos eficiente. <br> :x: Puede conducir a una exploración innecesaria si los valores más pequeños no forman parte de la solución. <br> :x: Puede ser menos eficiente en problemas donde los valores más grandes son más revelante, como en problemas de maximización. <br> |
| **Input_order**             | :heavy_check_mark: Simple de implementar y no requiere cálculos adicionales. <br> :heavy_check_mark: Puede ser útil si el orden de entrada ya está optimizado para un caso específico. <br> :heavy_check_mark: Puede ser adecuado en problemas donde el orden natural de lectura de datos es relevante. <br>  | :x: No optimiza la búsqueda, lo que puede aumentar el número de intentos fallidos. <br> :x: Puede generar árboles de búsqueda muy grandes y profundos, con más backtracking. <br> :x: No prioriza variables críticas, lo que puede hacer más lenta la resolución del Sudoku. <br> :x: En problemas con muchas restricciones, puede conducir a asignaciones erróneas frecuentes. <br>  |