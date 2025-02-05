#!/bin/bash

# Cartella di destinazione per tutti i file .parquet
DEST_DIR="/eos/user/b/bdanzi/Merged_SnTv2"
mkdir -p "$DEST_DIR"

# Lista di file sorgente
FILES=(
"/eos/user/e/evourlio/HiggsDNA/samples_data_2022preEE_RunCD/merged/Run2022C/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_data_2022preEE_RunCD/merged/Run2022D/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_data_2022postEE_RunE/merged/Run2022E/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_data_2022postEE_RunFG/merged/Run2022F/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_data_2022postEE_RunFG/merged/Run2022G/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022preEE/merged/GluGluToHH/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022postEE/merged/GluGluToHH/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022preEE/merged/GluGluToHH_kl0p00/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022postEE/merged/GluGluToHH_kl0p00/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022preEE/merged/GluGluToHH_kl5p00/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSignal_2022postEE/merged/GluGluToHH_kl5p00/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022preEE/merged/GluGluHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022postEE/merged/GluGluHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022preEE/merged/ttHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022postEE/merged/ttHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022preEE/merged/VBFHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022postEE/merged/VBFHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022preEE/merged/VHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcSingleHiggs_2022postEE/merged/VHToGG/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGGJets_2022preEE/merged/GGJets/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGGJets_2022postEE/merged/GGJets/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcTTGG_2022preEE/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcTTGG_2022postEE/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-100to200/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-200to400/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-400to600/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-40to70/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-70to100/merged/nominal/NOTAG_merged.parquet"
"/eos/user/e/evourlio/HiggsDNA/samples_mcGJets_2022postEE/G-4Jets_HT-600/merged/nominal/NOTAG_merged.parquet"
)

# Copia tutti i file nella cartella di destinazione
for FILE in "${FILES[@]}"; do
    if [[ -f "$FILE" ]]; then
        echo "Copying $FILE to $DEST_DIR"
	NEW_NAME=$(echo "$FILE" | sed -E 's|/eos/user/e/evourlio/HiggsDNA/samples_||' | \
                  sed -E 's|/NOTAG_merged.parquet$|_NOTAG_merged.parquet|' | \
                  sed -E 's|/|_|g')  # Sostituisci tutti i '/' con '_'
	#BASENAME=$(echo "$FILE" | sed -E 's|.*/samples_([^/]+)/.*|samples_\1|')
        #NEW_NAME=$(echo "$INPUT_FILE" | sed -E 's|/eos/user/e/evourlio/HiggsDNA/samples_||' | sed -E 's|/NOTAG_merged.parquet$|.parquet|' | sed -E 's|/|_|g')

#        NEW_NAME="${BASENAME}_NOTAG_merged.parquet"

        echo "Copying $FILE to $DEST_DIR/$NEW_NAME"
        cp "$FILE" "$DEST_DIR/$NEW_NAME"
    else
        echo "Warning: File $FILE not found!"
    fi
done

echo "All files copied to $DEST_DIR!"
