FROM python:3.10.0-slim as base

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    VENV_PATH=/venv

FROM base as builder

WORKDIR /tmp

# build installable package
RUN pip install poetry
COPY . /tmp/
RUN poetry build

# create virtualenv and install package
RUN python -m venv ${VENV_PATH}
RUN ${VENV_PATH}/bin/pip install dist/*.whl

FROM base as final

WORKDIR /app

ARG APP_VERSION=0.0.0
ARG APP_COMMIT_SHA=unknown
ENV APP_VERSION=${APP_VERSION}
ENV APP_COMMIT_SHA=${APP_COMMIT_SHA}

COPY --from=builder ${VENV_PATH} ${VENV_PATH}
COPY container-entrypoint.sh ./
CMD ["./container-entrypoint.sh"]
