import os
from dotenv import load_dotenv
 
# Load environment variables from .env file
load_dotenv()

# Run dbt command
os.system('dbt debug')