FROM spark:3.5.6-scala2.12-java17-python3-ubuntu

USER root

RUN apt-get update && \
    apt-get -y install python3.10-venv

RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.262/aws-java-sdk-bundle-1.12.262.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.4/hadoop-common-3.3.4.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-core/3.3.4/hadoop-mapreduce-client-core-3.3.4.jar && \
    wget https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/1.0.7.Final/wildfly-openssl-1.0.7.Final.jar && \
    wget https://jdbc.postgresql.org/download/postgresql-42.7.4.jar

RUN mkdir -p /opt/spark/work-dir/docker-for-data-engineers && \
    mkdir -p /home/spark/.vscode-server && \
    mkdir -p /home/spark/.local && \
    mkdir -p /home/spark/.cache

RUN chown -R spark:spark /opt/spark/work-dir && \
    chown -R spark:spark /home/spark/.vscode-server && \
    chown -R spark:spark /home/spark/.local && \
    chown -R spark:spark /home/spark/.cache && \
    chown -R spark:spark /home/spark

COPY requirements.txt /opt/spark/work-dir/docker-for-data-engineers/requirements.txt
RUN chown spark:spark /opt/spark/work-dir/docker-for-data-engineers/requirements.txt

USER spark

RUN python3 -m venv /opt/spark/work-dir/.venv && \
    . /opt/spark/work-dir/.venv/bin/activate && \
    pip install -r /opt/spark/work-dir/docker-for-data-engineers/requirements.txt

ENV SPARK_HOME=/opt/spark
ENV PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.9.5-src.zip
ENV PATH="/opt/spark/bin:${PATH}"

CMD [ "sleep", "infinity" ]