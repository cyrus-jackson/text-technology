import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

class ChangeHandler(FileSystemEventHandler):
    def __init__(self, restart_function):
        self.restart_function = restart_function

    def on_any_event(self, event):
        if event.src_path.endswith(".py"):
            print(f"Detected change in {event.src_path}. Restarting server...")
            self.restart_function()

def start_server():
    return subprocess.Popen(["python", "run_server.py"])

def watch():
    process = start_server()

    def restart_server():
        nonlocal process  # Allows us to modify the process variable from the outer scope
        process.terminate()
        time.sleep(1)  # Give the OS a moment to release the port
        process = start_server()

    event_handler = ChangeHandler(restart_server)
    observer = Observer()
    observer.schedule(event_handler, path=".", recursive=True)
    observer.start()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    finally:
        process.terminate()  # Ensure the server process is terminated on exit
    observer.join()

if __name__ == "__main__":
    watch()
