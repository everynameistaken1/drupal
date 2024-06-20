FROM nginx:stable-alpine-slim

RUN apk update --no-cache
RUN apk upgrade --no-cache

# So that you can run test for performance
RUN apk add apache2-utils parallel bash

# Makes sure that nginx is configured to
# have the correct path for where drupal
# directory is.
ARG projectName
ENV PROJECT_NAME=$projectName
COPY ./default.conf /etc/nginx/templates/nginx.conf.template
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]