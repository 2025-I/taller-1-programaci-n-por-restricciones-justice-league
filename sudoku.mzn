include "alldifferent.mzn";

% Variables

int: N = 9; % tamaño del tablero
int: S = 3; % tamaño de la subcuadrícula
array[1..N, 1..N] of var 1..9: grid; % matriz de variables

array[1..N, 1..N] of int: initial_values; % valores iniciales

% Restricciones


% Solución

