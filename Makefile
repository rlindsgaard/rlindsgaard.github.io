all: clean build serve

serve:
	bundle exec jekyll serve --livereload --drafts

build:
	bundle exec jekyll build

clean:
	bundle exec jekyll clean
