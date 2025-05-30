# Event-Driven Investment Platform Architecture

## Project Structure
```
investment-platform/
├── api/
│   ├── proto/                  # Protocol buffer definitions
│   ├── swagger/                # API documentation
│   └── events/                 # Event definitions and schemas
├── cmd/
│   ├── server/                 # Main API server
│   ├── event-processor/        # Kafka event processor
│   ├── consumer/              # Event consumers
│   └── producer/              # Event producers
├── internal/
│   ├── domain/
│   │   ├── entities/          # Core domain entities
│   │   ├── events/            # Domain events
│   │   ├── commands/          # Command handlers
│   │   └── aggregates/        # Aggregate roots
│   ├── repository/
│   │   ├── postgres/          # PostgreSQL repositories
│   │   ├── redis/             # Redis caching
│   │   └── eventstore/        # Event store implementations
│   ├── service/
│   │   ├── query/             # CQRS query services
│   │   ├── command/           # CQRS command services
│   │   └── eventhandlers/     # Event handling services
│   ├── delivery/
│   │   ├── grpc/             # gRPC handlers
│   │   ├── rest/             # REST handlers
│   │   └── kafka/            # Kafka producers/consumers
│   └── infrastructure/
│       ├── messaging/         # Message bus implementations
│       ├── eventbus/          # Event bus implementations
│       └── streaming/         # Kafka streaming utilities
├── pkg/
│   ├── logger/                # Logging utilities
│   ├── middleware/            # Common middleware
│   ├── eventstore/            # Event store interfaces
│   ├── kafka/                 # Kafka helpers
│   └── utils/                 # Shared utilities
├── migrations/
│   ├── postgres/              # PostgreSQL migrations
│   └── eventstore/            # Event store migrations
├── deployment/
│   ├── docker/                # Docker configurations
│   │   ├── api/              # API service
│   │   ├── event-processor/  # Event processor service
│   │   └── kafka/            # Kafka configuration
│   └── k8s/                   # Kubernetes manifests
└── scripts/                   # Build and deployment scripts
```

## Technology Stack Configuration

### Core Infrastructure
- **PostgreSQL**: Write model and materialized views
- **Redis**: Caching and session management
- **Apache Kafka**: Event streaming and message broker
- **Elasticsearch**: Event store and analytics
- **MongoDB**: Read models for CQRS

### API Layer
- **gRPC**: Primary API protocol
- **Gin**: REST API gateway
- **GraphQL**: Real-time subscriptions

### Event Processing
- **Kafka Streams**: Event processing and analytics
- **Kafka Connect**: Data integration
- **Schema Registry**: Event schema management

### Infrastructure
- **Docker**: Containerization
- **Kubernetes**: Orchestration
- **AWS**: Cloud infrastructure
  - EKS: Container orchestration
  - MSK: Managed Kafka
  - RDS: Managed PostgreSQL
  - ElastiCache: Redis service

### Monitoring & Observability
- **Prometheus**: Metrics collection
- **Grafana**: Visualization
- **Jaeger**: Distributed tracing
- **ELK Stack**: Log aggregation

## Event Sourcing Components

### Event Store
- Event logs
- Snapshots
- Event versioning
- Event replay capability

### CQRS Implementation
- Command handlers
- Event handlers
- Read models
- Projections

### Message Flow
1. Commands → Command Handlers
2. Events → Event Store
3. Event Store → Kafka
4. Kafka → Event Handlers
5. Event Handlers → Read Models

### Event Processing Patterns
- Event-driven processing
- Stream processing
- Complex event processing (CEP)
- Event replay and recovery