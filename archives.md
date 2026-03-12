---
layout: default
title: Chapter Archives
---

# 📡 Chapter Archives
*Accessing encrypted campaign logs...*

<div class="archive-list">
  {% assign sorted_logs = site.static_files | where_exp: "item", "item.path contains 'Chapter_Logs/'" | where_exp: "item", "item.extname == '.md'" %}
  
  {% assign logs = site.pages | where: "layout", "log-entry" | sort: "order" %}

  {% for log in logs %}
  <div class="panel archive-item">
    <div style="display: flex; justify-content: space-between; align-items: center;">
      <div>
        <a href="{{ log.url | relative_url }}" class="archive-link">
          <strong>{{ log.title }}</strong>
        </a>
      </div>
      <span class="timestamp" style="font-size: 0.7rem;">FILE_ID: {{ log.name | replace: '.md', '' }}</span>
    </div>
  </div>
  {% endfor %}
</div>

<style>
  .archive-item {
    transition: transform 0.2s ease, border-color 0.2s ease;
    margin-bottom: 10px;
  }
  .archive-item:hover {
    transform: translateX(5px);
    border-color: var(--sw-blue);
    background: rgba(88, 166, 255, 0.05);
  }
  .archive-link {
    font-size: 1.1rem;
    letter-spacing: 0.5px;
  }
</style>