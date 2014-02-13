Dear {{ developer.name }},

This is to inform you that {{ post.company.name }} removed their profile and the following post has been
deleted:

Post title: {{ post.title }}
Company: {{ post.company.name }} ({{ post.company.url }})
Tags: {{ post.tags }}
Location: {{ post.location }}
% if post.remote == "true"
(Work from anywhere)
% else
(On-site only)
% end
Description:
{{ post.description }}

Remember there are more jobs waiting for you at http://jobs.punchgirls.com!

Kind regards,

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls
