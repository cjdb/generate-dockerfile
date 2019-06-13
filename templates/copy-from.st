COPY --from={{release}} /usr/local /opt/{{release}}
ENV PATH="/opt/{{release}}/bin:${PATH}"
