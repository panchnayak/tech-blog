#!/opt/anaconda3/bin/python3

import openai
openai.api_key = os.environ.get('OPENAI_API_KEY')
model_engine = "text-davinci-003"

while(1):
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