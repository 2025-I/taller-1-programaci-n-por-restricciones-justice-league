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
%solve satisfy;
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
