---
layout: default
title: Campaign Logs
---

# Adventure Logs

<ul>
  {% for p in site.pages %}
    {% if p.path contains 'Chapter_Logs/' %}
      <li>
        <a href="{{ site.baseurl }}{{ p.url }}">{{ p.title | default: p.name }}</a>
      </li>
    {% endif %}
  {% endfor %}
</ul>
