# -------------------------
# Stage 1: Builder
# -------------------------
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 g++ make

# Copy package files first (for caching)
COPY package*.json ./

# Install all dependencies (including dev)
RUN npm ci

# Copy the rest of the application
COPY . .

# -------------------------
# Stage 2: Production
# -------------------------
FROM node:22-alpine AS production

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy only production dependencies from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/server.js ./
COPY --from=builder /app/database.js ./
COPY --from=builder /app/models ./models

# Set permissions for non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
