Dear {{ post.company.name }},

We want to inform you that {{ application.developer.name }} has removed the application regarding the following post:


{{ post.title }}

Description:
{{ post.description }}


Applicant: {{ application.developer.name }}

Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}

GitHub: http://www.github.com/{{ application.developer.username }}
% if application.developer.bio

Bio:
{{ application.developer.bio }}
% end
% if application.developer.url

URL: {{ application.developer.url }}
% end
% if application.message

Message:
{{ application.message }}
% end


Kind regards,

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls
