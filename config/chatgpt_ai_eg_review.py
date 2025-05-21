import os
import time
import sys
import glob
import openai
from dotenv import load_dotenv

load_dotenv()

def get_completion(model, prompt):
  messages = [{"role": "user", "content": prompt}]
  response = openai.chat.completions.create(
    model=model,
    messages=messages,
    temperature=0,
  )
  return response.choices[0].message.content


API_KEY = os.getenv("OPENAI_API_KEY")
openai.api_key = API_KEY

model = 'gpt-4.1-nano'
current_path = os.getcwd()

data_path = sys.argv[1]
full_name = sys.argv[2]
aiOption = sys.argv[3]

input_path = data_path + "/ai_data_input/" + full_name + "_ai.txt"
output_path = data_path + "/" + aiOption + "_ai_data/" + full_name + "_ai.txt"

print ("DataPath: " + data_path)
print ("FullName: " + full_name)
print ("AI Option: " + aiOption)
print ("input_path: " + input_path)
print ("output_path: " + output_path)


for file in glob.glob(input_path):
  print(file)
  inputFile = file
  with open(inputFile, 'r') as file:
    prompt = file.read()
    with open(output_path, "w") as file:
        file.write("------------------------------------------------\n")
        file.write("ChatGPT Model: " + model + "\n")
        file.write
        file.write("AI Responses: \n")
        response = "ChatGPT is NOT activated!"
        #response = get_completion(model, prompt)
        file.write(response)
        file.close()
        #time.sleep(1)
