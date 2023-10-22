FROM node:21

ADD . /work
WORKDIR /work

RUN npm install

ENTRYPOINT [ "npm", "run" ]
CMD [ "lint" ]
