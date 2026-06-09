from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests
import json
import re

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class Input(BaseModel):
    name: str
    interests: str
    situation: str
    decision: str
    details: str


def extract_json(text):
    match = re.search(r"\[.*\]", text, re.S)
    if match:
        try:
            return json.loads(match.group())
        except:
            return None
    return None


@app.post("/api/generate")
def generate(data: Input):

    prompt = f"""
Return ONLY valid JSON array of 3 universes.

Each object:
number, title, subtitle, description, careerPath,
keyEvents (4 items), outcome, regrets, advice.

User:
Name: {data.name}
Interests: {data.interests}
Situation: {data.situation}
Decision: {data.decision}
Details: {data.details}
"""

    r = requests.post(
        "http://ollama:11434/api/generate",
        json={
            "model": "qwen3:8b",
            "prompt": prompt,
            "stream": False
        }
    )

    text = r.json()["response"]

    result = extract_json(text)

    if result:
        return result

    return [{
        "number": 1,
        "title": "Fallback Universe",
        "subtitle": "System Safe Mode",
        "description": "AI returned invalid JSON but system recovered.",
        "careerPath": "Unknown",
        "keyEvents": ["Retry generation"],
        "outcome": "Try again",
        "regrets": "",
        "advice": "Retry"
    }]
