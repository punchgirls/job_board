Dear {{ post.posted_by }},

This is to inform you that {{ application.developer.name }} removed her/his profile and the application for the following
post was deleted:

Applicant information:

Name: {{ application.developer.name }}
Email: {{ application.developer.email }}
Applied on: {{ Time.at(application.date.to_i).strftime("%e %B %Y") }}
GitHub: https://www.github.com/{{ application.developer.username }}
% if application.developer.url
URL: {{ application.developer.url }}
% end
% if application.developer.bio
Bio:
{{ application.developer.bio }}
% end
% if application.message
Message:
{{ application.message }}
% end

Full post details:

Post title: {{ post.title }}
Company: {{ post.posted_by }} ({{ post.company_url }})
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

https://twitter.com/jobspunchgirls
http://www.punchgirls.com
https://github.com/punchgirls
