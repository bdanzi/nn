import pandas as pd

file_path = '/eos/user/b/bdanzi/Single_score_outputDir_v2_nombb/2022postEE/G-4Jets_HT-40to70_2022postEE.parquet'

df = pd.read_parquet(file_path)

print(df.head())
print(df.columns.tolist())

#if 'weight' in df.columns:
#    print(df[''].head())
#else:
#    print("Column 'singleH_score' does not exist.")
