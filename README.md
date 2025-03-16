[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/agiyKqJx)
# Taller 1: Modelamiento de CSP

## Integrantes

Nombre completo | Código
Juan Esteban López Aránzazu | 2313026
Victor Manuel Álzate Morales | 2313022
Diego Alejandro Tolosa Sanchez | 2313023

## Descripción del taller

Este taller consiste en modelar y resolver los juegos de Sudoku y Kakuro como problemas de satisfacción de restricciones (CSP). Se formularán las reglas de cada juego como restricciones, se implementarán modelos en MiniZinc y se resolverán. Además, se compararán y analizarán los resultados obtenidos al aplicar diferentes estrategias de distribución.

## Ejecución del Sudoku

Para ejecutar el modelo de Sudoku, utilice el siguiente comando en MiniZinc:

```bash
minizinc sudoku.mzn input/sudoku1.dzn
minizinc sudoku.mzn input/sudoku2.dzn
minizinc sudoku.mzn input/sudoku3.dzn
```

## Ejecución del Kakuro

Para ejecutar el modelo de Kakuro, utilice el siguiente comando en MiniZinc:

```bash
minizinc kakuro.mzn input/kakuro1.dzn
minizinc kakuro.mzn input/kakuro2.dzn
minizinc kakuro.mzn input/kakuro3.dzn
```
