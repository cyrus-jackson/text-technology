<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Investments Dashboard</title>
      </head>
      <body>
        <h1>Investments List</h1>
        <table border="1">
          <tr>
            <th>Link</th><th>Place</th><th>Date</th><th>Amount</th><th>Jobs</th>
            <th>Funding?</th><th>Status</th><th>Summary</th>
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
              <td><xsl:value-of select="summary"/></td>
            </tr>
          </xsl:for-each>
        </table>
        <p><a href="/report">Full Report &amp; Filter</a></p>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
