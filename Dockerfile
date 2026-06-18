FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code and config files
COPY src ./src
COPY tsconfig.json ./

# Build the TypeScript code
RUN npm run build

# Remove dev dependencies
RUN npm prune --production

EXPOSE 8080

# Run with ES modules
CMD ["node", "dist/main.js"]
