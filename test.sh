#!/bin/bash

# Ejecuta MiniZinc para un modelo y un patrón de archivos .dzn
run_minizinc() {
    local model_file=$1
    local dzn_pattern=$2

    echo "Procesando archivos con el modelo: $model_file"
    for dzn_file in "$DZN_FOLDER"/$dzn_pattern; do
        echo "Ejecutando $dzn_file con el modelo $model_file"
        minizinc "$model_file" "$dzn_file"
    done
}

# Carpeta que contiene los archivos .dzn
DZN_FOLDER="input"

# Ejecutar MiniZinc para Sudoku
run_minizinc "sudoku.mzn" "sudoku*.dzn"

# Ejecutar MiniZinc para Kakuro
run_minizinc "kakuro.mzn" "kakuro*.dzn"
