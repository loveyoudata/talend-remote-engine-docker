FROM azul/zulu-openjdk:17

ARG TALEND_RE_VERSION

RUN mkdir -p /opt/talend
# ADD automatically extracts tar archives, so no manual tar command is needed
ADD Talend-RemoteEngine-V${TALEND_RE_VERSION}-*.tar.gz /opt/talend/
# Use a wildcard to handle directories that contain a build suffix
RUN mv /opt/talend/Talend-RemoteEngine-V${TALEND_RE_VERSION}* /opt/talend/remote-engine/
COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/opt/talend/remote-engine/bin/trun", "server"]
