# Use the official Node.js 18 image based on Alpine Linux 3.16 for the build stage
FROM node:18-alpine3.16 as build

# Get NPM_TOKEN from the build arguments
ARG NPM_TOKEN
# Set the NPM_TOKEN environment variable in the image
ENV NPM_TOKEN=${NPM_TOKEN}

# Set the working directory to /app
WORKDIR app

# Copy npm configuration file for private repositories
COPY ./app/.npmrc /app/.npmrc
# Copy package.json and package-lock.json to install dependencies
COPY ./app/package.json /app/package.json
COPY ./app/package-lock.json /app/package-lock.json

# Install dependencies
RUN npm install

# Use the official Node.js 18 image based on Alpine Linux 3.16 for the final stage
FROM node:18-alpine3.16 as final

# Set the working directory to /app
WORKDIR app

# Copy built modules from the build stage
COPY --from=build /app/node_modules /app/node_modules
# Copy the application code
COPY ./app  /app

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
ENTRYPOINT ["npm", "start"]
