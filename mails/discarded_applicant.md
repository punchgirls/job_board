Dear {{ developer.name }},

We are sorry to inform you that you have not been selected for the following job position:


{{ post.title }}
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


Remember that there are a lot more jobs waiting at http://jobs.punchgirls.com !

Cecilia & Mayn
Punchgirls
team@punchgirls.com
http://twitter.com/punchgirls
