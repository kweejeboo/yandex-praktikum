FROM python:3.11-alpine
WORKDIR /app
COPY [ "requirements.txt",  "app.py",  "test_app.py", "./"]
RUN pip install -r requirements.txt --upgrade pip \
&& pip install certifi \
&& apk add curl \
&& curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt \
&& cat YandexInternalRootCA.crt >> /etc/ssl/certs/ca-certificates.crt \
&& update-ca-certificates 
EXPOSE 8888
ENTRYPOINT ["python"]
CMD ["app.py"]

