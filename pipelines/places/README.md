# Function – Park data

## Local development

Create a virtual environment, enable it and install the dependencies
```sh
virtualenv --python python3.8 venv
source venv/bin/activate
pip install --requirement requirements.txt
```

## Dataflow

Requirements
* Login: `gcloud auth login`

Run it
```sh
make dataflow-run
```
