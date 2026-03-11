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
      {% assign logs = site.static_files | where_exp: "file", "file.path contains 'Chapter_Logs/'" %}
      {% for file in logs %}
        {% if file.extname == '.md' %}
        <li>
          <a href="{{ site.baseurl }}{{ file.path }}">
            <span class="chapter-date">{{ file.modified_time | date: "%b %d" }}</span>
            <span class="chapter-title">
              {{ file.basename | replace: "-", " " | replace: "_", " " | capitalize }}
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
