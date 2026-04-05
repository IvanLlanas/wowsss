# Suggested run clause:
# $ docker run -h $HOSTNAME-wowsss -it -p 3724:3724 -p 8085:8085 -p 3306:3306 --name wowsss wowsss

FROM ubuntu:25.10

# 3724 - authserver
# 8085 - worldserver
# 3306 - mysql
EXPOSE 3724 8085 3306

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/start.sh"]
