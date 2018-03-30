FROM alpine
RUN apk --no-cache add dnsmasq
COPY dnsmasq.conf /etc/
EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-k", "-q", "--log-facility=-"]

