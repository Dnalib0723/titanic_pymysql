# 建立 API backend image
FROM python:3.10-slim AS backend

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api_app.py .

# 建立 Nginx 靜態頁 image
FROM nginx:alpine AS frontend

# 複製 nginx 設定
COPY nginx.conf /etc/nginx/nginx.conf

# 複製前端靜態檔案
COPY index.html /usr/share/nginx/html/index.html
COPY script.js /usr/share/nginx/html/script.js

# 最終映像（Multi-stage）
FROM python:3.10-slim

WORKDIR /app

# 複製 API 內容
COPY --from=backend /app /app

# 複製前端內容到 nginx 預設目錄
COPY --from=frontend /usr/share/nginx/html /usr/share/nginx/html
COPY --from=frontend /etc/nginx /etc/nginx

RUN pip install --no-cache-dir flask pymysql

# 執行 flask 與 nginx（需額外 supervisord 才能同時執行，建議拆 container）
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
