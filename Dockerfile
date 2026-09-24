# ==========================================
# Stage 1: Pull from your Private ECR Registry
# ==========================================
FROM 584828065681.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest AS private-ecr-stage
RUN echo "Source: Private AWS ECR Registry" > /private-artifact.txt


# ==========================================
# Stage 2: Pull from a Public Registry (e.g., Nginx)
# ==========================================
FROM nginx:alpine AS public-registry-stage
RUN echo "Source: Public Docker Hub Registry" > /public-artifact.txt


# ==========================================
# Stage 3: Final Combined Image for Analysis
# ==========================================
FROM alpine:latest AS final-scan-target

# Copy artifacts from both the private and public stages into the final image
COPY --from=private-ecr-stage /private-artifact.txt /app/private-artifact.txt
COPY --from=public-registry-stage /public-artifact.txt /app/public-artifact.txt
COPY --from=public-registry-stage /usr/share/nginx/html/index.html /app/public-nginx-index.html

# Set default command to display summary
CMD ["sh", "-c", "cat /app/private-artifact.txt && cat /app/public-artifact.txt"]
