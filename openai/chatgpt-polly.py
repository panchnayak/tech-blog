#!/opt/anaconda3/bin/python3

from boto3 import Session
from botocore.exceptions import BotoCoreError, ClientError
from contextlib import closing
import os
import sys
import subprocess
import openai
from tempfile import gettempdir

session = Session(profile_name="tdash")
polly = session.client("polly")
openai.api_key = os.environ.get('OPENAI_API_KEY')
model_engine = "text-davinci-003"

while 'true':
    question = input("Ask Me Anything : ")
    completion = openai.Completion.create(
        engine=model_engine,
        prompt=question,
        max_tokens=1024,
        n=1,
        stop=None,
        temperature=0.5,
    )
    response = completion.choices[0].text
    print(response)

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