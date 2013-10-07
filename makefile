.PHONY: test

gems:
	which gs  || gem install gs
	which dep || gem install dep
	which shotgun || gem install shotgun
	gs init

install:
	dep install

server:
	env $$(cat env.sh) shotgun -o 0.0.0.0

console:
	env $$(cat env.sh) irb -r ./app -r ./cli

test:
	env $$(cat env.sh) cutest test/**/*.rb

push:
	git push
	git push heroku master

db:
	ruby seed.rb

