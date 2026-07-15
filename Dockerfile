FROM nginx:1.29.0-bookworm
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
