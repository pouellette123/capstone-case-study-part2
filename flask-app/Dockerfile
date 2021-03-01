# get the base image
FROM python:3

# set a directory for the app
WORKDIR /usr/src/app

# copy all the files to the container
COPY . /usr/src/app/

# install dependencies
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# tell the port number the container should expose
EXPOSE 8079

# run the command
CMD ["python", "/usr/src/app/web.py"]

