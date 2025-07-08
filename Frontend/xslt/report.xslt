<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Investments Full Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <style>
          body { background-color: #f8f9fa; }
          #sidebar { max-height: 90vh; overflow-y: auto; }
        </style>
        <script><![CDATA[
          function loadPlaces() {
            var sel = new XMLHttpRequest();
            sel.open('GET', '/places', true);
            sel.onload = function() {
              if (this.status === 200) {
                var xml = (new DOMParser()).parseFromString(this.responseText, 'application/xml');
                var places = xml.getElementsByTagName('place');
                var sidebar = document.getElementById('sidebar');
                var params = new URLSearchParams(window.location.search);
                var current = params.get('place') || '';
                // "All" link
                var allLink = document.createElement('a');
                allLink.href = '/report';
                allLink.className = 'list-group-item list-group-item-action' + (current === '' ? ' active' : '');
                allLink.textContent = 'All';
                sidebar.appendChild(allLink);
                for (var i = 0; i < places.length; i++) {
                  var p = places[i];
                  var name = p.textContent;
                  var link = document.createElement('a');
                  link.href = '/report?place=' + encodeURIComponent(name);
                  link.className = 'list-group-item list-group-item-action' + (name === current ? ' active' : '');
                  link.textContent = name;
                  sidebar.appendChild(link);
                }
              }
            };
            sel.send();
          }
          window.onload = loadPlaces;
        ]]></script>
      </head>
      <body>
        <div class="container-fluid">
          <div class="row">
            <!-- Sidebar -->
            <nav id="sidebar" class="col-md-3 col-lg-2 bg-white border-end">
              <div class="list-group list-group-flush"></div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 col-lg-10 px-4 py-4">
              <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h4">Full Investments Report</h1>
                <a href="/" class="btn btn-outline-secondary">Back to Dashboard</a>
              </div>

              <div class="row g-4">
                <xsl:for-each select="investments/investment">
                  <div class="col-sm-12 col-md-6 col-lg-4">
                    <div class="card h-100 shadow-sm">
                      <div class="card-body d-flex flex-column">
                        <h5 class="card-title mb-1 text-primary">
                          <a href="{link}" target="_blank" class="stretched-link text-decoration-none">Investment in <xsl:value-of select="place"/></a>
                        </h5>
                        <h6 class="card-subtitle mb-2 text-muted small">
                          <xsl:value-of select="news_article_date"/>
                        </h6>
                        <ul class="list-unstyled small mb-3">
                          <li><strong>Amount:</strong> <xsl:value-of select="amount"/></li>
                          <li><strong>Jobs:</strong> <xsl:value-of select="jobs_count"/></li>
                          <li><strong>Funding?</strong> <xsl:value-of select="funding_related"/></li>
                          <li><strong>Status:</strong> <xsl:value-of select="funding_status"/></li>
                          <li><strong>Notes:</strong> <xsl:value-of select="notes"/></li>
                        </ul>
                        <p class="card-text text-truncate mb-2">
                          <xsl:value-of select="summary"/>
                        </p>
                        <a href="{link}" target="_blank" class="mt-auto btn btn-sm btn-primary">Read More</a>
                      </div>
                    </div>
                  </div>
                </xsl:for-each>
              </div>
            </main>
          </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
