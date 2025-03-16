include "alldifferent.mzn";

% variables
int: N; % filas
int: M; % columnas
array[1..N, 1..M] of var 1..9: grid; % matriz de variables
array[1..N] of int: row_sums; % suma de filas
array[1..M] of int: col_sums; % suma de columnas

array[1..N, 1..M] of int: initial_values; % valores iniciales


% Restricciones


% Solución
