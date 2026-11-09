
#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# FDE - AIOps Operations Command Center
# Project Structure Generator
# ==========================================

PROJECT_NAME="FDE"

# If already inside FDE, use current directory.
# Otherwise create an FDE directory here.
if [[ "$(basename "$PWD")" == "$PROJECT_NAME" ]]; then
    PROJECT_DIR="$PWD"
else
    PROJECT_DIR="${1:-$PWD/$PROJECT_NAME}"
fi

echo "========================================"
echo " FDE Project Setup"
echo "========================================"

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Create directories
DIRECTORIES=(
    applications/payment-service
    applications/order-service
    applications/user-service

    observability/prometheus
    observability/grafana
    observability/loki
    observability/opentelemetry

    data-engineering/ingestion
    data-engineering/transformation
    data-engineering/validation
    data-engineering/sample-data

    aiops/detection
    aiops/correlation
    aiops/investigation
    aiops/remediation

    integrations/palantir

    tests/unit
    tests/integration
    tests/end-to-end

    docs/architecture
    docs/requirements
    docs/decisions
    docs/runbooks

    scripts

    deployment/docker
    deployment/kubernetes
)

echo "[1/5] Creating directories..."

for directory in "${DIRECTORIES[@]}"; do
    mkdir -p "$directory"
done

# Create files only if they do not already exist.
create_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        mkdir -p "$(dirname "$file")"
        cat > "$file"
        echo "  Created: $file"
    else
        echo "  Preserved: $file"
    fi
}

echo "[2/5] Creating project documentation..."

create_file README.md <<'EOF'
# FDE - AI-Powered IT Operations Command Center

## Project Overview

An enterprise-style AIOps platform for monitoring services,
detecting incidents, correlating operational signals and assisting
engineers with evidence-based incident investigation.

## Objectives

- Build simulated microservices.
- Collect logs, metrics and traces.
- Develop data ingestion pipelines.
- Integrate operational datasets with Palantir Foundry.
- Model services and incidents using Ontology.
- Implement anomaly detection and event correlation.
- Build an AI-assisted incident investigation workflow.
- Provide safe, human-approved remediation recommendations.

## Technology Stack

- Python
- Docker and Docker Compose
- OpenTelemetry
- Prometheus
- Grafana
- Loki
- PostgreSQL
- Palantir Foundry and AIP
- Scikit-learn
- Git and GitHub

## Project Status

Phase 0: Environment discovery completed.
Phase 1: Development environment setup in progress.

## Data Policy

Only synthetic or explicitly authorized data should be used
in this personal development project.

## Documentation

See the docs/ directory for architecture, requirements,
technical decisions and operational runbooks.
EOF

create_file docs/architecture/architecture.md <<'EOF'
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
EOF

create_file docs/requirements/project-requirements.md <<'EOF'
# Project Requirements

## Business Problem

Operations engineers need help detecting, investigating
and resolving incidents across distributed applications.

## Functional Requirements

1. Collect application logs and metrics.
2. Monitor application health.
3. Detect abnormal behaviour.
4. Generate incident records.
5. Correlate related alerts.
6. Identify probable root causes.
7. Retrieve relevant operational runbooks.
8. Recommend remediation.
9. Require human approval for remediation.
10. Record incident outcomes.

## Non-Functional Requirements

- Secure data handling.
- Traceable incident investigations.
- Reproducible deployments.
- Automated testing.
- Clear documentation.
- Cost-conscious implementation.
EOF

echo "[3/5] Creating configuration files..."

create_file .gitignore <<'EOF'
# Python
__pycache__/
*.py[cod]
*.egg-info/
.pytest_cache/
.venv/
venv/

# Secrets and environment files
.env
.env.*
!.env.example

# Logs
*.log
logs/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Build artifacts
build/
dist/
coverage/
htmlcov/

# Temporary files
tmp/
temp/

# Local databases
*.db
*.sqlite3
EOF

create_file .env.example <<'EOF'
# Application configuration
APP_ENV=development
APP_NAME=aiops-operations-command-center

# API configuration
API_HOST=0.0.0.0
API_PORT=8000

# Database configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=aiops

# Never put actual credentials in this file.
# Keep secrets in local environment variables.
EOF

create_file requirements.txt <<'EOF'
fastapi
uvicorn
pydantic
pandas
scikit-learn
prometheus-client
requests
pytest
httpx
EOF

# Keep empty directories visible in Git.
echo "[4/5] Creating directory placeholders..."

find applications observability data-engineering aiops \
    integrations tests docs scripts deployment \
    -type d -empty -exec touch '{}/.gitkeep' \;

# Initialize Git only if not already initialized.
echo "[5/5] Initializing Git..."

if [[ ! -d ".git" ]]; then
    git init
    echo "Git repository initialized."
else
    echo "Existing Git repository preserved."
fi

echo
echo "========================================"
echo " FDE PROJECT SETUP COMPLETED"
echo "========================================"
echo
echo "Project location: $PROJECT_DIR"
echo
echo "Next commands:"
echo "  cd \"$PROJECT_DIR\""
echo "  git status"
echo "  find . -maxdepth 3 -type f | sort"
echo
echo "No remote repository has been created."
echo "Review files before your first commit."
