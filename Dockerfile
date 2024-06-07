# Use Python 3.6 or later as a base image
FROM python:3.6

# Set the working directory in the container
WORKDIR /app

# Copy the contents into the image
COPY . /app

# Install pip dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set YOUR_NAME environment variable
ENV YOUR_NAME=demo

# Expose the correct port
EXPOSE 5500

# Create an entrypoint
ENTRYPOINT ["python", "app.py"]