
FROM python:3.4
MAINTAINER David Karchmer <dkarchmer@gmail.com>

# create unprivileged user
RUN adduser --disabled-password --gecos '' myuser

# Install PostgreSQL dependencies
# Install Postgres
RUN apt-get update && apt-get install -y \
            postgresql-9.3 \
            libpq-dev \
            libjpeg-dev; \
            apt-get clean

# Step 1: Install any Python packages
# ----------------------------------------

RUN mkdir /var/app
WORKDIR  /var/app
COPY requirements.txt /var/app/
RUN pip install -r requirements.txt

# Step 2: Copy Django Code
# ----------------------------------------

COPY authentication /var/app/authentication
COPY myproject /var/app/myproject
COPY settings /var/app/settings
COPY manage.py /var/app/

ENV DJANGO_SETTINGS_MODULE=settings.dev-local
ENV RDS_DB_NAME=ebdb
ENV RDS_USERNAME=ebroot
ENV RDS_PASSWORD=eb.Pass.123
ENV RDS_HOSTNAME=aa2locrhlwceh5.cyugexp1diwq.us-east-1.rds.amazonaws.com
ENV RDS_PORT=5232


# Useless as there is no port really exposed but seems like EB needs it
EXPOSE 8080

#VOLUME ["/var/app"]

WORKDIR  /var/app
CMD ["python", "/var/app/manage.py", "runserver", "0.0.0.0:8080"]
