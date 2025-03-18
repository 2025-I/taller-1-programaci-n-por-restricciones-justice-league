include "alldifferent.mzn";

% variables

% Tamaño del tablero
int: N; % filas
int: M; % columnas

int: row_groups_count; % Número de grupos de suma en filas
int: col_groups_count; % Número de grupos de suma en columnas

% Matriz de juego
array[1..N, 1..M] of int: initial_values;

% Matrices de pistas
array[1..row_groups_count, 1..4] of int: row_groups; % [fila, columna inicial, columna final, suma objetivo]
array[1..col_groups_count, 1..4] of int: col_groups; % [columna, fila inicial, fila final, suma objetivo]

% Matriz de valores jugables
array[1..N, 1..M] of var 0..9: grid;

% restricciones

% Restricciones de las celdas jugables
constraint forall(i in 1..N, j in 1..M) (
    (initial_values[i, j] == 1 -> grid[i, j] = 0) /\
    (initial_values[i, j] == 0 -> grid[i, j] >= 1 /\ grid[i, j] <= 9)
);