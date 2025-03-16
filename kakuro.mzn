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
