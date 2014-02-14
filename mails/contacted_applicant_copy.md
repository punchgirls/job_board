Dear {{ post.company.name }},

This is a copy of the message you sent to: {{ developer.name }}

Subject: {{ subject }}
Message:
{{ body }}

This message was sent regarding the following job position:

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
