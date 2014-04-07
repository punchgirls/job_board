Dear {{ developer.name }},

This is to inform you that you have not been selected for the following position:

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

Don't worry to much, there are more jobs waiting for you at https://jobs.punchgirls.com !

Kind regards,

Cecilia & Mayn,
Punchgirls

https://twitter.com/jobspunchgirls
http://www.punchgirls.com
https://github.com/punchgirls
