---
layout: json-viewer
title: Chapter Logs
---

<script>
document.addEventListener("DOMContentLoaded", function() {
    const picker = document.getElementById('chapter-picker');
    
    // 1. Gather logs from Jekyll's static files
    const logs = [
      {% assign json_logs = site.static_files | where_exp: "file", "file.path contains 'Chapter_Logs/JSON/'" %}
      {% for file in json_logs %}
        { "name": "{{ file.name }}", "base": "{{ file.basename }}" }{% unless forloop.last %},{% endunless %}
      {% endfor %}
    ];

    // 2. Sort them (Chapter 4 should be above Chapter 1)
    logs.sort((a, b) => b.base.localeCompare(a.base));

    // 3. Set the picker to the latest log and trigger the load
    if (logs.length > 0 && picker) {
        picker.value = logs[0].name;
        // Small timeout ensures the layout's JS has initialized
        setTimeout(() => {
            window.loadChapter(logs[0].name);
        }, 100);
    }
});
</script>