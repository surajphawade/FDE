
# Step 1: Choose a base image
FROM python:3.12-slim

# Step 2: Set working directory inside container
WORKDIR /app

# Step 3: Disable Python bytecode generation
ENV PYTHONDONTWRITEBYTECODE=1

# Step 4: Enable immediate Python log output
ENV PYTHONUNBUFFERED=1

# Step 5: Copy dependency file first
COPY requirements.txt .

# Step 6: Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 7: Copy application code
COPY app/ ./app/

# Step 8: Create a non-root user
RUN useradd --create-home appuser \
    && chown -R appuser:appuser /app

USER appuser

# Step 9: Document application port
EXPOSE 8000

# Step 10: Start application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
