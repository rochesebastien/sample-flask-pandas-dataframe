# Instructions d'installation Projet Flask Fil Rouge

Ceci est le fichier markdown pour l'installation et le lancement du project fil rouge. Ce projet est fait dans le cadre du cours de CI/CD de Livecampus.

## Prérequis (local)

Assurez-vous d'avoir les éléments suivants installés sur votre machine :

- Python (version 3.10.1 ou supérieure)
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
    http://localhost:5000
    ```

    Vous devriez voir l'application Flask en cours d'exécution.

## Utilisation avec Docker

1. Construisez l'image Docker :

    ```bash
    docker build -t flask_fil_rouge .
    ```

2. Démarrez un conteneur Docker à partir de l'image :

    ```bash
    docker run -p 31201:5000 flask_fil_rouge
    ```

3. Accédez à l'URL suivante dans votre navigateur :

    ```
    http://localhost:31201
    ```

    Vous devriez voir l'application Flask en cours d'exécution.

----
2024 - Roche Sébastien 