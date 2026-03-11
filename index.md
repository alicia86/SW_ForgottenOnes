---
layout: default
title: Home
---

<div class="hero-section">
  <img src="{{ site.baseurl }}/assets/internal/logo.png" alt="Forgotten Ones Logo" class="site-logo">
  <p class="flavor-text">Centuries after the fall of the Republic, an ancient cryo-ark awakens over Bespin. The past is forgotten. The future is uncertain.</p>
</div>

<div class="dashboard-grid">
  
  <section class="update-panel">
    <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
    <ul class="log-list">
      {% for page in site.pages %}
        {% if page.path contains 'Chapter_Logs/' and page.extname == '.md' %}
        <li>
          <a href="{{ site.baseurl }}{{ page.url }}">
            <span class="chapter-date">{{ page.date | date: "%b %d" }}</span>
            <span class="chapter-title">{{ page.title }}</span>
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
