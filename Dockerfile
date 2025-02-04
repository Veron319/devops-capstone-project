# Use the official Python 3.9 slim image as base
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements file first for caching dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . .

# Ensure the container does not run as root
RUN useradd --uid 1000 nonrootuser && chown -R nonrootuser /app
USER nonrootuser

# Expose the application port
EXPOSE 8000

# Run the application using Gunicorn
CMD ["gunicorn", "--bind=0.0.0.0:8000", "--log-level=info", "service:app"]
