FROM python:3.10.1-slim-buster

RUN apt-get update 

WORKDIR /flask_fil_rouge
COPY . /flask_fil_rouge

RUN pip install --upgrade pip
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate" && \
    pip install -r requirements.txt 

# Flask var
ENV FLASK_APP=app.py

# make sh script executable
RUN chmod +x db_init.sh 
RUN /bin/sh db_init.sh

EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000", "--debug"]

#To build the image
# docker build -t flask_pandas .
#To run the image
# docker run -d -p 31201:5000 flask_pandas