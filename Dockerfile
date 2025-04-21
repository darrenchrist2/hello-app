FROM node:20

WORKDIR /app
COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
