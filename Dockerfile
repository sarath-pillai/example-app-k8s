FROM python:2.7.12
RUN pip install flask gunicorn

ADD server.py /opt/server.py
ADD wsgi.py /opt/wsgi.py
WORKDIR /opt/

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app"] 
