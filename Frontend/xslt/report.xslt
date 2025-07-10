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
          #sidebar { max-height: 100vh; overflow-y: auto; background-color: #fff; padding-top: 1rem; border-right: 1px solid #dee2e6; }
          #sidebar .list-group-item:hover { background-color: #f1f1f1; }
          .report-section { padding: 1rem 0; border-bottom: 1px solid #dee2e6; }
          .report-heading { font-size: 1.25rem; font-weight: 600; color: #0d6efd; text-decoration: none; }
          .report-subtitle { font-size: 0.95rem; color: #6c757d; margin-bottom: 0.75rem; }
					header{background-color:#f8f9fa;box-shadow:0 2px 4px rgba(0,0,0,.1);border-bottom:2px solid #dee2e6}
					.project-title{font-weight:700;font-size:1.8rem;color:#000;margin-bottom:.2rem}
					.subtitle{font-size:.95rem;color:#6c757d}
					.contributors span{background-color:#e6e6e6;color:#000;padding:.35rem .75rem;border-radius:15px;font-weight:600;font-size:.9rem;margin-left:.5rem;user-select:none;transition:background-color .3s;cursor:default}
					.contributors span:first-child{margin-left:0}
					.contributors span:hover{background-color:#d4d4d4}
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
                var list = document.createElement('div');
                list.className = 'list-group list-group-flush';

                var allLink = document.createElement('a');
                allLink.href = '/report';
                allLink.className = 'list-group-item list-group-item-action' + (current === '' ? ' active' : '');
                allLink.textContent = 'All';
                list.appendChild(allLink);

                for (var i = 0; i < places.length; i++) {
                  var p = places[i];
                  var name = p.textContent;
                  var link = document.createElement('a');
                  link.href = '/report?place=' + encodeURIComponent(name);
                  link.className = 'list-group-item list-group-item-action' + (name === current ? ' active' : '');
                  link.textContent = name;
                  list.appendChild(link);
                }
                sidebar.appendChild(list);
              }
            };
            sel.send();
          }
          window.onload = loadPlaces;
        ]]></script>
      </head>
      <body>
				<header class="py-3">
					<div class="container d-flex justify-content-between align-items-center">
						<div>
							<h1 class="project-title mb-0">Germany Stats and Investments from News Articles</h1>
							<div class="subtitle">Text Technology Coursework</div>
						</div>
						<div class="contributors d-flex">
							<span>Cyrus Dhara</span>
							<span>Dwarkesh Patel</span>
						</div>
					</div>
				</header>
        <div class="container-fluid">
          <div class="row">
            <!-- Sidebar -->
            <nav id="sidebar" class="col-md-3 col-lg-2">
              <!-- populated dynamically -->
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 col-lg-10 px-4 py-4">
              <div class="d-flex justify-content-between align-items-center">
                <h2>Full Investments Report</h2>
                <a href="/" class="btn btn-outline-secondary">Back to Dashboard</a>
              </div>

              <!-- Report Sections -->
              <div>
                <xsl:for-each select="investments/investment">
                  <div class="report-section">
                    <a href="{link}" target="_blank" class="report-heading d-block mb-1">
                      <xsl:value-of select="summary"/>
                    </a>
                    <div class="report-subtitle">
                      💰 Amount: <xsl:value-of select="amount"/> |
                      👷 Jobs: <xsl:value-of select="jobs_count"/> |
                      📌 Status: <xsl:value-of select="funding_status"/>
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
