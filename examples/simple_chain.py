import os
from dotenv import load_dotenv

from langchain.chat_models import ChatOpenAI  # updated import for chat models
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain

# Load environment variables from .env file
load_dotenv()

# Get the OpenAI API key from the environment
api_key = os.getenv("OPENAI_API_KEY")

# Initialize the ChatOpenAI LLM with API key
llm = ChatOpenAI(
    model_name="gpt-3.5-turbo",
    openai_api_key=api_key,
    temperature=0.7  # optional: adjust creativity
)

# Define a prompt template
prompt_template = PromptTemplate(
    input_variables=["topic"],
    template="Write a short essay about {topic}."
)

# Create the chain
chain = LLMChain(llm=llm, prompt=prompt_template)

# Run the chain
output = chain.run({"topic": "machine learning operations"})
print(output)
