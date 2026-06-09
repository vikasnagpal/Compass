import http.server, os
os.chdir("/Users/vikas/Documents/Zostel/OKR_tracker")
http.server.test(HandlerClass=http.server.SimpleHTTPRequestHandler, port=5173, bind="127.0.0.1")
