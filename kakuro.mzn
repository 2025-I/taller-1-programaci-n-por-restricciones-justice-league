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

% Restricciones de los grupos en filas
constraint forall(g in 1..row_groups_count) (
    let {
        int: i = row_groups[g, 1],  % Fila del grupo
        int: j_start = row_groups[g, 2],  % Columna inicio
        int: j_end = row_groups[g, 3],  % Columna fin
        int: target_sum = row_groups[g, 4]  % Suma objetivo
    } in
    sum([grid[i, j] | j in j_start..j_end]) == target_sum /\
    alldifferent([grid[i, j] | j in j_start..j_end])
);

% Restricciones de los grupos en columnas
constraint forall(g in 1..col_groups_count) (
    let {
        int: j = col_groups[g, 1],  % Columna del grupo
        int: i_start = col_groups[g, 2],  % Fila inicio
        int: i_end = col_groups[g, 3],  % Fila fin
        int: target_sum = col_groups[g, 4]  % Suma objetivo
    } in
    sum([grid[i, j] | i in i_start..i_end]) == target_sum /\
    alldifferent([grid[i, j] | i in i_start..i_end])
);

% solución
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
