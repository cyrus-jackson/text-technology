<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>Germany Investments and Stats</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
      </head>
      <body class="bg-light">
        <div class="container py-5">
          <h1 class="mb-4">⚡ Electricity Prices</h1>

          <!-- Latest Electricity Card -->
          <xsl:variable name="latestElec" select="germany_stats/electricity/document[1]"/>
          <div class="row mb-5">
            <div class="col-md-6 col-lg-3">
              <div class="card text-bg-light border-primary shadow-sm">
                <div class="card-body">
                  <h6 class="card-title text-primary">Today Price</h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/today_price"/></p>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-3">
              <div class="card text-bg-light border-success shadow-sm">
                <div class="card-body">
                  <h6 class="card-title text-success">Consumption</h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/consumption"/></p>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-3">
              <div class="card text-bg-light border-warning shadow-sm">
                <div class="card-body">
                  <h6 class="card-title text-warning">Day Ahead Price</h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/day_ahead_price"/></p>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-3">
              <div class="card text-bg-light border-info shadow-sm">
                <div class="card-body">
                  <h6 class="card-title text-info">Forecast</h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/consumption_forecast"/></p>
                </div>
              </div>
            </div>
          </div>

          <!-- Electricity Table -->
          <h3 class="mb-3">📈 Electricity Stats</h3>
          <div class="table-responsive mb-5">
            <table class="table table-bordered table-striped table-hover table-sm">
              <thead class="table-secondary">
                <tr>
                  <th>Date</th>
                  <th>Today Price</th>
                  <th>Consumption</th>
                  <th>Day Ahead Price</th>
                  <th>Forecast</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="germany_stats/electricity/document">
                  <tr>
                    <td><xsl:value-of select="@id"/></td>
                    <td><xsl:value-of select="today_price"/></td>
                    <td><xsl:value-of select="consumption"/></td>
                    <td><xsl:value-of select="day_ahead_price"/></td>
                    <td><xsl:value-of select="consumption_forecast"/></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <!-- Latest Fuel Prices Card -->
          <xsl:variable name="latestFuel" select="germany_stats/fuel_prices/document[1]"/>
          <div class="row mb-4">
            <div class="col-12">
              <h3>⛽ Latest Fuel Prices Summary</h3>
            </div>
            <xsl:for-each select="$latestFuel/*">
              <div class="col-6 col-md-4 col-lg-2 mb-3">
                <div class="card text-bg-light border-secondary shadow-sm">
                  <div class="card-body text-center">
                    <h6 class="card-title text-secondary">
                      <xsl:value-of select="name()"/>
                    </h6>
                    <p class="card-text fs-5">
                      <xsl:value-of select="."/>
                    </p>
                  </div>
                </div>
              </div>
            </xsl:for-each>
          </div>

          <!-- Fuel Prices Table -->
          <h3 class="mb-3">⛽ Fuel Prices</h3>
          <div class="table-responsive">
            <table class="table table-bordered table-striped table-hover table-sm">
              <thead class="table-secondary">
                <tr>
                  <th>Date</th>
                  <th>Benzine 95-E10</th>
                  <th>Diesel</th>
                  <th>LPG</th>
                  <th>Premium 98</th>
                  <th>Super 95</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="germany_stats/fuel_prices/document">
                  <tr>
                    <td><xsl:value-of select="@id"/></td>
                    <xsl:for-each select="*">
                      <td><xsl:value-of select="."/></td>
                    </xsl:for-each>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
