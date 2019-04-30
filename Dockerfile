FROM python:3-alpine as base



FROM base as builder
RUN mkdir /install
WORKDIR /install

RUN pip install --install-option="--prefix=/install" prettytable termcolor simplejson

RUN apk update && apk add --no-cache git build-base
RUN apk add --no-cache  libxml2-dev libxslt-dev

ARG repo=devel

RUN pip install --install-option="--prefix=/install" git+https://git.weboob.org/weboob/${repo}.git



FROM base
COPY --from=builder /install /usr/

RUN useradd -m -s /bin/bash weboob && \
 mkdir -p /home/weboob/.config /home/weboob/.local/share /config /data && \
 ln -s /config /home/weboob/.config/weboob && \
    ln -s /data /home/weboob/.local/share/weboob && \
    chown -R weboob:weboob ~weboob /config /data
	
USER weboob
WORKDIR "/config"

CMD ["weboob"]
