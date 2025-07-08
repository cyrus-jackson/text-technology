<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>Investments Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
      </head>
      <body class="bg-light">
        <div class="container py-5">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3">💼 Investments Overview</h1>
            <a href="/report" class="btn btn-outline-primary">Full Report</a>
          </div>

          <div class="row g-4">
            <xsl:for-each select="investments/investment">
              <div class="col-md-6 col-lg-4">
                <div class="card shadow-sm h-100">
                  <div class="card-body d-flex flex-column">
                    <h5 class="card-title mb-2">
                      <xsl:value-of select="place"/>
                    </h5>
                    <h6 class="card-subtitle text-muted mb-3">
                      <xsl:value-of select="news_article_date"/>
                    </h6>

                    <p class="card-text small mb-2">
                      <strong>Amount:</strong> <xsl:value-of select="amount"/><br/>
                      <strong>Jobs:</strong> <xsl:value-of select="jobs_count"/><br/>
                      <strong>Funding Related:</strong> <xsl:value-of select="funding_related"/><br/>
                      <strong>Status:</strong> <xsl:value-of select="funding_status"/>
                    </p>

                    <p class="card-text">
                      <xsl:value-of select="summary"/>
                    </p>

                    <a href="{link}" target="_blank" class="mt-auto btn btn-sm btn-primary">View Source</a>
                  </div>
                </div>
              </div>
            </xsl:for-each>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
