FROM nginx:stable-alpine-slim

ARG projectName

ENV PROJECT_NAME=$projectName

COPY ./default.conf /etc/nginx/templates/nginx.conf.template

RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]