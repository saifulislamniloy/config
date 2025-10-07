# File: Makefile

# Variables
COMPOSE_FILE=docker-compose.yml
CLUSTER_NODES=redis-7000:7000 redis-7001:7001 redis-7002:7002 redis-7003:7003 redis-7004:7004 redis-7005:7005

# Default target
.PHONY: up
up: compose cluster

# Step 1: Start docker compose in detached mode
.PHONY: compose
compose:
	@echo "🚀 Starting Redis containers..."
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "⏳ Waiting for Redis nodes to initialize..."
	sleep 5

# Step 2: Create the Redis cluster
.PHONY: cluster
cluster:
	@echo "🔗 Creating Redis cluster..."
	docker exec -it redis-7000 redis-cli --cluster create $(CLUSTER_NODES) --cluster-replicas 1 --cluster-yes
	@echo "✅ Redis cluster created successfully!"

# Step 3: Stop containers
.PHONY: down
down:
	@echo "🛑 Stopping and removing containers..."
	docker compose -f $(COMPOSE_FILE) down -v

# Step 4: Restart everything (rebuild from scratch)
.PHONY: restart
restart: down up

