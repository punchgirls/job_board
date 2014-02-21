Dear {{ developer.name }},

This is to inform you that you have not been selected for the following position:

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

The company will still be able to see your application.

Don't worry to much, there are more jobs waiting for you at
http://jobs.punchgirls.com!

Kind regards,

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls
