import requests
from bs4 import BeautifulSoup
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()(__name__)

def get_aws_resource_types():
    url = "https://docs.aws.amazon.com/ARG/latest/userguide/supported-resources.html"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        
        resource_types = set()
        tables = soup.find_all('table')
        
        for table in tables:
            # Skip header row
            for row in table.find_all('tr')[1:]:
                cols = row.find_all('td')
                if cols and len(cols) >= 1:
                    resource_type = cols[0].get_text(strip=True)
                    if resource_type and not resource_type.isspace():
                        resource_types.add(resource_type)
                        
        if not resource_types:
            logger.warn("Warning: No resources found. The page structure might have changed.")
            
        return sorted(list(resource_types))
    except Exception as e:
        logger.error(f"Error fetching resource types: {e}")
        return []

def lambda_handler(event, context):
    resources = get_aws_resource_types()
    logger.info(event)
