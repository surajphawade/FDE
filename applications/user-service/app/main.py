
import logging

from fastapi import FastAPI

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s"
)

logger = logging.getLogger("user-service")

app = FastAPI(
    title="FDE User Service",
    version="1.0.0"
)

# Synthetic customers for our development environment.
CUSTOMERS = {
    "CUST001": {
        "customer_id": "CUST001",
        "name": "Demo Customer",
        "status": "ACTIVE"
    },
    "CUST002": {
        "customer_id": "CUST002",
        "name": "Inactive Customer",
        "status": "INACTIVE"
    }
}


@app.get("/health")
def health_check():

    logger.info("User service health check")

    return {
        "service": "user-service",
        "status": "healthy"
    }


@app.get("/users/{customer_id}")
def get_user(customer_id: str):

    logger.info("Customer lookup: customer_id=%s", customer_id)

    customer = CUSTOMERS.get(customer_id)

    if not customer:
        return {
            "error": "Customer not found",
            "customer_id": customer_id
        }

    return customer
