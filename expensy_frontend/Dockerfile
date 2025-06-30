# 1. Use the official Node.js image
FROM node:18-alpine

# 2. Set working directory
WORKDIR /app

# 3. Install dependencies
COPY package.json package-lock.json* ./
RUN npm install

# 4. Copy app source code
COPY . .

# 5. Set environment variable (build-time default)
ENV NEXT_PUBLIC_API_URL=http://localhost:8706

# 6. Build the Next.js app
RUN npm run build

# 7. Expose app port
EXPOSE 3000

# 8. Run the app
CMD ["npm", "start"]
