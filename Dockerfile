FROM registry.fedoraproject.org/fedora:29

EXPOSE 9000

RUN dnf install nodejs-yarn -y && \
    yarnpkg global add thelounge@next

ENV APP_ROOT=/opt/app-root
ENV THELOUNGE_HOME=${APP_ROOT}/etc/thelounge
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
RUN mkdir -p ${THELOUNGE_HOME} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

RUN timeout 10 thelounge start || true

USER 10001
WORKDIR ${APP_ROOT}

ENTRYPOINT [ "uid_entrypoint" ]
CMD run
