Ejemplos de visualización con Kibana


NOTA:
  - EN los dataset tengo valores como 
    <=
    ---
    <LD
    y ""
    Probablemente sea más correcto filtrarlos a algo que sea ignorar ...
    ... que considerarlos ... 
    ¿Los puedo filtrar desde ELK?

a) DATASET 01 ..


COINCLUSION: Anduvo OK! Incluso para la version ALL

TODO: Dashboard local ... 

long              lat              	DIRECCION	            INICIO_DE_ACTIVIDAD	PARAMETROS_MEDIDOS	
-58,3663735070165	-34,6252584813295	LA BOCA	AV. BRASIL 100                	01/05/2009  	CO, NO, NO2, NOX, PM10
-58,4320717652753	-34,6066080998154	CENTENARIO	RAMOS MEJÍA 800           	01/01/2005    CO, NO, NO2, NOX, PM10
-58,391552893462	-34,5995643433432	CORDOBA	AV. CORDOBA Y RODRIGUEZ PEÑA	  01/05/2009    CO, NO, NO2, NOX, PM10
-58,4053598727298	-34,5834529467442	PALERMO	AV. LAS HERAS Y ORTIZ DE OCAMPO	01/01/2002    CO, NO, NO2, NOX, PM10


# PARQUE CENTENARIO

# Latitude: -34° 36' 13.79" S
# Longitude: -58° 26' 4.79" W
# -34.603830918,-58.43466492799996


  ___________
  DUDA:
    ¿Por qué en el caso simple, no funciona el indexador por date .... ?

    fecha_time_stamp:31/10/2017 22

    @timestamp:February 9th 2018, 23:32:49.288 
    
    FECHA:31/10/2017
    HORA:22
    
            FECHA   ,HORA, AIRQ_CO ,AIRQ_NO2 ,DATASET
    message:31/10/2017,22, 0.39    ,55       ,DATASET_01_2009_2017_BO

--------------
RTA:
  OK: PERFECTO:
     FECHA_HORA	       	October 31st 2017, 21:00:00.000

  mutate {
    # add_field => { "fecha_time_stamp" => "%{FECHA} %{HORA}" }
    add_field => { "fecha_time_stamp" => "%{FECHA} %{HORA}" }
  }


FECHA,HORA,AIRQ_CO,AIRQ_NO2,DATASET
01/10/2009,14, , ,DATASET_01_2009_2017_BO
01/10/2009,15,0.16,25,DATASET_01_2009_2017_BO
01/10/2009,16,0.14,23,DATASET_01_2009_2017_BO
01/10/2009,17,0.12,24,DATASET_01_2009_2017_BO
01/10/2009,18,0.11,25,DATASET_01_2009_2017_BO

  date {


    match => [ "fecha_time_stamp", "dd/MM/yyyy HH" ]
    target => "FECHA_HORA"
  }
