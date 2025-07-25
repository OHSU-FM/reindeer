import os
import time
import sys
import glob
import google.generativeai as genai
from dotenv import load_dotenv

#loading config/.env file for api keys
load_dotenv()

# Configure the API key (using environment variable)
#api_key = os.environ["GEMINI_API_KEY"]
#print("api_key: " + api_key)
#genai.configure(api_key=os.environ["GEMINI_API_KEY"])
#model='gemini-2.0-flash-lite'  --> works!

def get_ai(content):
    model = genai.GenerativeModel('gemini-2.5-flash-preview-04-17')
    response = model.generate_content(content)
    return response.text

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=GOOGLE_API_KEY)

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
print ("Google AI Model: " + "gemini-2.5-flash-preview-04-17")
#if data_path == "":
#  exit()
current_path = os.getcwd()
print ("current_path: " + current_path)

for file in glob.glob(input_path):
  print(file)
  inputFile = file
  with open(inputFile, 'r') as file:
      content = file.read()
      with open(output_path, "w") as file:
          file.write("------------------------------------------------\n")
          file.write("Google Model: Gemini-2.5-flash\n")
          file.write
          file.write("AI Responses: \n")
          #response = "Calling AI has not been activated!!"
          response = get_ai(content)
          file.write(response)
          file.close()
