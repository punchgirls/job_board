Dear {{ post.company.name }},

This is to inform you that {{ application.developer.name }} has applied to the {{ post.title }} position:

Applicant information:

Name: {{ application.developer.name }}
Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}
GitHub: https://www.github.com/{{ application.developer.username }}
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
% if post.location
Location: {{ post.location }}
% else
Location: Not specified
% end
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

https://twitter.com/punchgirls
http://www.punchgirls.com
https://github.com/punchgirls
