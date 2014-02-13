Dear {{ developer.name }},

We want to inform you that {{ post.company.name }} removed the following post:


{{ post.title }}

Tags: {{ post.tags }}

Location: {{ post.location }}
% if post.remote == "true"
(Work from anywhere)
% else
(On-site only)
% end

Description:
{{ post.description }}


Remember that there are a lot more jobs waiting at http://jobs.punchgirls.com !

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls
