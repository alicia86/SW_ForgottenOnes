---
layout: default
title: Home
---
<style>
    .log-list li {
    padding: 15px 0;
    border-bottom: 1px solid var(--gh-border);
    transition: 0.2s;
}

.log-list li:hover {
    background: rgba(88, 166, 255, 0.03);
}

.log-info {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    flex-wrap: wrap;
    gap: 10px;
}

.chapter-title {
    font-weight: bold;
    color: var(--sw-blue);
    font-size: 1.1rem;
}

.dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 300px;
    gap: 30px;
    margin-top: 40px;
}

@media (max-width: 800px) {
    .dashboard-grid { grid-template-columns: 1fr; }
}

</style>

<div class="hero-section">
    <img src="{{ '/assets/logo.png' | relative_url }}" alt="Forgotten Ones Logo" class="site-logo">
    <p class="flavor-text">A long time ago, in a galaxy far, far away...</p>
</div>

<div class="dashboard-grid"> 
    <section class="update-panel">
        <h3><span class="icon">📡</span> Recent Chapter Logs</h3>
        <ul class="log-list" id="recent-logs-list">
            <li class="timestamp">Initializing holonet connection...</li>
        </ul>
        <a href="{{ '/archives' | relative_url }}" class="view-all">View Full Archive →</a> 
    </section>

    <section class="wiki-panel">
        <h3><span class="icon">🗂️</span> <a href="https://github.com/alicia86/SW_ForgottenOnes/wiki" class="wiki-card">Datapad Wiki</a></h3>
        <p class="subtext">Access encrypted database for character profiles and technical specs.</p>
    </section> 
</div>

<script>
document.addEventListener("DOMContentLoaded", async function() {
    const listContainer = document.getElementById('recent-logs-list');
    try {
        const response = await fetch("{{ '/assets/log-manifest.json' | relative_url }}?t=" + new Date().getTime());
        const manifest = await response.json();

        // Sort by lastMessageTimestamp (Newest first)
        const sorted = manifest.sort((a, b) => new Date(b.lastMessageTimestamp) - new Date(a.lastMessageTimestamp));
        
        listContainer.innerHTML = ""; // Clear loader

        sorted.slice(0, 5).forEach(log => {
            const date = new Date(log.lastMessageTimestamp).toLocaleDateString();
            const li = document.createElement('li');
            li.innerHTML = `
                <a href="{{ '/logs' | relative_url }}#${log.channelID}">
                    <div class="log-info">
                        <span class="chapter-title">${log.title}</span>
                        <span class="timestamp">${date} | ${log.participants} Active Signals</span>
                    </div>
                    <p class="subtext" style="margin-top:5px; opacity:0.7;">${log.preview}</p>
                </a>
            `;
            listContainer.appendChild(li);
        });
    } catch (e) {
        listContainer.innerHTML = "<li>Failed to retrieve recent transmissions.</li>";
    }
});
</script>
