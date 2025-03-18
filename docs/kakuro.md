# Modelado del Kakuro como un Problema de Satisfacción de Restricciones (CSP)

- **Autor(es):** Diego Alejandro Tolosa Sanchez, Juan Esteban López Aránzazu, Victor Manuel Álzate Morales.
- **Curso:** Programación por Restricciones
- **Profesor:** Carlos Andrés Delgado S.

---

## Descripción detallada del modelo CSP

### 1. Variables del problema

A continuación, se describen las variables definidas en el modelo:

- **N, M:** Representan el tamaño del tablero en términos de filas y columnas.
- **row_groups_count, col_groups_count:** Cantidad de grupos de suma definidos en filas y columnas.
- **initial_values:** Matriz que indica si una celda está fija (1) o es jugable (0).
- **row_groups:** Lista de grupos de suma en filas, con su fila, columna de inicio, columna final y suma objetivo.
- **col_groups:** Lista de grupos de suma en columnas, con su columna, fila de inicio, fila final y suma objetivo.
- **grid:** Matriz de variables de decisión, con valores entre 1 y 9 para celdas jugables.

### 2. Dominios asociados a cada variable

A continuación, se describen los dominios de las variables en el modelo:

- **N, M:** Son valores enteros fijos que representan las dimensiones del tablero.
- **row_groups_count, col_groups_count:** Son valores enteros fijos que indican la cantidad de grupos de suma en filas y columnas, respectivamente.
- **initial_values:** Es una matriz de valores enteros donde 1 representa una celda bloqueada (se convierte en 0 en grid) y 0 representa una celda jugable (cuyo valor debe estar entre 1 y 9).
- **row_groups, col_groups:** Cada grupo tiene cuatro valores enteros (posición inicial y final, y suma objetivo).
- **grid:** Puede tomar valores entre 1 y 9 si la celda es jugable; si está predefinida, debe mantenerse en 0.

### 3. Restricciones

A continuación, se describen las restricciones del modelo:

#### Restricción de valores iniciales  
Cada celda en `grid` debe respetar los valores dados en `initial_values`.  
- Si `initial_values[i, j] == 1`, entonces `grid[i, j] = 0` (la celda está bloqueada).  
- Si `initial_values[i, j] == 0`, entonces `grid[i, j]` debe tomar un valor entre `1` y `9`.  

#### Restricción de grupos en filas  
Para cada grupo de suma en filas, se debe cumplir lo siguiente:  
- La suma de los valores dentro del rango de columnas definido para el grupo debe ser igual a la suma objetivo del grupo.  
- Todos los valores dentro del grupo deben ser distintos (no se pueden repetir).  

#### Restricción de grupos en columnas  
Para cada grupo de suma en columnas, se debe cumplir lo siguiente:  
- La suma de los valores dentro del rango de filas definido para el grupo debe ser igual a la suma objetivo del grupo.  
- Todos los valores dentro del grupo deben ser distintos (no se pueden repetir). 

## Código MiniZinc utilizado

A continuación, se muestra el código MiniZinc diseñado para modelar el Kakuro.

```minizinc
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
```

## Resultados obtenidos con las diferentes estrategias de distribución

> [!NOTE]
> Las pruebas del modelo se realizaron utilizando el archivo de datos [`kakuro1.dzn`](/input/kakuro1.dzn)

### 1. Estrategia de Búsquedad `first_fail`.

`first_fail` implementa la heurística del "primero en fallar". Esta estrategia elíge primero la variable con menor número de valores posibles, lo que suele reducir el espacio de búsquedad al resolver las variables más restringidas antes.

![Arbol Kakuro First_fail](/docs/images/arbol-kakuro-first_fail.png)

El análisis del árbol de búsqueda con la estrategia `first_fail` muestra una profundidad de 15 niveles. Durante la exploración, se generaron un total de 243 nodos, de los cuales 168 fueron expandidos con éxito, mientras que 76 fueron descartados debido a restricciones o poda. Esto refleja el comportamiento del enfoque `first_fail`, que prioriza primero las variables más restrictivas, optimizando la búsqueda en el espacio de soluciones.

### 2. Estrategia de Búsquedad `Smallest`.

`Smallest` selecciona primero el valor más pequeño disponible en el dominio de una variable. Esta estrategia permite explorar primero las opciones más bajas, lo que puede ser útil en ciertos problemas donde los valores pequeños tienen más probabilidades de formar parte de la solución.

![Arbol Kakuro Smallest](/docs/images/arbol-kakuro-smallest.png)

El análisis del árbol de búsqueda con la estrategia `smallest` muestra una profundidad de 18 niveles. Durante la exploración, se generaron un total de 319 nodos, de los cuales 168 fueron expandidos con éxito, mientras que 152 fueron descartados debido a restricciones o poda. Esto refleja el comportamiento del enfoque `smallest`, que selecciona primero las variables con los valores más pequeños, lo que puede influir en la eficiencia de la búsqueda en el espacio de soluciones.

### 3. Estrategia de Búsquedad `Input_order`.

`Input_order` Sigue el orden en el que las variables aparecen en la entrada del problema. Es decir, se resuelven las celdas en el mismo orden en que fueron leídas, sin priorizar aquellas con menos opciones disponibles. Sigue un enfoque directo y secuencial.

![Arbol Kakuro Input_order](/docs/images/arbol-kakuro-input_order.png)

El análisis del árbol de búsqueda con la estrategia `input_order`  muestra una profundidad de 16 niveles. Durante la exploración, se generaron un total de 254 nodos, de los cuales 168 fueron expandidos con éxito, mientras que 87 fueron descartados debido a restricciones o poda. Esto refleja el comportamiento del enfoque `input_order` , que selecciona las variables en el mismo orden en que aparecen en la declaración del modelo, lo que puede afectar la eficiencia de la búsqueda dependiendo de la estructura del problema.

## Análisis comparativo de las ventajas y desventajas de cada implementación

| Estrategia      | Profundidad | Nodos Expandidos | Nodos Fallidos | Nodos Totales |
|----------------|------------|------------------|---------------|--------------|
| **first_fail** | 15         | 168              | 76            | 243          |
| **smallest**   | 18         | 168              | 152           | 319          |
| **input_order**| 16         | 168              | 87            | 254          |

### **First_fail**  
- Menor profundidad y menos fallos, optimiza restricciones.  
- No siempre encuentra la mejor solución global.  

### **Smallest**  
- Útil si los valores pequeños son clave en la solución.  
- Más nodos fallidos y mayor carga computacional.  

### **Input_order**  
- Sigue el orden de declaración, útil si ya está optimizado.  
- No prioriza restricciones ni valores clave.  

### **Conclusión**  
- `first_fail` es la mejor opción si se busca eficiencia.  
- `smallest` es útil en problemas donde los valores pequeños importan.  
- `input_order` es intermedio, pero menos optimizado.  
