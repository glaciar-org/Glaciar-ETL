FROM mongo:4.0 

RUN apt-get update && \
    apt-get install -y net-tools iproute2 curl

RUN mkdir -p /Glaciar-ETL/exchange_data &&  \
    mkdir -p /Glaciar-ETL/ETL-pipelines

WORKDIR /Glaciar-ETL

COPY ./ETL-pipelines ./ETL-pipelines
COPY ./exchange_data ./exchange_data
COPY ./dispatch.sh   ./dispatch.sh
# COPY ./.env          ./.env

RUN chmod +x ./ETL-pipelines/ETL?-DS0?/run-0*.sh  && \
    chmod +x ./exchange_data/restore.sh           && \
    chmod +x ./dispatch.sh

CMD ["./dispatch.sh"]
