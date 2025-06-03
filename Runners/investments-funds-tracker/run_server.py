from http.server import HTTPServer
from api.index import handler  # Import the handler from index.py

server_address = ('', 8000)  # You can change 8000 to another port if needed
httpd = HTTPServer(server_address, handler)
print("Server started on port 8000...")
httpd.serve_forever()
