Dear {{ post.company.name }},

We want to inform you that {{ application.developer.name }} removed her/his profile and because of that the application for the following post has been deleted:


{{ post.title }}

Description:
{{ post.description }}


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

Cecilia & Mayn
Punchgirls
team@punchgirls.com
http://twitter.com/punchgirls
