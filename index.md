---
layout: default
title: Home
---

<div class="hero-section">
  <img src="{{ site.baseurl }}/assets/internal/logo.png" alt="Forgotten Ones Logo" class="site-logo">
  <p class="flavor-text">Placeholder</p>
</div>

<div class="dashboard-grid">  
  <section class="update-panel">
    <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
    <ul class="log-list">
      {% comment %} 1. Filter and Prepare Data {% endcomment %}
      {% assign all_logs = site.pages | where_exp: "p", "p.path contains 'Chapter_Logs/'" %}      
      {% comment %} 2. Sort by Filename (Prelude starts with P, Ch starts with C, so we reverse sort) {% endcomment %}
      {% assign sorted_logs = all_logs | sort: "path" | reverse %}  
      {% comment %} 3. Loop and Limit to the top 5 {% endcomment %}
      {% for p in sorted_logs limit:5 %}
        <li>
          <a href="{{ site.baseurl }}{{ p.url }}">
            <span class="chapter-title">
              {% if p.path contains 'Prelude' %}
                [Prelude] {{ p.title | default: p.name | replace: 'FO_BB_Prelude-', '' }}
              {% else %}
                {{ p.title | default: p.name }}
              {% endif %}
            </span>
          </a>
        </li>
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
