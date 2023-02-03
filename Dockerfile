ARG UBUNTUVER=20.04

FROM ubuntu:${UBUNTUVER}

ARG PGHOST
ARG PGDATABASE
ARG PGPASSWORD

ENV PORT 8080
ENV NODE_ENV="production"
ENV TZ="Etc/UTC"
ENV PGPORT=5432
ENV PGUSER="postgres"
ENV PGHOST ${PGHOST}
ENV PGDATABASE ${PGDATABASE}
ENV PGPASSWORD ${PGPASSWORD}


RUN mkdir /dextools-listener
WORKDIR /dextools-listener

COPY . .

# install prerequisites
RUN apt-get update \
    && apt-get install -y librocksdb-dev curl xxd openssl binutils locales jq \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Install Node resources
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash \
    && apt-get install nodejs \
    && npm install -g yarn


RUN npm install

EXPOSE 8080

CMD node index.js