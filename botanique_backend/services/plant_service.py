import httpx
import os
import json
from dotenv import load_dotenv
from fastapi import HTTPException, UploadFile

load_dotenv()

PLANTNET_API_KEY = os.getenv("PLANTNET_API_KEY")
GROQ_API_KEY = os.getenv("GROQ_API_KEY")

PLANTNET_API_URL = "https://my-api.plantnet.org/v2/identify/all"
GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions"

async def fetch_plant_details(plant_name: str):
    if not GROQ_API_KEY:
        return None # Fallback to dummy if key missing

    prompt = f"""
    You are a professional botanist. Provide gardening details for the plant: '{plant_name}'.
    Return ONLY a JSON object with strictly these keys:
    - "description": a concise 2-sentence description of the plant.
    - "water": clear watering instructions.
    - "light": sunlight requirements.
    - "temperature": ideal temperature range.
    - "season": primary growth or blooming season.
    
    Response must be a single JSON object. Do not include any other text or markdown formatting like ```json.
    """

    async with httpx.AsyncClient() as client:
        try:
            print(f"Calling Groq for {plant_name} using model llama-3.3-70b-versatile...")
            response = await client.post(
                GROQ_API_URL,
                headers={
                    "Authorization": f"Bearer {GROQ_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": "llama-3.3-70b-versatile",
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": 0.1,
                    "response_format": {"type": "json_object"}
                },
                timeout=30.0
            )
            
            print(f"Groq Response Status: {response.status_code}")
            
            if response.status_code == 200:
                result = response.json()
                content = result['choices'][0]['message']['content'].strip()
                
                # Robust JSON extraction
                if "{" in content:
                    content = content[content.find("{"):content.rfind("}")+1]
                
                return json.loads(content)
            else:
                print(f"Groq API Error Detail: {response.text}")
                return None
        except Exception as e:
            print(f"Groq Service Exception: {e}")
            return None

async def identify_plant(image: UploadFile):
    print(f"Starting identification for image: {image.filename}")
    if not PLANTNET_API_KEY:
        raise HTTPException(status_code=500, detail="PlantNet API Key not configured")

    async with httpx.AsyncClient() as client:
        print("Reading image content...")
        content = await image.read()
        print(f"Image size: {len(content)} bytes")
        
        files = {'images': (image.filename, content, image.content_type)}
        params = {'api-key': PLANTNET_API_KEY}

        try:
            print("Sending request to PlantNet...")
            response = await client.post(
                PLANTNET_API_URL, 
                params=params, 
                files=files,
                timeout=30.0 # Added timeout
            )
            print(f"PlantNet response received: {response.status_code}")
            
            if response.status_code != 200:
                print(f"PlantNet Error: {response.text}")
                raise HTTPException(status_code=response.status_code, detail=f"PlantNet API error: {response.text}")
            
            data = response.json()
            results = data.get('results', [])
            if not results:
                print("No results from PlantNet")
                raise HTTPException(status_code=404, detail="No plant matches found")
            
            best_match = results[0]
            species = best_match.get('species', {})
            scientific_name = species.get('scientificNameWithoutAuthor', 'Unknown')
            common_names = species.get('commonNames', [])
            common_name = common_names[0] if common_names else scientific_name
            print(f"Identified as: {common_name} ({scientific_name})")

            # Now fetch real details from Groq
            print("Fetching details from Groq...")
            details = await fetch_plant_details(common_name)
            
            if not details:
                print("Groq failed or returned no data, using fallback")
                # Fallback dummy data if Groq fails
                details = {
                    "description": f"Standard details for {scientific_name}.",
                    "water": "Moderate",
                    "light": "Indirect light",
                    "temperature": "18-24°C",
                    "season": "Spring"
                }
            else:
                print("Groq details fetched successfully")

            return {
                "name": common_name,
                "scientific_name": scientific_name,
                **details
            }
            
        except httpx.TimeoutException:
            print("Request to PlantNet timed out")
            raise HTTPException(status_code=504, detail="PlantNet API timed out")
        except httpx.RequestError as e:
            print(f"Request Error: {str(e)}")
            raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")
        finally:
            await image.seek(0)
