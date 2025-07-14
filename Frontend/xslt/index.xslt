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
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <h1 class="h3 mb-0">Recent Investments</h1>
        <a href="/report" class="btn btn-outline-primary">Full Report</a>
        </div>

        <!-- Cards Grid -->
        <div class="row g-4">
    <xsl:for-each select="investments/investment">
        <div class="col-sm-6 col-lg-4">
        <div class="card modern-card shadow-sm h-100 position-relative border-0 rounded-3">
            <xsl:variable name="status" select="funding_status" />
            <xsl:choose>
            <xsl:when test="$status = 'Allocated'">
                <span class="position-absolute top-0 end-0 m-3 badge rounded-pill bg-success px-3 py-2 text-uppercase fw-bold">Allocated</span>
            </xsl:when>
            <xsl:when test="$status = 'Planned'">
                <span class="position-absolute top-0 end-0 m-3 badge rounded-pill bg-info text-dark px-3 py-2 text-uppercase fw-bold">Planned</span>
            </xsl:when>
            <xsl:when test="$status = 'Potential'">
                <span class="position-absolute top-0 end-0 m-3 badge rounded-pill bg-warning text-dark px-3 py-2 text-uppercase fw-bold">Potential</span>
            </xsl:when>
            <xsl:otherwise>
                <span class="position-absolute top-0 end-0 m-3 badge rounded-pill bg-secondary px-3 py-2 text-uppercase fw-bold">
                <xsl:value-of select="$status" />
                </span>
            </xsl:otherwise>
            </xsl:choose>

            <div class="card-body d-flex flex-column p-4">
            <h5 class="card-title mb-1 text-primary fw-bold fs-5">
                <xsl:value-of select="place" />
            </h5>
            <small class="text-muted mb-3 d-block text-sm">
                <xsl:value-of select="news_article_date" />
            </small>

            <div class="investment-stats mb-3 d-flex justify-content-around align-items-center">
                <div class="stat-item text-center">
                <i class="fas fa-euro-sign icon-euro-dark me-1"></i> <strong class="d-block">
                    <xsl:choose>
                    <xsl:when test="number(amount) > 0">
                        <xsl:value-of select="format-number(amount, '#,##0')" />
                    </xsl:when>
                    <xsl:otherwise>Not Specified</xsl:otherwise>
                    </xsl:choose>
                </strong>
                <small class="text-muted">Amount</small>
                </div>
                <div class="stat-item text-center">
                <i class="fas fa-users icon-jobs-dark me-1"></i> <strong class="d-block">
                    <xsl:choose>
                    <xsl:when test="number(jobs_count) > 0">
                        <xsl:value-of select="format-number(jobs_count, '#,##0')" />
                    </xsl:when>
                    <xsl:otherwise>Not Specified</xsl:otherwise>
                    </xsl:choose>
                </strong>
                <small class="text-muted">Jobs</small>
                </div>
            </div>


            <p class="card-text mb-4 flex-grow-1 text-secondary">
                <xsl:value-of select="summary" />
            </p>

            <a href="{link}" target="_blank" class="btn btn-primary mt-auto align-self-start px-4 py-2 rounded-pill">Read More</a>
            </div>
        </div>
        </div>
    </xsl:for-each>
    </div>

<style>
  .modern-card {
    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
  }

  .modern-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
  }

  .card-title {
    font-size: 1.25rem;
  }

  .text-sm {
    font-size: 0.875em;
  }

  .text-secondary {
    color: #6c757d;
    line-height: 1.6;
  }

  .badge.rounded-pill {
      padding-top: .4em;
      padding-bottom: .4em;
  }

  .investment-stats {
    border-top: 1px solid #eee;
    border-bottom: 1px solid #eee;
    padding: 1rem 0;
    margin-bottom: 1.5rem !important;
  }

  .stat-item {
    flex-basis: 48%;
  }

  .stat-item strong {
    font-size: 1.25rem;
    color: #343a40;
  }

  .stat-item small {
    display: block;
    font-size: 0.8rem;
    color: #6c757d;
    margin-top: .2rem;
  }

  .stat-item .fas {
    font-size: 1rem;
    vertical-align: middle;
  }

  .icon-euro-dark {
    color: #28a745;
  }

  .icon-jobs-dark {
    color: #007bff;
  }
</style>
  </div>
</body>


    </html>
  </xsl:template>
</xsl:stylesheet>
