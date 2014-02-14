Dear {{ post.company.name }},

This is to inform you that {{ application.developer.name }} has removed the application to the following post:

Applicant information:

Name: {{ application.developer.name }}
Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}
GitHub: http://www.github.com/{{ application.developer.username }}
% if application.developer.url
URL: {{ application.developer.url }}
% end
% if application.developer.bio
Bio:
{{ application.developer.bio }}
% end

Full post details:

Post title: {{ post.title }}
Company: {{ post.company.name }} ({{ post.company.url }})
% tags = post.tags.split(",").join(", ")
Tags: {{ tags }}
Location: {{ post.location }}
% if post.remote == "true"
(Work from anywhere)
% else
(On-site only)
% end
Description:
{{ post.description }}

Kind regards,

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls

