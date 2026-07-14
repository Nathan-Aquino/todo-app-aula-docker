FROM node:26 AS build

RUN useradd -m userNest
USER userNest

WORKDIR /home/userNest/app

COPY --chown=userNest package*.json ./
RUN npm ci

COPY --chown=userNest . .

RUN npm run build

RUN npm prune --omit=dev

FROM node:26-slim

WORKDIR /app

COPY --from=build /home/userNest/app/package*.json ./

RUN npm ci --omit=dev

COPY --from=build /home/userNest/app/dist ./dist

CMD ["node", "dist/main.js"]