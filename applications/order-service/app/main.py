
import logging
import uuid

from fastapi import FastAPI
from pydantic import BaseModel, Field

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s"
)

logger = logging.getLogger("order-service")

app = FastAPI(
    title="FDE Order Service",
    version="1.0.0"
)


class OrderRequest(BaseModel):
    customer_id: str = Field(min_length=1)
    amount: float = Field(gt=0)
    product_name: str = Field(min_length=1)


@app.get("/health")
def health_check():
    logger.info("Order service health check")

    return {
        "service": "order-service",
        "status": "healthy"
    }


@app.post("/orders")
def create_order(order: OrderRequest):

    order_id = str(uuid.uuid4())

    logger.info(
        "Order created: order_id=%s customer_id=%s",
        order_id,
        order.customer_id
    )

    return {
        "order_id": order_id,
        "customer_id": order.customer_id,
        "product_name": order.product_name,
        "amount": order.amount,
        "status": "CREATED"
    }
