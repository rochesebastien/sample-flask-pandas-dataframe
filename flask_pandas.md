# Instructions d'installation Projet Flask Fil Rouge

Ceci est le fichier markdown pour l'installation et le lancement du project fil rouge. Ce projet est fait dans le cadre du cours de CI/CD de Livecampus.

## Prérequis

Assurez-vous d'avoir les éléments suivants installés sur votre machine :

- Python
- Docker (si vous souhaitez utiliser Docker)

## Installation (local)

1. Clonez ce dépôt sur votre machine :

    ```bash
    git clone https://github.com/rochesebastien/sample-flask-pandas-dataframe.git
    ```

2. Accédez au répertoire du projet :

    ```bash
    cd sample-flask-pandas-dataframe
    ```

3. Installez les dépendances Python :

    ```bash
    python3 -m venv venv
    venv\Scripts\activate #Windows
    source venv/bin/activate #Linux
    pip install -r requirements.txt
    ```
    Désactiver l'environnement virtuel avec : `deactivate`

4. Variables d'environnements :   

    ```bash
    export FLASK_APP=app.py #(Unix/Mac)
    set FLASK_APP=app.py #(Windows)
    ```

4. Initilisation DB : 
    ```bash
    sh db_init.sh 

    # ou avec le FLASK CLI
    $ flask shell
    >>> from app import db  # import SqlAlchemy interface 
    >>> db.create_all()     # create SQLite database and Data table 
    >>> quit()              # leave the Flask CLI  
    ```
    Puis : 
    ```bash
    flask load-data titanic-min.csv
    ```

## Utilisation en mode manuel

1. Démarrez le serveur Flask :

    ```bash
    flask run --host=0.0.0.0 --port=5000 --debug
    ```

2. Accédez à l'URL suivante dans votre navigateur :

    ```
    http://ip_machine:31201
    ```

    Vous devriez voir l'application Flask en cours d'exécution.

## Utilisation avec Docker

1. Construisez l'image Docker :

    ```bash
    docker build -t flask-panda .
    ```

2. Démarrez un conteneur Docker à partir de l'image :

    ```bash
    docker run -d -p 31201:5000 flask-panda
    ```

3. Accédez à l'URL suivante dans votre navigateur :

    ```
    http://localhost:31201
    ```

    Vous devriez voir l'application Flask en cours d'exécution.

## Le dockerfile 

```dockerfile
FROM python:3.10.1-slim-buster

RUN apt-get update 

WORKDIR /flask_fil_rouge
COPY . /flask_fil_rouge #copy the directory 

RUN pip install --upgrade pip
# remove the virtual environment if it exists
RUN rm -rf venv
# remove the db if it exists
RUN rm -rf instance

#python virtual env init
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate" && \
    pip install -r requirements.txt 

# Flask var
ENV FLASK_APP=app.py

# make sh script executable
RUN chmod +x db_init.sh 
RUN /bin/sh db_init.sh

EXPOSE 5000 #open the port
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000", "--debug"]

````

## Dockerhub : 

L'image de ce projet est disponible ici : https://hub.docker.com/repository/docker/rsebastien/flask-pandas/general

Pour la récupérer vous pouvez simple la pull : 
```
docker pull rsebastien/flask-panda
```

Pour mettre l'image en ligne sur mon repository dockerhub, j'ai executé cette suite de commande 
( après avoir  [build l'image](#Utilisation-avec-Docker), et s')

- Tag l'image : 

```
docker tag flask-panda rsebastien/flask-panda
```
- Push l'image sur Dockerhub :
```
docker push rsebastien/flask-panda
```

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/docker-hub.png)

# Tests unitaires 

- Pour les tests unitaires, il faut utiliser jmeter et faire ceci : 

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jmeter0.png)

- Ensuite on rentre nos variables comme ceci : 

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jmeter3.png)

- On les rentre ici : 

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jmeter2.png)

- Et on vérifie nos conditions de test (ici si la valeur est présente sur la page ): 

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jmeter1.png)

Et on save et export le fichier dans notre repo sous le nom : `flask_pandas_test_plan.jmx`

# Automatisation des déploiments 

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jenkins-home.png)

Nous allons mettre en place le déploiment automatique avec jenkins. Pour ce faire, nous allons faire ses actions : 
- Création d'un item flask-panda docker : 
    - ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/panda-docker1.png)  
    Nous devons cocher la case git, et remplir les champs nécessaires (comme ci-dessus)
    - Cochez la case "GitHub hook trigger for GITScm polling"
    - Ajouter une étape "execute shell script" à build steps : 
    ```
    rm -rf sample-flask-pandas-dataframe #delete if already exist
    git clone https://github.com/rochesebastien/sample-flask-pandas-dataframe
    cd sample-flask-pandas-dataframe
    echo "docker build -t flask-panda ."
    echo "docker run -d -p 31201:5000 flask-panda"
    #docker build -t flask-panda .
    #docker run -d -p 31201:5000 flask-panda
    ```
    Les commandes docker sont des "echo" car il y a un problème sur les VM et nous ne pouvons pas utiliser Docker CLI sur la machine ...

- Création d'un item flask-panda-jmeter
    - ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/panda-docker1.png)  
    Nous devons cocher la case git, et remplir les champs nécessaires (comme ci-dessus)
    - Ajouter une étape "execute shell script" à build steps : 
    ```
    jmeter -Jjmeter.save.saveservice.output_format=xml -Jjmeter.save.saveservice.response_data.on_error=true -n -t flask_pandas_test_plan.jmx  -l testresult.jlt
    ```
    - Ajouter une étape à la suite du build : 
        - ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/panda-docker2.png) 
        Vous devez remplir comme ci dessus ( il faut que le fichier `flask_pandas_test_plan.jmx` soit bien présent ..)

- Mettre en chaine les 2 jobs : 
    - Vous devez retouner dans l'item `flask-panda-docker` et rajouter une action action à la suite du build : 
    ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/panda-docker2.png) 

- Création du pipeline : 
    - Vous devez faire un nouvelle vue : `flask-panda-pipeline``
    - Vous devez mettre le nom du premier item comme ceci : 
    ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jenkins1.png) 
    - Vous devez ensuite lancer un par un vos job et vérifiez si tout fonctionne.

- Détection github : 
    - Vous devez mettre un webhook comme ceci 

    ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/github.png) 

Voici le résultat final, un pipeline fonctionnel : 
    ![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jenkins2.png) 


# Jetbrains IDE

Vous pouvez voir et intéragir avec vos jobs avec le plugin Jenkins sur les editeurs de la suite Jetbrains :

![Flask Pandas Dataframe - media file.](https://raw.githubusercontent.com//rochesebastien/sample-flask-pandas-dataframe/main/media/jetbrains.png)

----



2024 - Roche Sébastien 