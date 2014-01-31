Job Board Auto-notice
=====================

Dear {{ post.company.name }},

We want to inform you that {{ application.developer.name }} has added a message to the following post application:

-----------------------------------------------------------------

{{ post.title }}

Description:
{{ post.description }}

-----------------------------------------------------------------

Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}
GitHub: [http://www.github.com/{{ application.developer.username }}] (http://www.github.com/{{ application.developer.username }})
% if application.developer.bio

Bio:
{{ application.developer.bio }}
% end
% if application.developer.url

URL: {{ application.developer.url }}
% end

Message:
{{ application.message }}

-----------------------------------------------------------------

Kind regards,

Job Board Team
