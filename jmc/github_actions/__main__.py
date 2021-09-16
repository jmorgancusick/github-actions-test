import http.server
import socketserver

def run(port=8080, handler=http.server.SimpleHTTPRequestHandler):
    with socketserver.TCPServer(("", port), handler) as httpd:
        print("serving at port", port)
        httpd.serve_forever()

def main():
    run()

if __name__ == '__main__':
    main()