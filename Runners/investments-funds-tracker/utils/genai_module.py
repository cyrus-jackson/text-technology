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
    model = genai.GenerativeModel("gemini-2.5-flash-preview-05-20")
    try:
        result = model.generate_content(
            "You are an expert at extracting and structuring information about investments and funding from news articles specifically for Germany. Your task is to analyze the provided news article link and extract relevant data into a JSON object following the specified schema. Here's the schema you must adhere to: import enum import typing class FUNDINGSTATUS(enum.Enum): Potential = \"Potential\" Allocated = \"Allocated\" Planned = \"Planned\" Undefined = \"Undefined\" class Investment(typing.TypedDict): Link: str Place: list[str] NewsArticleDate: str Amount: int JobsCount: int fundingrelated: bool fundingstatus: FUNDINGSTATUS notes: str needsverification: bool summary: str Instructions 1. Analyze the provided Link: Read the news article thoroughly. 2. Germany-Specific Focus: Only process the article if it contains information about investments or funding related to Germany. If not, set fundingrelated to false and provide a brief summary indicating why it's not relevant. 3. fundingrelated: Set to true if the article discusses investments or funding; otherwise, set to false. 4. fundingstatus: - Set to FUNDINGSTATUS.Allocated if the funding is confirmed and already provided. - Set to FUNDINGSTATUS.Planned if the article mentions a plan to fund or an upcoming investment. - Set to FUNDINGSTATUS.Potential if the funding is still under consideration or highly speculative. - Set to FUNDINGSTATUS.Undefined if the funding status is unclear or not explicitly stated. 5. Amount: - Extract any mention of investment budget or loan amounts. - If multiple amounts are mentioned and clearly distinct (e.g., different stages of funding), try to identify the most significant or latest one. If ambiguous, mention the ambiguity in notes. - If no specific amount is mentioned, set to 0. 6. JobsCount: - Extract the number of jobs created or impacted by the investment. - If no specific job count is mentioned, set to 0. 7. Place: - Identify specific German cities, regions, or states mentioned as beneficiaries or locations of the investment. Provide as a list of strings (e.g., [Berlin, Bavaria]). - If the exact place in Germany is not clear, leave it empty or indicate Germany if that's the only level of detail. 8. NewsArticleDate: Extract the publication date of the news article in YYYYMMDD format. 9. notes: Use this field for any ambiguities, clarifications, or additional context. 10. needsverification: Set to true if any crucial information like the German connection, exact amount, or specific location is unclear or needs further confirmation. Otherwise, set to false. 11. summary: Provide a concise summary of the article (approximately 250 characters long) highlighting the key investment details or the reason it's not fundingrelated. Example Input { Link: https://www.example.com/news/german-tech-startup-secures-series-a-funding } Your Turn Given the Link: "+ link +" Please provide the JSON output.",
            generation_config=genai.GenerationConfig(
                response_mime_type="application/json",
                response_schema=Investment  
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
        print(inner_data)

    except (json.JSONDecodeError, KeyError, IndexError) as e:
        print(f"Error parsing response JSON: {e}")
        return None

    print("Parsed investment data:", inner_data)
    return inner_data