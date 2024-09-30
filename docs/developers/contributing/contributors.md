---
title: Contributors
layout: default
parent: Contributing
---

## Contributors

We are grateful to the following people for their contributions:

<ul class="list-style-none">
{% for contributor in site.github.contributors %}
  <li class="d-inline-block mr-1">
     <a href="{{ contributor.html_url }}"><img src="{{ contributor.avatar_url }}" width="64" height="64" alt="{{ contributor.login }}" style="border-radius: 50%"></a>
  </li>
{% endfor %}
</ul>
