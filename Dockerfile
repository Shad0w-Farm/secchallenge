# Use a specific, minimal Alpine-based Node image
FROM node:18-alpine3.18

# Set Node environment to production
ENV NODE_ENV=production

# Create a non-root user and group
RUN addgroup -S juiceshop && adduser -S juiceshop -G juiceshop

# Set working directory
WORKDIR /app

# Copy package files and install production dependencies only
COPY --chown=juiceshop:juiceshop package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Copy application source code
COPY --chown=juiceshop:juiceshop . .

# Remove unnecessary OS packages to reduce attack surface
RUN apk del apk-tools

# Switch to the non-root user
USER juiceshop

# Expose application port
EXPOSE 3000
# Run the application

CMD ["npm", "start"]
