# 使用官方 Nginx 基礎映像
FROM nginx:alpine

# 建立者資訊
LABEL maintainer="your-email@example.com"
LABEL description="Custom Nginx Docker container"

# 移除預設的 nginx 配置檔案
RUN rm /etc/nginx/conf.d/default.conf

# 複製自定義的 nginx 配置檔案
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 複製網站內容到 nginx 預設目錄
COPY html/ /usr/share/nginx/html/

# 建立必要的目錄
RUN mkdir -p /var/log/nginx /etc/ssl/certs /etc/ssl/private

# 設定正確的權限
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# 暴露 80 和 443 埠
EXPOSE 80 443

# 健康檢查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# 啟動 nginx (前景模式)
CMD ["nginx", "-g", "daemon off;"]