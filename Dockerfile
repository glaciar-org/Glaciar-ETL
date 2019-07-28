FROM mongo:4.0 

RUN mkdir -p /exchange_data

WORKDIR /exchange_data

COPY ./exchange_data /exchange_data

RUN ["chmod", "+x", "./restore.sh"]

CMD ["./restore.sh"]
