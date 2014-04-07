Dear {{ developer.name }},

{{ company.name }} wants to get in contact with you and sent you the following message:

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

To respond to this e-mail just click on "Reply".

Good luck!

Kind regards,

Cecilia & Mayn,
Punchgirls

https://twitter.com/jobspunchgirls
http://www.punchgirls.com
https://github.com/punchgirls
