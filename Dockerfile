# Use official Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY dist ./dist

# Copy public assets if they exist
COPY public ./public 2>/dev/null || true

# Expose port
EXPOSE 8080

# Start the application
CMD ["node", "dist/main.js"]
