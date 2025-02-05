#!/bin/bash

# Percorso della cartella con i file parquet di input
INPUT_DIR="/eos/user/b/bdanzi/VH_score_outputDir_v2/"
# Cartella dove salvare i file di output
OUTPUT_DIR="/eos/user/b/bdanzi/Single_score_outputDir_v2"
# Modello e variabili YAML
MODEL_DIR="models/SingleH_v2/dnn_singleH_class_mva_train_nowp90/"
VARIABLES_YAML="models/SingleH_v2/variables_train_singleH_Withmbb.yaml"

# Creare la cartella di output se non esiste
mkdir -p "$OUTPUT_DIR"

# Loop su tutti i file .parquet nella cartella di input
for PQ_FILE in "$INPUT_DIR"/*.parquet; do
    # Estrarre il nome del file senza estensione
    FILE_NAME=$(basename "$PQ_FILE")

    # Costruire il nome del file di output
    OUTPUT_FILE="${OUTPUT_DIR}/${FILE_NAME}_SingleHiggs_VH_score.parquet"

    # Stampare il comando in esecuzione (opzionale)
    echo "Processing: $PQ_FILE -> $OUTPUT_FILE"

    # Eseguire il comando con i file appropriati
    python3 model_reader.py \
        --model "$MODEL_DIR" \
        --pq_file "$PQ_FILE" \
        --pq_file_output "$OUTPUT_FILE" \
        --column_name SingleH_score \
        --variablesYaml "$VARIABLES_YAML"
done

echo "Processing completed!"
