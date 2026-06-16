FROM node:20-alpine
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build
RUN npm prune --production
EXPOSE 8080
CMD ["node", "dist/main.js"]
