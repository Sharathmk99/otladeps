#############
### build ###
#############

# base image
FROM jekyll/jekyll:stable as build

RUN mkdir /workdir
RUN chmod 0777 /workdir
COPY . /workdir
WORKDIR /workdir


RUN jekyll build


EXPOSE 4000

CMD ["jekyll", "server", "--drafts"]
