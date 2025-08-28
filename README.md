# Docker Nginx 範例

這是一個完整的 Docker Nginx 範例，包含自定義配置和優化設定。

## 📁 專案結構

```
nginx/
├── Dockerfile              # Docker 映像建構檔案4. 重新建構並啟動容器
├── .dockerignore # Docker 忽略檔案
├── conf/
│ └── nginx.conf # Nginx 自定義配置檔案
├── html/
│ ├── index.html # 主頁面
│ └── 50x.html # 錯誤頁面
└── README.md # 說明文件

```

## 🔄 反向代理配置

此 Nginx 設定已配置為反向代理，將所有請求轉發到後端服務的 8888 埠。

### 後端服務位置

- **宿主機服務**: 使用 `host.docker.internal:8888`
- **Docker 容器服務**: 修改 nginx.conf 中的 `proxy_pass` 為容器名稱，例如 `backend:8888`

### 支援的功能

- HTTP/HTTPS 請求轉發
- WebSocket 連接支援
- 自動故障轉移
- 適當的代理標頭設定

### 修改後端位置

編輯 `conf/nginx.conf` 檔案中的 `proxy_pass` 指令：

```nginx
# 宿主機服務
proxy_pass http://host.docker.internal:8888;

# Docker 容器服務
proxy_pass http://backend-container:8888;

# 其他伺服器
proxy_pass http://192.168.1.100:8888;
```

## 🛠️ 自定義設定 ─ docker-compose.yml # Docker Compose 配置

## 🚀 快速開始

### 方法一：使用 Docker Compose（推薦）

```bash
# 建構並啟動容器
docker-compose up -d

# 查看容器狀態
docker-compose ps

# 查看日誌
docker-compose logs -f nginx

# 停止容器
docker-compose down
```

### 方法二：使用 Docker 指令

```bash
# 建構映像
docker build -t custom-nginx .

# 運行容器
docker run -d \
  --name custom-nginx \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/html:/usr/share/nginx/html:ro \
  -v $(pwd)/cert.pem:/etc/ssl/certs/nginx.crt:ro \
  -v $(pwd)/key.pem:/etc/ssl/private/nginx.key:ro \
  custom-nginx

# 查看運行中的容器
docker ps

# 停止並移除容器
docker stop custom-nginx
docker rm custom-nginx
```

## 🌐 存取網站

啟動後，您可以透過以下網址存取網站：

- **HTTP (自動重新導向)**: http://oj.zre.tw
- **HTTPS**: https://oj.zre.tw
- **健康檢查 (HTTP)**: http://oj.zre.tw/health
- **健康檢查 (HTTPS)**: https://oj.zre.tw/health

**注意**: 由於使用自簽名憑證，瀏覽器會顯示安全警告，請點擊「繼續前往」或「進階 > 繼續前往 oj.zre.tw」。

**重要**: 使用標準埠 80 和 443 需要管理員權限：

- Linux/macOS: 使用 `sudo docker-compose up -d` 或將使用者加入 docker 群組
- Windows: 以管理員身分執行 Docker Desktop

## 📊 功能特色

### Docker 映像特色

- 基於 `nginx:alpine` - 輕量化映像
- 自定義 Nginx 配置
- 健康檢查機制
- 安全權限設定

### Nginx 配置特色

- 效能優化（gzip 壓縮、sendfile 等）
- **HTTPS 支援與 SSL/TLS 安全配置**
- **HTTP 自動重新導向到 HTTPS**
- **反向代理轉發到後端服務 (8888 埠)**
- **WebSocket 支援**
- 安全標頭設定（包含 HSTS）
- 自動 worker 程序配置
- 靜態資源快取
- 健康檢查端點

### 網頁特色

- 響應式設計
- 中文界面
- 現代化 CSS 樣式
- 容器資訊顯示

## � SSL 憑證管理

### 使用現有憑證

專案已包含 `cert.pem` 和 `key.pem` 檔案。如需更新憑證，請替換這些檔案並重新建構容器。

### 產生新的自簽名憑證（測試用）

```bash
# 產生新的自簽名憑證
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout key.pem -out cert.pem \
  -subj "/C=TW/ST=Taiwan/L=Taipei/O=Example/OU=IT/CN=oj.zre.tw"

# 檢查憑證內容
openssl x509 -in cert.pem -text -noout
```

### 使用正式憑證

如需使用正式的 SSL 憑證（如 Let's Encrypt），請：

1. 將憑證檔案替換為 `cert.pem`
2. 將私鑰檔案替換為 `key.pem`
3. 確保檔案格式為 PEM
4. 重新建構並啟動容器

## �🛠️ 自定義設定

### 修改網頁內容

編輯 `html/` 目錄下的檔案，重新建構映像或使用 volume 掛載即時預覽。

### 修改 Nginx 配置

編輯 `conf/nginx.conf` 檔案，調整伺服器設定。

### 環境變數

您可以在 `docker-compose.yml` 中設定以下環境變數：

- `NGINX_HOST`: 伺服器主機名
- `NGINX_PORT`: 伺服器埠號

## 📋 常用指令

```bash
# 查看容器日誌
docker-compose logs nginx

# 進入容器內部
docker-compose exec nginx sh

# 重新載入 Nginx 配置
docker-compose exec nginx nginx -s reload

# 測試 Nginx 配置
docker-compose exec nginx nginx -t

# 查看 Nginx 版本
docker-compose exec nginx nginx -v
```

## 🔍 故障排除

### 檢查容器狀態

```bash
docker-compose ps
```

### 查看詳細日誌

```bash
docker-compose logs --tail=50 nginx
```

### 測試配置檔案

```bash
docker-compose exec nginx nginx -t
```

### 檢查埠號佔用

```bash
# Linux/macOS
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443

# Windows
netstat -an | findstr :80
netstat -an | findstr :443
```

## 📚 相關資源

- [Nginx 官方文件](http://nginx.org/en/docs/)
- [Docker 官方文件](https://docs.docker.com/)
- [Docker Compose 文件](https://docs.docker.com/compose/)

## 📄 授權

此專案僅供學習和測試用途。

---

**享受使用 Docker Nginx！** 🐳
