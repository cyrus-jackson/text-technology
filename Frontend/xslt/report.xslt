<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:param name="current_funding_status" select="''"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Investments Full Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="/static/styles.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40JuKHRr2SPMqKxkvlWEEyNCpWwzMXzBrcs4fR70JjrNKBLnKsyNoYpTqynPhgKsMhJ3bzxj8W6qQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

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
                var currentPlace = params.get('place') || '';
                var currentStatus = params.get('funding_status') || ''; // Get current funding_status from URL

                var list = document.createElement('div');
                list.className = 'list-group list-group-flush';

                var allLink = document.createElement('a');
                // Build the 'All' places link, preserving funding_status
                allLink.href = '/report' + (currentStatus ? '?funding_status=' + encodeURIComponent(currentStatus) : '');
                allLink.className = 'list-group-item list-group-item-action' + (currentPlace === '' ? ' active' : '');
                allLink.textContent = 'All';
                list.appendChild(allLink);

                for (var i = 0; i < places.length; i++) {
                  var p = places[i];
                  var name = p.textContent;
                  var link = document.createElement('a');
                  // Build link for each place, preserving funding_status
                  var href = '/report?place=' + encodeURIComponent(name);
                  if (currentStatus) {
                    href += '&funding_status=' + encodeURIComponent(currentStatus);
                  }
                  link.href = href;
                  link.className = 'list-group-item list-group-item-action' + (name === currentPlace ? ' active' : '');
                  link.textContent = name;
                  list.appendChild(link);
                }
                sidebar.appendChild(list);
              }
            };
            sel.send();
          }

          // Function to apply server-side filter when status dropdown changes
          function applyServerFilter() {
            const selectElement = document.getElementById('statusFilter');
            const selectedStatus = selectElement.value;

            const params = new URLSearchParams(window.location.search);
            const currentPlace = params.get('place'); // Get current place from URL

            let newUrl = '/report';
            const newParams = new URLSearchParams();

            if (currentPlace) {
              newParams.set('place', currentPlace);
            }
            if (selectedStatus) { // Only add funding_status if a specific status is selected (not 'All')
              newParams.set('funding_status', selectedStatus);
            }

            if (newParams.toString()) {
              newUrl += '?' + newParams.toString();
            }

            window.location.href = newUrl; // Redirect to the new URL
          }

          window.onload = loadPlaces; // Still call loadPlaces on load
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
            <nav id="sidebar" class="col-md-3 col-lg-2">
            </nav>

            <main class="col-md-9 col-lg-10 px-4 py-4">
              <div class="d-flex justify-content-between align-items-center">
                <h2>Full Investments Report</h2>
                <a href="/" class="btn btn-outline-secondary">Back to Dashboard</a>
              </div>

              <div class="mt-3 mb-4">
                <h4>Funding Status Overview:</h4>
                <div class="d-flex flex-wrap gap-2">
                  <xsl:for-each select="investments/investment[not(funding_status = preceding-sibling::investment/funding_status)]">
                    <xsl:sort select="funding_status" />
                    <span class="badge rounded-pill px-3 py-2 text-uppercase fw-bold">
                      <xsl:attribute name="class">
                        <xsl:text>badge rounded-pill px-3 py-2 text-uppercase fw-bold </xsl:text>
                        <xsl:choose>
                          <xsl:when test="funding_status = 'Allocated'">bg-success</xsl:when>
                          <xsl:when test="funding_status = 'Planned'">bg-info text-dark</xsl:when>
                          <xsl:when test="funding_status = 'Potential'">bg-warning text-dark</xsl:when>
                          <xsl:otherwise>bg-secondary</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:variable name="currentStatus" select="funding_status"/>
                      <xsl:value-of select="$currentStatus"/>:
                      <xsl:value-of select="count(//investment[funding_status = $currentStatus])"/>
                    </span>
                  </xsl:for-each>
                </div>
              </div>

              <div class="mt-3 mb-4">
                <label for="statusFilter" class="form-label fw-semibold">Filter by Status:</label>
                <select id="statusFilter" class="form-select w-auto d-inline-block" onchange="applyServerFilter()">
                  <option value="">All</option>
                  <option value="Allocated">
                    <xsl:if test="$current_funding_status = 'Allocated'">selected</xsl:if>
                    Allocated
                  </option>
                  <option value="Planned">
                    <xsl:if test="$current_funding_status = 'Planned'">selected</xsl:if>
                    Planned
                  </option>
                  <option value="Potential">
                    <xsl:if test="$current_funding_status = 'Potential'">selected</xsl:if>
                    Potential
                  </option>
                </select>
              </div>

              <div class="list-group">
                <xsl:for-each select="investments/investment">
                  <div class="list-group-item list-group-item-action py-3 mb-3 rounded-3 shadow-sm d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
                    <div class="flex-grow-1 me-md-3 mb-2 mb-md-0">
                      <h5 class="mb-1 fw-bold text-dark">
                        <xsl:value-of select="summary"/>
                      </h5>
                      <small class="text-muted d-block mb-2">
                        Date: <xsl:value-of select="news_article_date"/>
                      </small>
                      <xsl:if test="place">
                          <div class="d-flex align-items-center text-muted mb-2">
                              <i class="fas fa-map-marker-alt me-1"></i>
                              <span><xsl:value-of select="place"/></span>
                          </div>
                      </xsl:if>
                      <div class="d-flex flex-wrap gap-3 mt-2 text-sm">
                        <div class="d-flex align-items-center">
                            <xsl:choose>
                                <xsl:when test="number(amount) > 0">
                                    <i class="fas fa-euro-sign icon-euro-dark me-1"></i>
                                    <strong class="d-inline-flex align-items-center">
                                        <span class="d-none d-sm-inline me-1">Amount:</span>
                                        €<xsl:value-of select="format-number(amount, '#,##0')" />
                                    </strong>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span class="text-muted fst-italic">Amount: Not Specified</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </div>
                        <div class="d-flex align-items-center">
                            <xsl:choose>
                                <xsl:when test="number(jobs_count) > 0">
                                    <i class="fas fa-users icon-jobs-dark me-1"></i>
                                    <strong class="d-inline-flex align-items-center">
                                        <span class="d-none d-sm-inline me-1">Jobs:</span>
                                        <xsl:value-of select="format-number(jobs_count, '#,##0')" />
                                    </strong>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span class="text-muted fst-italic">Jobs: Not Specified</span>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                      </div>
                    </div>

                    <div class="d-flex flex-column align-items-start align-items-md-end gap-2">
                      <span class="badge rounded-pill px-3 py-2 text-uppercase fw-bold">
                        <xsl:attribute name="class">
                          <xsl:text>badge rounded-pill px-3 py-2 text-uppercase fw-bold </xsl:text>
                          <xsl:choose>
                            <xsl:when test="funding_status = 'Allocated'">bg-success</xsl:when>
                            <xsl:when test="funding_status = 'Planned'">bg-info text-dark</xsl:when>
                            <xsl:when test="funding_status = 'Potential'">bg-warning text-dark</xsl:when>
                            <xsl:otherwise>bg-secondary</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="funding_status"/>
                      </span>
                      <a href="{link}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill px-3">View Source</a>
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
