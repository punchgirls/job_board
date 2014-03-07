Dear {{ developer.name }},

This is to inform you that {{ post.company.name }} removed the following post:

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

Remember there are more jobs waiting for you at https://jobs.punchgirls.com !

Kind regards,

Cecilia & Mayn,
Punchgirls

https://twitter.com/punchgirls
http://www.punchgirls.com
https://github.com/punchgirls
