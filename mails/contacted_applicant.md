Dear {{ developer.name }},

{{ company.name }} wants to get in contact with you and sent you the following message:

Subject: {{ subject }}
Message:
{{ body }}

This message was sent regarding the following job position:

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

To respond to this e-mail just click on "Reply".

Good luck!

Kind regards,

Cecilia & Mayn,
Punchgirls

http://twitter.com/punchgirls
http://www.punchgirls.com
http://github.com/punchgirls
