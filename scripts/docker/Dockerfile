FROM ubuntu:25.10

# 3724 - authserver
# 8085 - worldserver
# 3306 - mysql
EXPOSE 3724 8085 3306

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/start.sh"]
