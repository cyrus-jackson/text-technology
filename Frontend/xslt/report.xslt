<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Investments Full Report</title>
        <script><![CDATA[
          function onPlaceChange() {
            var place = document.getElementById('place-filter').value;
            window.location.href = '/report?place=' + encodeURIComponent(place);
          }
          window.onload = function() {
            fetch('/places')
              .then(res => res.text())
              .then(str => (new window.DOMParser()).parseFromString(str, 'text/xml'))
              .then(xml => {
                var sel = document.getElementById('place-filter');
                var places = xml.getElementsByTagName('place');
                for (var i = 0; i < places.length; i++) {
                  var p = places[i];
                  var opt = document.createElement('option');
                  opt.value = p.textContent;
                  opt.text = p.textContent;
                  sel.add(opt);
                }
                var params = new URLSearchParams(window.location.search);
                if (params.get('place')) sel.value = params.get('place');
              });
          };
        ]]></script>
      </head>
      <body>
        <h1>Full Report</h1>
        <label for="place-filter">Filter by Place:</label>
        <select id="place-filter" onchange="onPlaceChange()">
          <option value="">-- All --</option>
        </select>
        <table border="1">
          <tr>
            <th>Link</th><th>Place</th><th>Date</th><th>Amount</th><th>Jobs</th>
            <th>Funding?</th><th>Status</th><th>Notes</th><th>Summary</th>
          </tr>
          <xsl:for-each select="investments/investment">
            <tr>
              <td><a href="{link}"><xsl:value-of select="link"/></a></td>
              <td><xsl:value-of select="place"/></td>
              <td><xsl:value-of select="news_article_date"/></td>
              <td><xsl:value-of select="amount"/></td>
              <td><xsl:value-of select="jobs_count"/></td>
              <td><xsl:value-of select="funding_related"/></td>
              <td><xsl:value-of select="funding_status"/></td>
              <td><xsl:value-of select="notes"/></td>
              <td><xsl:value-of select="summary"/></td>
            </tr>
          </xsl:for-each>
        </table>
        <p><a href="/">Back to Dashboard</a></p>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
