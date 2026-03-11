---
layout: json-viewer
title: Dynamic Datapad Reader
---

<script>
document.addEventListener("DOMContentLoaded", function() {
    const picker = document.getElementById('chapter-picker');
    const logs = [
      {% assign json_logs = site.static_files | where_exp: "file", "file.path contains 'Chapter_Logs/JSON/'" %}
      {% for file in json_logs %}
        { "name": "{{ file.basename }}", "file": "{{ file.name }}" }{% unless forloop.last %},{% endunless %}
      {% endfor %}
    ];

    // Sort by name (Ch1, Ch2, etc)
    logs.sort((a, b) => a.name.localeCompare(b.name)).reverse();

    logs.forEach(log => {
        let opt = document.createElement('option');
        opt.value = log.file;
        opt.innerHTML = log.name.replace(/_/g, ' ');
        picker.appendChild(opt);
    });

    // Auto-load the first (latest) log
    if (logs.length > 0) {
        window.loadChapter(logs[0].file);
    }
});
</script>
