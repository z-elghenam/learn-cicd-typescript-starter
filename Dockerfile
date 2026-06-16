# Use official Node.js image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY src ./src
COPY tsconfig.json ./
COPY public ./public 2>/dev/null || true

# Build the TypeScript code
RUN npm run build

# Remove dev dependencies to keep image small
RUN npm prune --production

# Expose port
EXPOSE 8080

# Start the application
CMD ["node", "dist/main.js"]
