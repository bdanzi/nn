import os
os.environ["KERAS_BACKEND"] = "tensorflow"

import tensorflow as tf
from tensorflow import keras
print("Backend set to TensorFlow successfully!")

import os
import argparse
import yaml
import tensorflow as tf
import pandas as pd
import numpy as np
import pyarrow.parquet as pq
import matplotlib.pyplot as plt
import mplhep as hep

def load_yaml(file_path):
    with open(file_path, "r") as file:
        return yaml.safe_load(file)

# Argument Parsing
parser = argparse.ArgumentParser()
parser.add_argument("--model", help="model directory, .keras only supported", type=str, required=True)
parser.add_argument("--pq_file", help="input pq file, with relative path", type=str, required=True)
parser.add_argument("--column_name", help="name of the output column of the pq file", type=str, required=False)
parser.add_argument("--pq_file_output", help="name of the output pq file", type=str, required=False)
args = parser.parse_args()

# Ensure model directory exists
model_dir = args.model
if not os.path.isdir(model_dir):
    raise FileNotFoundError(f"Model directory '{model_dir}' does not exist.")

# Search for YAML and .keras files in the model directory
yaml_files = [f for f in os.listdir(model_dir) if f.endswith(".yaml")]
mod_files = [f for f in os.listdir(model_dir) if f.endswith(".keras")]

if not yaml_files or len(yaml_files) > 1:
    raise FileNotFoundError("No YAML file found or too many YAML files in the model directory.")
if not mod_files or len(mod_files) > 1:
    raise FileNotFoundError("No .keras file found or too many .keras files in the model directory.")

# Load model and variables
model_path = os.path.join(model_dir, mod_files[0])
print(f"Loading model from: {model_path}")
model = tf.keras.models.load_model(model_path)

variables_file = os.path.join(model_dir, yaml_files[0])
variables = load_yaml(variables_file)
print(f"Loaded variables from: {variables_file}")

# Load Parquet file
parquet_file_incl = pq.read_table(args.pq_file)
df_incl = parquet_file_incl.to_pandas()

input_variables = [var for var in variables.keys()]

print("Checking for missing variables...")
for var in input_variables:
    if var not in df_incl.columns:
        print(f"Variable '{var}' missing. Adding it...")

        # Add missing variables one by one with appropriate calculations
        if var == "M_chi":
            df_incl["M_chi"] = (
                df_incl["HHbbggCandidate_mass"]
                - df_incl["mass"]
                - df_incl["dijet_mass"]
                + 2 * 124.9
            )
        elif var == "CosThetaStar_CS":
            df_incl["CosThetaStar_CS"] = np.abs(df_incl["CosThetaStar_CS"])
        elif var == "CosThetaStar_gg":
            df_incl["CosThetaStar_gg"] = np.abs(df_incl["CosThetaStar_gg"])
        elif var == "CosThetaStar_jj":
            df_incl["CosThetaStar_jj"] = np.abs(df_incl["CosThetaStar_jj"])
        elif var == "sublead_eta":
            df_incl["sublead_eta"] = np.abs(df_incl["sublead_eta"])
        elif var == "lead_bjet_eta":
            df_incl["lead_bjet_eta"] = np.abs(df_incl["lead_bjet_eta"])
        elif var == "sublead_bjet_eta":
            df_incl["sublead_bjet_eta"] = np.abs(df_incl["sublead_bjet_eta"])
        elif var == "gg_pT_OverHHcand_mass":
            df_incl["gg_pT_OverHHcand_mass"] = (
                df_incl["pt"] / df_incl["HHbbggCandidate_mass"]
            )
        elif var == "jj_pT_OverHHcand_mass":
            df_incl["jj_pT_OverHHcand_mass"] = (
                df_incl["dijet_pt"] / df_incl["HHbbggCandidate_mass"]
            )
        elif var == "lead_g_pT_OverHggcand_mass":
            df_incl["lead_g_pT_OverHggcand_mass"] = (
                df_incl["lead_pt"] / df_incl["mass"]
            )
        elif var == "lead_j_pT_OverHbbcand_mass":
            df_incl["lead_j_pT_OverHbbcand_mass"] = (
                df_incl["lead_bjet_pt"] / df_incl["dijet_mass"]
            )
        elif var == "sublead_g_pT_OverHggcand_mass":
            df_incl["sublead_g_pT_OverHggcand_mass"] = (
                df_incl["sublead_pt"] / df_incl["mass"]
            )
        elif var == "sublead_j_pT_OverHbbcand_mass":
            df_incl["sublead_j_pT_OverHbbcand_mass"] = (
                df_incl["sublead_bjet_pt"] / df_incl["dijet_mass"]
            )
        else:
            raise ValueError(f"Missing variable '{var}' is not recognized or cannot be computed.")
        
        print(f"Variable '{var}' added successfully.")

# Set the output column name for predictions
output_column_name = args.column_name if args.column_name else "new_model"

print("Making predictions...")
prediction = model.predict(df_incl[input_variables])
df_incl[output_column_name] = prediction
print(f"Predictions added to column: '{output_column_name}'")

if args.pq_file_output:
    df_incl.to_parquet(args.pq_file_output+'.parquet', index=False)
    print(f"Output file saved as: {args.pq_file_output}.parquet")

# Visualization
list_samples = df_incl["sample"].unique()
nodata = [sample for sample in list_samples if "Data" not in sample]

fig, ax = plt.subplots(figsize=(10, 10))
hep.style.use("CMS")
hep.cms.label("Preliminary", data=True, lumi=22, year=2022)

for sample in nodata:
    plt.hist(
        df_incl.loc[df_incl["sample"] == sample][output_column_name],
        label=f"{sample} {output_column_name}",
        histtype="step",
        weights=df_incl.loc[df_incl["sample"] == sample]["weight_tot"],
        bins=20,
        range=(0, 1),
        linewidth=2,
        density=True,
    )

plt.legend()
plt.show()
