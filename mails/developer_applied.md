Job Board Auto-notice
==============

Dear {{ post.company.name }},

We want to inform you that {{ application.developer.name }} has applied to the following post:

----------------------------------------------------------

{{ post.title }}

Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}
GitHub: <http://www.github.com/{{ application.developer.username }}>
% if application.developer.bio

Bio: {{ application.developer.bio }}
% end

----------------------------------------------------------

Kind regards,

Job Board Team
