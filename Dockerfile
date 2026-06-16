# Use official Node.js image (use a newer version)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the TypeScript code
RUN npm run build

# Remove dev dependencies to keep image small
RUN npm prune --production

# Expose port
EXPOSE 8080

# Start the application
CMD ["node", "dist/main.js"]