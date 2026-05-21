# FROM node:20
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# # EXPOSE 8080
# RUN npm install
# ENV MONGO="true"\
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node","server.js"]




FROM node:20-alpine AS builder
RUN apk add --no-cache curl

WORKDIR /app

COPY package.json .
COPY *.js .
RUN npm install


# ---- Runtime Stage ----
FROM node:20-alpine
WORKDIR /app
EXPOSE 8080

COPY --from=builder /app /app

ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"

RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
RUN chown -R roboshop:roboshop /app
USER roboshop    
CMD ["node", "server.js"]

