NAME = blog
JEKYLL_VERSION = 3.8
WORKING_DIRECTORY = $(shell pwd)
all: clean build serve

update:
	docker run --rm --volume="$(WORKING_DIRECTORY):/srv/jekyll" -it jekyll/jekyll:$(JEKYLL_VERSION) bundle update

serve:
	docker run --name $(NAME) --volume="$(WORKING_DIRECTORY):/srv/jekyll" -p 4000:4000 -it jekyll/jekyll:$(JEKYLL_VERSION) jekyll serve --watch --drafts

shell:
	docker exec -ti $(NAME) /bin/sh

build:
	docker run --rm --volume="$(WORKING_DIRECTORY):/srv/jekyll" -it jekyll/jekyll:$(JEKYLL_VERSION) bundle exec jekyll build

clean:
	docker rm -f $(NAME)
	# docker run --rm --volume="$(WORKING_DIRECTORY):/srv/jekyll" -it jekyll/jekyll:$(JEKYLL_VERSION) bundle exec jekyll clean
