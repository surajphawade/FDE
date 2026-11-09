# System Architecture

## Planned Data Flow

Microservices
    |
    v
OpenTelemetry / Prometheus / Loki
    |
    v
Data Ingestion and Transformation
    |
    v
Palantir Foundry Datasets
    |
    v
Palantir Ontology
    |
    v
AIOps Detection and Correlation
    |
    v
AI Incident Investigation
    |
    v
Operations Command Center

## Initial Services

- Payment Service
- Order Service
- User Service

## Initial Incident Scenario

Payment API latency increases due to database connection
exhaustion.

All incident data will initially be synthetic.
