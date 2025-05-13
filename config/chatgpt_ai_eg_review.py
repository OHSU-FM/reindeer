import os
import time
import sys
import glob
import openai

def get_completion(openai, model, prompt):
  messages = [{"role": "user", "content": prompt}]
  response = openai.chat.completions.create(
    model=model,
    messages=messages,
    temperature=0,
  )
  return response.choices[0].message.content

#openai.api_key = os.environ.get("OPENAI_API_KEY")
model = 'gpt-4.1-nano'
current_path = os.getcwd()

data_path = sys.argv[1]
print ("ChatGPT AI Model: " + model)
print ("DataPath: " + data_path)
print ("CurrentPath: " + current_path)

for file in glob.glob(data_path):
  print(file)
  inputFile = file
  with open(inputFile, 'r') as file:
    prompt = file.read()
    with open(inputFile, "a") as file:
        file.write("------------------------------------------------\n")
        file.write("ChatGPT Model: " + model + "\n")
        file.write
        file.write("AI Responses: \n")
        #response = "ChatGPT is NOT activated!"
        response = get_completion(openai, model, prompt)
        file.write(response)
        file.close()
        #time.sleep(1)
