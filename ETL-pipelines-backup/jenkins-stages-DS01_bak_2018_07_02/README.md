

ls -la
curl -o "calidad-de-aire.zip"  https://data.buenosaires.gob.ar/api/datasets/HJWHSFZmyl/download
unzip   "calidad-de-aire.zip"
ls -la calidad-de-aire/calidad-de-aire-2009-20??.csv

# Clean
rm     calidad-de-aire.zip
rm -rf calidad-de-aire


# Docekr

KO!
docker run --rm -it -v ~/config-logstash/:/usr/share/logstash/pipeline/ docker.elastic.co/logstash/logstash:6.2.3

ANDA OK!
$ docker run -it --rm docker.elastic.co/logstash/logstash:6.2.3 -e 'input { stdin { } } output { stdout { } }'



ANDA OK?
$ pwd
 ~/Desktop/DevOps/code/github/PabloEzequiel/UELA-2.0/datasets-doceker/example3

$ 
docker run -it --rm -v "$PWD":/dir-logstash  docker.elastic.co/logstash/logstash:6.2.3  -f /dir-logstash/config-logstash/logstash.conf


-------

 docker run -it --rm -v "$PWD":/config-logstash logstash -f /config-logstash/logstash.conf


 NOTA: 

    Aunque el paso 02 es "toMongo" ... en realidad yo lo utilizo para ir a Elastic ... y no recuerdo cuando lo envío a mongo ...
    ….……… ……………………………………………………………–––––––––––„„„„„„„„„„„„„„„„–…„–…„

…„„„„„…………




…„„„„„…………



…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………

…„„„„„…………


