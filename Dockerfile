FROM ubuntu:20.04

# Inštalácia všetkých potrebných knižníc
RUN apt-get update && apt-get install -y \
    python3 \
    libfontconfig1 \
    libfreetype6 \
    libx11-6 \
    libxcursor1 \
    libxinerama1 \
    libxrandr2 \
    libxi6 \
    libgl1-mesa-glx \
    libasound2 \
    libpulse0 \
    && rm -rf /var/lib/apt/lists/*

COPY builds/server/ /app/
WORKDIR /app

RUN chmod +x minimal_server.x86_64

# HTTP server pre Railway health check
RUN echo 'import http.server\nimport socketserver\nimport threading\nimport subprocess\nimport os\n\ndef start_http_server():\n    PORT = int(os.environ.get("PORT", 3000))\n    Handler = http.server.SimpleHTTPRequestHandler\n    with socketserver.TCPServer(("", PORT), Handler) as httpd:\n        print(f"HTTP server running on port {PORT}")\n        httpd.serve_forever()\n\ndef start_game_server():\n    subprocess.run(["./minimal_server.x86_64", "--headless"])\n\nif __name__ == "__main__":\n    http_thread = threading.Thread(target=start_http_server)\n    http_thread.daemon = True\n    http_thread.start()\n    start_game_server()' > start_server.py

EXPOSE 3000
EXPOSE 10000

CMD ["python3", "start_server.py"]
