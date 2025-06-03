import json
import enum

import google.generativeai as genai
import typing_extensions as typing

from utils.config import GEMINI_KEY


genai.configure(api_key=GEMINI_KEY)

class FUNDING_STATUS(enum.Enum):
    Potential = "Potential"
    Allocated = "Allocated"
    Planned = "Planned"
    Undefined = "Undefined"

class Investment(typing.TypedDict):
    Link: str
    Place: list[str]
    News_Article_Date: str
    Amount: int
    JobsCount: int
    funding_related: bool
    funding_status: FUNDING_STATUS
    notes: str
    needs_verification: bool
    summary: str


def get_investment_info(link):
    model = genai.GenerativeModel("gemini-2.0-flash-001")
    try:
        result = model.generate_content(
            "Using the Link, please fill the data in this format in JSON mode. Only do this if the news article has information about investments or funding related news about only Germany. Handle the error case with the variable funding_related in JSON that it is not funding related. Also, handle the plan to fund article with right variable(Potential, Allocated, Planned, Undefined). If there is no mention of investment amount then mention Amount as 0. If there is no mention of jobs count, then mention JobsCount as 0. If any of the variables are not clear such as investment is not part of Germany, mention it in a variable notes and that it needs verification in needs_verification (boolean) and add a short summary of about 40 characters. Link:"+link,
            generation_config=genai.GenerationConfig(
                response_mime_type="application/json",
                response_schema=Investment  # Correct schema according to the library's expectation
            ),
        )
    except Exception as e:
        print(f"Error generating content: {e}")
        return None

    # Convert response to dict safely
    result_dict = result.to_dict() if hasattr(result, "to_dict") else result.__dict__

    try:
        # Check if the expected structure exists
        candidates = result_dict.get("candidates")
        if not candidates or not candidates[0].get("content") or not candidates[0]["content"].get("parts"):
            print("Invalid structure in response")
            return None
        
        # Extract inner JSON from the response part
        inner_json_str = candidates[0]["content"]["parts"][0].get("text")
        if not inner_json_str:
            print("No text content found in response")
            return None
        
        # Parse the JSON string
        inner_data = json.loads(inner_json_str)

    except (json.JSONDecodeError, KeyError, IndexError) as e:
        print(f"Error parsing response JSON: {e}")
        return None

    print("Parsed investment data:", inner_data)
    return inner_data