FROM zhade/zextractor AS build

ARG DATA_GRF_URL
ARG ROVERSE_GRF_URL

WORKDIR /zext

# Download GRF files
ADD ${DATA_GRF_URL} ./grf-source/data.grf
ADD ${ROVERSE_GRF_URL} ./grf-source/roverse.grf

# Copy all input files
COPY ./zext /zext/input

# Run extractor with full paths
RUN ./zextractor \
  --outdir=/zext/input/data-resources \
  --grf=/zext/grf-source/roverse.grf,/zext/grf-source/data.grf \
  --filtersfile=/zext/input/filters.txt \
  --verbose

FROM zhade/zrenderer:latest

WORKDIR /zren

# Copy extracted files
COPY --from=build --chown=zren:zren /zext/input /zren/container

# Copy configuration file
COPY ./zren/zrenderer.conf /zren/zrenderer.conf

EXPOSE 11011
CMD ["./zrenderer-server"]
