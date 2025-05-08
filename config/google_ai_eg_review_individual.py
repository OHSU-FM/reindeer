import os
import time
import sys
import jellyfish
import google.generativeai as genai

# Configure the API key (using environment variable)
genai.configure(api_key=os.environ["GEMINI_API_KEY"])

#model='gemini-2.0-flash-lite'  --> works!

def get_ai(content):
    model = genai.GenerativeModel('gemini-2.5-flash-preview-04-17')
    response = model.generate_content(content)

    # Print the response
    #print(response.text)`
    return response.text

def replace_student_name(feedback, student_names):
    # Replace each student name with 'Student A'
    for name in student_names:
        feedback = feedback.replace(name, "Student A")


    return feedback


student_last_name = sys.argv[1]
print ("student LastName: " + student_last_name)
if student_last_name == "":
  exit()

current_path = os.getcwd()
print ('current_path: ' + current_path)

for files in os.listdir(current_path + "/tmp/epa_reviews/ai_data"):
  print(files)
  inputFile = os.path.join(current_path + "/tmp/epa_reviews/ai_data/", files)
  if student_last_name in inputFile:
    print("inputfile: " + inputFile)

    student_names = student_last_name.split(", ")
    student_names.append(student_names[1] + " " + student_names[0])
    print (student_names)

    with open(inputFile, 'r') as file:
        print("processing file.." + files)
        content = file.read()
        with open(inputFile, "a") as file:
            file.write("------------------------------------------------\n")
            file.write("FileName: " + files + "\n" )
            file.write("Google Model: Gemini-2.0-flash\n")
            file.write
            file.write("AI Responses: \n")
            updated_content = replace_student_name(content, student_names)
            file.write("**********************************************")
            file.write("**** new content *****************************")
            file.write(updated_content)
            #response = get_ai(updated_content)
            response = "-- Testing --"
            file.write(response)
            file.close()
            #time.sleep(2)
