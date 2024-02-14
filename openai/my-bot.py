#!/opt/anaconda3/bin/python3

import speech_recognition as sr
import pyttsx3
import openai
from boto3 import Session
from botocore.exceptions import BotoCoreError, ClientError
from contextlib import closing
import sys
import os
import subprocess
import time
from tempfile import gettempdir

session = Session(profile_name="tdash")
polly = session.client("polly")
openai.api_key = os.environ.get('OPENAI_API_KEY')
model_engine = "text-davinci-003"

def Text2Speach(response):
    try:
        response = polly.synthesize_speech(Text=response, OutputFormat="mp3", Engine="neural", VoiceId="Stephen")

    except (BotoCoreError, ClientError) as error:
    # The service returned an error, exit gracefully
        print(error)
        sys.exit(-1)
    if "AudioStream" in response:

        with closing(response["AudioStream"]) as stream:
           output = os.path.join(gettempdir(), "speech.mp3")

           try:
                with open(output, "wb") as file:
                   file.write(stream.read())
           except IOError as error:
              print(error)
              sys.exit(-1)

    else:
        print("Could not stream audio")
   
        sys.exit(-1)

    if sys.platform == "win32":
        os.startfile(output)
    
    else:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.call([opener, output])
        
def CaptureVoice(r):
    try:
        # use the microphone as source for input.
            with sr.Microphone() as source2:
                # wait for a second to let the recognizer
                # adjust the energy threshold based on
                # the surrounding noise level
                r.adjust_for_ambient_noise(source2, duration=0.2)
                #listens for the user's input
                audio2 = r.listen(source2)
                # Using google to recognize audio
                question = r.recognize_google(audio2)
                # question = question.lower()
                print("Did you ask ",question)
                return question
    
    except sr.RequestError as e:
            print("Could not request results; {0}".format(e))
            return None
         
    except sr.UnknownValueError:
            print("unknown error occurred")
            return None

Text2Speach("Hi,I am Bhrajishnu, Ask me Anything")
time.sleep(2)
while(1):
    r = None 
    question = None
    r = sr.Recognizer()
    question = CaptureVoice(r)
    if question != None:
        completion = openai.Completion.create(engine=model_engine,prompt=question,max_tokens=1024,n=1,stop=None,temperature=0.5,)
        response = completion.choices[0].text
        Text2Speach(response)
        response = None
        time.sleep(2)
     
     
       
    
   
           
            
    