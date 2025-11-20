FROM node:24

ADD . /work
WORKDIR /work

RUN npm install

ENTRYPOINT [ "npm", "run" ]
CMD [ "lint" ]
