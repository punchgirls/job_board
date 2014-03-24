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
	env $$(cat env.sh) irb -r ./app

test:
	env $$(cat env.sh) cutest test/**/*.rb

push:
	git push

db:
	ruby seed.rb

workers-start:
	env $$(cat env.sh) ost -d deleted_company
	env $$(cat env.sh) ost -d welcome_company
	env $$(cat env.sh) ost -d password_changed
	env $$(cat env.sh) ost -d canceled_subscription
	env $$(cat env.sh) ost -d activated_subscription
	env $$(cat env.sh) ost -d discarded_applicant
	env $$(cat env.sh) ost -d contacted_applicant
	env $$(cat env.sh) ost -d deleted_post
	env $$(cat env.sh) ost -d welcome_developer
	env $$(cat env.sh) ost -d developer_applied
	env $$(cat env.sh) ost -d deleted_application
	env $$(cat env.sh) ost -d developer_sent_message
	env $$(cat env.sh) ost -d deleted_developer
	env $$(cat env.sh) ost -d contact_us
	env $$(cat env.sh) ost -d new_post

workers-stop:
	kill $$(cat workers/deleted_company.pid)
	kill $$(cat workers/welcome_company.pid)
	kill $$(cat workers/password_changed.pid)
	kill $$(cat workers/canceled_subscription.pid)
	kill $$(cat workers/activated_subscription.pid)
	kill $$(cat workers/discarded_applicant.pid)
	kill $$(cat workers/contacted_applicant.pid)
	kill $$(cat workers/deleted_post.pid)
	kill $$(cat workers/welcome_developer.pid)
	kill $$(cat workers/developer_applied.pid)
	kill $$(cat workers/deleted_application.pid)
	kill $$(cat workers/developer_sent_message.pid)
	kill $$(cat workers/deleted_developer.pid)
	kill $$(cat workers/contact_us.pid)
	kill $$(cat workers/new_post.pid)
