FROM cgr.dev/chainguard/nginx@sha256:76cc70e5e8da88ae76ff585525c340fc09d54018c5c902551d61a24c2b3ac0d2

COPY index.html /usr/share/nginx/html/index.html

USER 65532

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
 CMD wget --spider -q http://localhost:8080 || exit 1
