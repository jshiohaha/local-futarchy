# #!/bin/bash

# # Load environment variables from .env file
# source .env

# # Check if the JSON file path is provided as an argument
# if [ $# -eq 0 ]; then
#   echo "Please provide the path to the JSON config file as an argument."
#   exit 0
# fi

# # Check if the CLUSTER_URL environment variable is set
# if [ -z "$CLUSTER_URL" ]; then
#   echo "Missing \"CLUSTER_URL\" environment variable"
#   exit 0
# fi

# echo "CLUSTER_URL = $CLUSTER_URL"

# # Read the JSON config file
# config_file="$1"
# config_data=$(cat "$config_file")

# # Extract the array of objects from the JSON data
# program_data=$(echo "$config_data" | jq -r '.program_data')

# echo "program_data = $program_data"

# # Iterate over each object in the array
# echo "$program_data" | jq -c '.[]' | while read -r program; do
#   program_id=$(echo "$program" | jq -r '.program_id')
#   program_name=$(echo "$program" | jq -r '.program_name')

#   # Process the program data
#   echo "Processing program: $program_name (ID: $program_id)"
#   echo "Cluster URL: $CLUSTER_URL"
#   # Add your specific processing logic here
# done

#!/bin/bash

# Load environment variables from .env file
source .env

# Path to the JSON configuration file
CONFIG_FILE="config.json"

# Ensure jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, please install it to proceed."
    exit 1
fi

# Ensure the JSON configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Read CLUSTER_URL from the environment variables
CLUSTER_URL="${CLUSTER_URL}"
if [ -z "$CLUSTER_URL" ]; then
    echo "CLUSTER_URL environment variable is not set."
    exit 1
fi

echo "CLUSTER_URL = $CLUSTER_URL"

# Loop through each item in the JSON array directly and print details
jq -c '.[]' $CONFIG_FILE | while read i; do
    program_id=$(echo $i | jq -r '.program_id')
    program_name=$(echo $i | jq -r '.program_name')
    formatted_filename_base=$(echo "$program_name" | awk '{print tolower($0)}' | tr ' ' '_')
    output_filepath=$(echo "./binaries/$formatted_filename_base.so")

    echo "[Cluster = $CLUSTER_URL] Dumping binary for program $program_name (id = $program_id) to file: $output_filepath"
    solana program dump --url $CLUSTER_URL $program_id $output_filepath
done