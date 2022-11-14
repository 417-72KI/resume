FROM node:19

ADD . /work
WORKDIR /work

RUN npm install

ENTRYPOINT [ "npm", "run" ]
CMD [ "lint" ]
