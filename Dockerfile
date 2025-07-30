FROM zhade/zextractor AS build

# Define build arguments for CDN URLs
ARG DATA_GRF_URL
ARG ROVERSE_GRF_URL

WORKDIR /zext

ADD ${DATA_GRF_URL} ./grf-source/data.grf
ADD ${ROVERSE_GRF_URL} ./grf-source/roverse.grf

COPY ./zext /zext/input
COPY ./zext/zextractor.conf /zext/zextractor.conf
RUN ./zextractor --outdir=input/data-resources --grf=./grf-source/data.grf,./grf-source/roverse.grf --filtersfile=input/filters.txt --verbose

FROM zhade/zrenderer:latest

WORKDIR /zren

COPY --from=build --chown=zren:zren /zext/input /zren/container
COPY ./zren/zrenderer.conf /zren/zrenderer.conf

EXPOSE 11011
CMD ["./zrenderer-server"]
