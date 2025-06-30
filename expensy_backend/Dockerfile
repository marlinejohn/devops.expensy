FROM node:18

# Create app directory
WORKDIR /app

# Copy package files and install
COPY package*.json ./
RUN npm install

# Copy the rest of your app
COPY . .

# Expose the backend port
EXPOSE 8706

# Start the app
CMD [ "npm", "run", "dev" ]
