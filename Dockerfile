# Use an appropriate base image for your application 
# For a Node.js API
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application's code to the working directory
COPY . .

# Expose the port that your application listens on 
EXPOSE 3000

# Define environment variables using the correct syntax
ENV NODE_ENV=production

# Command to start your application
CMD ["npm", "start"]
