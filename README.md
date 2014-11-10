#Predictionio tutorial

[Installation](http://docs.prediction.io/0.8.0/install/install-linux.html)

[Tutorial](http://docs.prediction.io/0.8.0/tutorials/engines/itemrec/rails.html)

to dump file into psql database:

    sudo -u postgres psql db_name < ‘file_path’

to set varialbles:

    sudo subl ~/.bash_profile
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
    source ~/.bash_profile

to start hbase, fist go to hbase_home directory:

    cd hbase-0.98.6-hadoop2/
    bin/start-hbase.sh


to start eventserver:

    $PIO_HOME/bin/pio eventserver