
import logging
import uuid

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field


# ---------------------------------
# Logging configuration
# ---------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s"
)

logger = logging.getLogger("payment-service")


# ---------------------------------
# Application initialization
# ---------------------------------

app = FastAPI(
    title="FDE Payment Service",
    description="A simulated payment microservice for our AIOps project",
    version="1.0.0"
)


# ---------------------------------
# Request data model
# ---------------------------------

class PaymentRequest(BaseModel):
    customer_id: str = Field(min_length=1)
    amount: float = Field(gt=0, le=100000)
    currency: str = Field(default="INR", pattern="^INR$")
    payment_method: str = Field(default="UPI")


# ---------------------------------
# Health check endpoint
# ---------------------------------

@app.get("/health")
def health_check():

    logger.info("Health check requested")

    return {
        "service": "payment-service",
        "status": "healthy",
        "environment": "development"
    }


# ---------------------------------
# Root endpoint
# ---------------------------------

@app.get("/")
def root():

    return {
        "message": "Welcome to FDE Payment Service",
        "documentation": "/docs",
        "health": "/health"
    }


# ---------------------------------
# Payment processing endpoint
# ---------------------------------

@app.post("/payments")
def create_payment(payment: PaymentRequest):

    payment_id = str(uuid.uuid4())

    logger.info(
        "Payment request received: payment_id=%s customer_id=%s amount=%.2f",
        payment_id,
        payment.customer_id,
        payment.amount
    )

    # Simulated payment processing.
    # No real money or payment gateway is involved.

    if payment.amount > 50000:

        logger.warning(
            "Payment rejected: payment_id=%s reason=amount_limit",
            payment_id
        )

        raise HTTPException(
            status_code=400,
            detail="Payment amount exceeds the simulated transaction limit"
        )

    logger.info(
        "Payment successful: payment_id=%s",
        payment_id
    )

    return {
        "payment_id": payment_id,
        "customer_id": payment.customer_id,
        "amount": payment.amount,
        "currency": payment.currency,
        "status": "SUCCESS",
        "message": "Payment processed successfully"
    }
