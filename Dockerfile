FROM jekyll/jekyll:stable

WORKDIR /workdir
COPY . ./

RUN jekyll build

EXPOSE 4000

CMD ["jekyll", "server", "--drafts"]
