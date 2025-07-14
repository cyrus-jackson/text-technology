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
            <header class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3">Recent Investments</h1>
            <a href="/report" class="btn btn-outline-primary">Full Report</a>
            </header>
        
            <div class="row g-4">
            <xsl:for-each select="investments/investment">
                <div class="col-md-6 col-lg-4">
                <article class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                    <h2 class="card-title h5 mb-2">
                        <xsl:value-of select="place"/>
                    </h2>
                    <time class="card-subtitle text-muted mb-3" datetime="{news_article_date}">
                        <xsl:value-of select="news_article_date"/>
                    </time>
        
                    <ul class="list-unstyled small mb-3">
                        <li><strong>Amount:</strong> <xsl:value-of select="amount"/></li>
                        <li><strong>Jobs:</strong> <xsl:value-of select="jobs_count"/></li>
                        <li><strong>Funding Related:</strong> <xsl:value-of select="funding_related"/></li>
                        <li>
                        <strong>Status:</strong>
                        <xsl:choose>
                            <xsl:when test="funding_status = 'Closed'">
                            <span class="badge bg-success"><xsl:value-of select="funding_status"/></span>
                            </xsl:when>
                            <xsl:when test="funding_status = 'Pending'">
                            <span class="badge bg-warning text-dark"><xsl:value-of select="funding_status"/></span>
                            </xsl:when>
                            <xsl:when test="funding_status = 'Cancelled'">
                            <span class="badge bg-danger"><xsl:value-of select="funding_status"/></span>
                            </xsl:when>
                            <xsl:otherwise>
                            <span class="badge bg-secondary"><xsl:value-of select="funding_status"/></span>
                            </xsl:otherwise>
                        </xsl:choose>
                        </li>
                    </ul>
        
                    <p class="card-text mb-4">
                        <xsl:value-of select="summary"/>
                    </p>
        
                    <a href="{link}"
                        target="_blank"
                        class="mt-auto btn btn-sm btn-primary">
                        View Source
                    </a>
                    </div>
                </article>
                </div>
            </xsl:for-each>
            </div>
        </div>
        </body>

    </html>
  </xsl:template>
</xsl:stylesheet>
