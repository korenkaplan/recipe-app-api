# Use the official Python 3.9 image based on Alpine Linux
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="Koren Kaplan"

# Set an environment variable to ensure Python output is unbuffered
ENV PYTHONUNBUFFERED 1

# Copy the requirements file to a temporary location
COPY ./requirements.txt /tmp/requirements.txt

# Copy the development  requirements file to a temporary location
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the app code to the /app directory
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Expose port 8000 for the application
EXPOSE 8000

# Define a buld argument called DEV and set it to false.
ARG DEV=false
# Create a Python virtual environment in /py
RUN python -m venv /py && \
    # Upgrade pip inside the virtual environment
    /py/bin/pip install --upgrade pip && \
    # Install the postgresql client, the client package we need install inside our alpine image.
    apk add --update --no-cache postgresql-client && \
    # Group the dependencies installed ( build-base, postgresql-dev, musl-dev) for the installion of psycog2 package in a folder called tmp-build-deps
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    # Install dependencies from requirements.txt
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Check if the build argument DEV is true means we are in development so install the dev dependencies(shell syntax)
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # Clean up temporary files
    rm -rf /tmp && \
    # Remove the packages we installed from .tmp-build-deps after installtion we don't need them.
    apk del .tmp-build-deps && \
    # Create a non-root user named "django-user"
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add the virtual environment's bin directory to the PATH
ENV PATH="/py/bin:$PATH"

# Switch to the "django-user" user
USER django-user
