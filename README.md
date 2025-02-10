The macro `model_reader.py` evaluates and applies a model to an existing pq files.
It takes the following arguments:
* model: model directory in which there's a .keras file which is the model + .yml file with the input variables
* pq_file: parquet file name and path
* column_name: this is optional, is the name of the column with the new model, if not specified the new model will be called 'new_model'
* pq_file_output: this is optional, if specified it will save the output in a new pq file

Two bash codes were added to run on trainings having or not the mbb and mva IDs as features.
Firstly run the VH prediction model:
`predict_VH_score.sh`
`predict_VH_score_nombb.sh`
Then the Single Higgs one:
`bash predict_SingleHiggsScore.sh`
`bash predict_SingleHiggsScore_nombb.sh`

Here I'm adding the versions of the different packages needed to run the macro:
* yaml: 6.0.2
* tensorflow: 2.16.1
* pandas: 2.2.3
* pyarrow: 18.1.0
* python: 3.12.8

###For v2 SingleH and VH DNNs
In order to run the SingleH DNN in v2, the VH DNN must first be run, with the scores added as input for the SingleH DNN. Depending on if you are running with(out) the mvaIDs or mbb as inputs, the hyperparameters and training variables yaml files will be inaccurate. All that would need to change is (un)commenting those variables in variables_train*.yaml and the n_input entry in hps*.yaml. 
