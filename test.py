import requests

repo_owner = "owner"
repo_name = "repo"
url = f"https://api.github.com/repos/cesium/ares"

response = requests.get(url)
if response.status_code == 200:
    data = response.json()
    creation_date = data.get("created_at")
    print(f"Repository Creation Date: {creation_date}")
else:
    print(f"Failed to fetch repository details: {response.status_code}")
