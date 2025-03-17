# Modelado del Kakuro como un Problema de Satisfacción de Restricciones (CSP)

## Descripción detallada del modelo CSP

### 1. Variables del problema

A continuación se describen las variables definidas en el modelo:

- **N:** Representa el número de filas de la matriz.
- **M:** Representa el número de columnas de la matriz.
- **grid:** Matriz (de dimensiones N x M) que contendrá la solución del problema, es decir, los valores asignados a cada celda.
- **row_sums:** Vector que almacena la suma objetivo que debe alcanzar cada fila de la matriz.
- **col_sums:** Vector que indica la suma objetivo para cada columna.
  initial_values: Matriz con valores iniciales para ciertas celdas; si en una posición el valor es mayor que 0, ese valor se fija en la solución.

### 2. Dominios asociados a cada variable

- **N** y **M**: Dominio: Son enteros, cuyos valores se definen en la instancia del problema.

- **grid:** Dominio: Cada elemento es una variable entera que puede tomar valores del 1 al 9 (es decir, 1..9).

- **row_sums** y **col_sums:** Dominio: Cada elemento es un entero. Los valores concretos se establecen en la instancia y representan la suma que deben alcanzar las filas y columnas, respectivamente.

- **initial_values:** Dominio: Cada elemento es un entero. Se utiliza para fijar determinados valores en la matriz grid cuando son mayores que 0.

### 3. Restricciones

A continuación se describen las restricciones del modelo en texto normal:

- **Restricción de Valores Iniciales:** Para cada posición (i, j) de la matriz, si **initial_values[i, j]** es mayor que 0, entonces se impone que **grid[i, j]** debe tomar ese mismo valor.

- **Restricción de Unicidad en Filas:**
  Cada fila de la matriz debe tener valores distintos; se utiliza el predicado alldifferent para asegurar que no se repitan números en ninguna fila.

- **Restricción de Unicidad en Columnas:**
  De manera similar, cada columna debe contener números únicos.

- **Restricción de Suma en Filas:**
  La suma de los valores de cada fila debe coincidir con el valor indicado en **row_sums** para esa fila.

- **Restricción de Suma en Columnas:**
  La suma de los valores de cada columna debe ser igual al valor establecido en col_sums para esa columna.

## Código MiniZinc utilizado

A continuación, se muestra el código MiniZinc diseñado para modelar el Kakuro.

```minizinc
include "alldifferent.mzn";

% variables
int: N; % filas
int: M; % columnas
array[1..N, 1..M] of var 1..9: grid; % matriz de variables
array[1..N] of int: row_sums; % suma de filas
array[1..M] of int: col_sums; % suma de columnas

array[1..N, 1..M] of int: initial_values; % valores iniciales


% Restricciones

% restricción de valores iniciales
constraint forall(i in 1..N, j in 1..M) (
  initial_values[i, j] > 0 -> grid[i, j] = initial_values[i, j]
);

% las filas y columnas deben ser diferentes
constraint forall(i in 1..N) (
  alldifferent([grid[i, j] | j in 1..M])
);

constraint forall(j in 1..M) (
  alldifferent([grid[i, j] | i in 1..N])
);

% restricciones de suma de filas y columnas
constraint forall(i in 1..N) (
  sum([grid[i, j] | j in 1..M]) == row_sums[i]
);

constraint forall(j in 1..M) (
  sum([grid[i, j] | i in 1..N]) == col_sums[j]
);

% Solución
solve satisfy;
%solve :: int_search(grid, first_fail, complete) satisfy;
%solve :: int_search(grid, smallest, complete) satisfy;
%solve :: int_search(grid, input_order, complete) satisfy;

% salida
output [
  if j == M then show(grid[i, j]) ++ "\n"
  else show(grid[i, j]) ++ " "
  endif
  | i in 1..N, j in 1..M
];
```

## Resultados obtenidos con las diferentes estrategias de distribución

## Análisis comparativo de las ventajas y desventajas de cada implementación
