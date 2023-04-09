FROM node:16.20.0-alpine

WORKDIR /app
COPY ./app.js .
RUN npm install ip

CMD ["node", "/app/app.js"]
