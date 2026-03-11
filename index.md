---
layout: default
title: Home
---

<div class="hero-section">
  <img src="{{ site.baseurl }}assets/internal/logo.png" alt="Forgotten Ones Logo" class="site-logo">
  <p class="flavor-text">Placeholder</p>
</div>

<div class="dashboard-grid">  
  <section class="update-panel">
    <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
    <ul class="log-list">
      {% comment %} 1. Filter files in the Chapter_Logs folder {% endcomment %}
      {% assign all_logs = site.static_files | where_exp: "file", "file.path contains 'Chapter_Logs/'" %}      
      {% comment %} 2. Sort by modified_time (most recent first) {% endcomment %}
      {% assign sorted_logs = all_logs | sort: "modified_time" | reverse %}    
      {% comment %} 3. Display the top 5 {% endcomment %}
      {% for file in sorted_logs limit:5 %}
        {% if file.extname == '.md' %}
        <li>
          <a href="{{ site.baseurl }}{{ file.path }}">
            <span class="chapter-date">{{ file.modified_time | date: "%b %d" }}</span>
            <span class="chapter-title">
              {% if file.path contains 'Prelude' %}
                [Prelude] {{ file.basename | replace: 'FO_BB_Prelude-', '' | replace: '-', ' ' }}
              {% else %}
                {{ file.basename | replace: 'FO_Ch', 'Ch ' | replace: '-', ' ' | replace: '_', ' ' }}
              {% endif %}
            </span>
          </a>
        </li>
        {% endif %}
      {% endfor %}
    </ul>
    <a href="{{ site.baseurl }}/logs" class="view-all">View Full Archive →</a>
  </section>

  <section class="wiki-panel">
    <h3><span class="icon">🗂️</span> Datapad Database</h3>
    <div class="wiki-cards">
      <a href="{{ site.baseurl }}/wiki/Characters" class="wiki-card">
        <strong>The Crew</strong>
        <span>Profiles of the survivors.</span>
      </a>
      <a href="{{ site.baseurl }}/wiki/The-Venture" class="wiki-card">
        <strong>The Venture</strong>
        <span>Technical specs of the Ark.</span>
      </a>
      <a href="{{ site.baseurl }}/wiki/Cloud-City" class="wiki-card">
        <strong>Bespin Lore</strong>
        <span>Mining colony intelligence.</span>
      </a>
    </div>
  </section>

</div>
