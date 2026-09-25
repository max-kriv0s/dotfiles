# LSP: dockerls. Линтер: hadolint.
# Строка с apt-get намеренно нарушает правила hadolint —
# он должен пожаловаться на отсутствие версии пакета и на лишний слой.

FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

RUN apt-get update
RUN apt-get install -y curl

EXPOSE 3000
CMD ["node", "server.js"]
