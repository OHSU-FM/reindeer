import os
import time
import sys
import glob
import google.generativeai as genai

# Configure the API key (using environment variable)
#api_key = os.environ["GEMINI_API_KEY"]
#print("api_key: " + api_key)

#genai.configure(api_key=os.environ["GEMINI_API_KEY"])
genai.configure(api_key='AIzaSyD4_5IEnp9j_ZL08D-45eBF92SrJiLR5-g')

#model='gemini-2.0-flash-lite'  --> works!

def get_ai(content):
    model = genai.GenerativeModel('gemini-2.5-flash-preview-04-17')
    response = model.generate_content(content)
    return response.text

data_path = sys.argv[1]
print ()"Google AI Model: " + gemini-2.5-flash-preview-04-17')
print ("DataPath: " + data_path)

#if data_path == "":
#  exit()
current_path = os.getcwd()
print ("current_path: " + current_path)

for file in glob.glob(data_path):
  print(file)
  inputFile = file
  with open(inputFile, 'r') as file:
      content = file.read()
      with open(inputFile, "a") as file:
          file.write("------------------------------------------------\n")
          file.write("Google Model: Gemini-2.5-flash\n")
          file.write
          file.write("AI Responses: \n")
          response = "Calling AI has not been activated!!"
          #response = get_ai(content)
          file.write(response)
          file.close()
          time.sleep(3)
