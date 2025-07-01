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
