Dear {{ post.posted_by }},

This is a copy of the message you sent to: {{ developer.name }}

Subject: {{ subject }}
Message:
{{ body }}

This message was sent regarding the following job position:

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
