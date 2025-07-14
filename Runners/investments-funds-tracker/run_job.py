# run_cron_job_via_http.py
import subprocess
import time
import requests
import sys
import os

SERVER_HOST = '127.0.0.1'
SERVER_PORT = 8008
SERVER_URL = f"http://{SERVER_HOST}:{SERVER_PORT}/"

RUN_SERVER_SCRIPT = './run_server.py'

def run_job():
    server_process = None
    try:
        print(f"Starting server in background: python {RUN_SERVER_SCRIPT}")

        server_process = subprocess.Popen([sys.executable, RUN_SERVER_SCRIPT],
                                          stdout=subprocess.PIPE,
                                          stderr=subprocess.PIPE,
                                          text=True)


        time.sleep(5)

        print(f"Making GET request to {SERVER_URL}")
        response = requests.get(SERVER_URL, timeout=50)

        print(f"Server Response Status: {response.status_code}")
        print(f"Server Response Body (first 500 chars): {response.text[:500]}")

        if response.status_code == 200:
            print("Job completed successfully via HTTP request.")
            return 0 # Success
        else:
            print(f"Job failed with status code {response.status_code}. Error: {response.text}")
            return 1 # Failure

    except requests.exceptions.Timeout:
        print(f"HTTP request timed out. Ensure the workflow timeout is sufficient for index.py's execution.")
        return 1
    except requests.exceptions.ConnectionError as e:
        print(f"Failed to connect to server at {SERVER_URL}. Is it running? Error: {e}")
        return 1
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return 1
    finally:
        if server_process:
            print("Terminating server process...")
            server_process.terminate() # Send SIGTERM
            try:
                server_process.wait(timeout=5) # Wait for it to terminate gracefully
            except subprocess.TimeoutExpired:
                print("Server did not terminate gracefully, killing it.")
                server_process.kill() # Force kill if not terminated
            stdout, stderr = server_process.communicate()
            if stdout:
                print("Server stdout:\n", stdout)
            if stderr:
                print("Server stderr:\n", stderr)

if __name__ == "__main__":
    exit_code = run_job()
    sys.exit(exit_code)
