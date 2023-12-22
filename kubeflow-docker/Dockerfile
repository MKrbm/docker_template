FROM kubeflownotebookswg/jupyter-scipy:v1.7.0

USER root

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Install sudo and set up users
RUN apt-get update && apt-get install -y sudo && \
    echo 'root:root' | chpasswd && \
    echo 'jovyan:jovyan' | chpasswd && \
    usermod -aG docker jovyan && \
    echo 'jovyan ALL=(ALL) ALL' >> /etc/sudoers


COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# If it doesn't work, please manually set the owernership. with above code.

USER jovyan

RUN python3 -m pip install psycopg2-binary kfp==1.8.22