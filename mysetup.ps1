# --- SETUP FOLDER STRUCTURE ---
$dirs = @(
  "config", "data/cache", "data/embeddings", "data/outputs", "data/prompts",
  "examples", "infra/docker", "infra/kubeflow", "infra/lambda", "infra/terraform",
  "monitoring/langsmith", "notebooks", "src/base", "src/handlers", "src/prompt_engineering", "src/utils",
  "tests", ".github/workflows"
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ }

# --- GITIGNORE ---
@(
  "__pycache__/", ".venv/", "*.pyc", "*.ipynb_checkpoints/", ".DS_Store",
  "env/", "venv/", "*.egg-info/", ".env", "project_init.ps1"
) | Set-Content .gitignore

# --- BASE FILES ---
New-Item -ItemType File -Force -Path "Dockerfile", "requirements.txt", "setup.py", "README.md"
New-Item -ItemType File -Force -Path "config/aws_secrets.yaml", "config/langchain_config.yaml", "config/logging_config.yaml", "config/model_config.yaml"

# --- PYTHON VENV & INSTALL ---
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install langchain langchain-community pytest
pip freeze | Set-Content requirements.txt

# --- QUICK LANGCHAIN EXAMPLE ---
$quickTest = @"
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_community.llms.fake import FakeListLLM
from langchain_core.runnables import RunnableSequence

llm = FakeListLLM(responses=["LangChain helps build LLM-powered apps."])
prompt = PromptTemplate.from_template("What is LangChain?")
parser = StrOutputParser()
chain: RunnableSequence = prompt | llm | parser

response = chain.invoke({})
print("Response:", response)
"@
$quickTest | Set-Content "examples/quick_test.py"

# --- SAMPLE TEST FILE ---
"def test_dummy():`n    assert 1 + 1 == 2" | Set-Content "tests/test_sample.py"

# --- GITHUB ACTIONS CI FILE ---
$workflow = @"
name: Run Pytest

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.10'
    - name: Install dependencies
      run: |
        python -m venv .venv
        source .venv/bin/activate
        pip install -r requirements.txt
    - name: Run Tests
      run: |
        source .venv/bin/activate
        pytest tests
"@
$workflow | Set-Content ".github/workflows/python-tests.yml"

# --- RUN EXAMPLE ---
python examples/quick_test.py
