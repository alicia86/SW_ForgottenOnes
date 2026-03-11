---
layout: default
title: Home
---

<div class="hero-section">
  <img src="{{ '/assets/internal/logo.png' | relative_url }}" alt="Forgotten Ones Logo" class="site-logo">
  <p class="flavor-text">A long time ago, in a galaxy far, far away...</p>
</div>

<div class="dashboard-grid">  
  <section class="update-panel">
    <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
    <ul class="log-list">
      {% comment %} 1. Filter for .md files in Chapter_Logs directly {% endcomment %}
      {% assign all_logs = site.static_files | where_exp: "file", "file.path contains 'Chapter_Logs/'" %}
      {% assign md_files = all_logs | where_exp: "file", "file.extname == '.md'" %}
      
      {% comment %} 
         2. Sort by mtime (filesystem modified time). 
         Note: If your files sync all at once, they may have identical timestamps.
         In that case, sorting by "path" reverse is a perfect fallback for FO_Ch names.
      {% endcomment %}
      {% assign sorted_logs = md_files | sort: "mtime" | reverse %}
      
      {% for file in sorted_logs limit:5 %}
        <li>
          <a href="{{ file.path | relative_url }}">
            <span class="chapter-title">
              {% if file.path contains 'Prelude' %}
                <small style="color: #8b949e;">[PRELUDE]</small> {{ file.basename | replace: 'FO_BB_Prelude-', '' | replace: '_', ' ' | replace: '-', ' ' }}
              {% else %}
                {{ file.basename | replace: 'FO_Ch', 'Chapter ' | replace: '-', ' ' | replace: '_', ' ' }}
              {% endif %}
            </span>
          </a>
        </li>
      {% endfor %}
    </ul>
    <a href="{{ '/logs' | relative_url }}" class="view-all">View Full Archive →</a>
  </section>

  <section class="wiki-panel">
    <h3><span class="icon">🗂️</span> Datapad Database</h3>
    <div class="wiki-cards">
      <a href="{{ '/wiki/Characters' | relative_url }}" class="wiki-card">
        <strong>The Crew</strong>
        <span>Profiles of the survivors.</span>
      </a>
      <a href="{{ '/wiki/The-Venture' | relative_url }}" class="wiki-card">
        <strong>The Venture</strong>
        <span>Technical specs of the Ark.</span>
      </a>
      <a href="{{ '/wiki/Cloud-City' | relative_url }}" class="wiki-card">
        <strong>Bespin Lore</strong>
        <span>Mining colony intelligence.</span>
      </a>
    </div>
  </section>
</div>
