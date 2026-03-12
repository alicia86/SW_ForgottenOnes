---
layout: default
title: Home
---

<div class="hero-section">
  <img src="{{ '/assets/logo.png' | relative_url }}" alt="Forgotten Ones Logo" class="site-logo">
  <p class="flavor-text">A long time ago, in a galaxy far, far away...</p>
</div>

<div class="dashboard-grid">  
  <section class="update-panel">
  <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
  <ul class="log-list">
    {% comment %} 1. Filter for logs in the folder {% endcomment %}
    {% assign log_pages = site.pages | where_exp: "p", "p.path contains 'Chapter_Logs/'" %}
    
    {% comment %} 2. Sort by our new 'order' field (Newest/Highest Chapter first) {% endcomment %}
    {% assign sorted_logs = log_pages | sort: "order" | reverse %}

    {% for p in sorted_logs limit:5 %}
      <li>
        <a href="{{ p.url | relative_url }}">
          <span class="chapter-title">{{ p.title }}</span>
        </a>
      </li>
    {% endfor %}
  </ul>
  <a href="{{ '/archives' | relative_url }}" class="view-all">View Full Archive →</a> 
</section>
<section class="wiki-panel">
  <!--  Disable the wiki section for the time being until ready to implement it
    <h3><span class="icon">🗂️</span> Datapad Database</h3>
    <div class="wiki-cards">
      <a href="{{ '/wiki/Characters' | relative_url }}" class="wiki-card">
        <strong>The Crew</strong>
        <span>Profiles of the survivors.</span>
      </a> <br />
      <a href="{{ '/wiki/The-Venture' | relative_url }}" class="wiki-card">
        <strong>The Venture</strong>
        <span>Technical specs of the Ark.</span>
      </a> <br />
      <a href="{{ '/wiki/Cloud-City' | relative_url }}" class="wiki-card">
        <strong>Bespin Lore</strong>
        <span>Mining colony intelligence.</span>
      </a> <br />
    </div>
    For now provide a link back to the wiki -->    
      <h3><span class="icon">🗂️</span> <a href="https://github.com/alicia86/SW_ForgottenOnes/wiki" class="wiki-card"> Wiki </a></h3>
  </section>  
  
</div>
