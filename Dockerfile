FROM jekyll/jekyll:stable

WORKDIR /workdir

COPY . ./

RUN chown -R root:root /workdir
RUN chmod -R 0777 /workdir

ENV JEKYLL_ENV=production
RUN jekyll build

EXPOSE 4000

CMD ["jekyll", "server", "--drafts"]
