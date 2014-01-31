Job Board Auto-notice
=====================

Dear {{ developer.name }},
We are sorry to inform you that '{{ post.company.name }}' removed the following post:

-----------------------------------------------------------------

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

-----------------------------------------------------------------

Remember that there are a lot more jobs waiting at Job Board (http://os-job-board.herokuapp.com)!

Job Board Team
