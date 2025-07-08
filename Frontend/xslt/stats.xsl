<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Firestore Data Display</title>
        <style>
          body { font-family: Arial, sans-serif; padding: 20px; }
          h2 { margin-top: 40px; }
          table { border-collapse: collapse; width: 100%; margin-top: 10px; }
          th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
          th { background-color: #eee; }
        </style>
      </head>
      <body>

        <!-- ELECTRICITY TABLE -->
        <h2>Electricity Data</h2>
        <table>
          <tr>
            <th>Date</th>
            <th>Today Price</th>
            <th>Consumption</th>
            <th>Day Ahead Price</th>
            <th>Consumption Forecast</th>
          </tr>
          <xsl:for-each select="germany_stats/electricity/document">
            <tr>
              <td><xsl:value-of select="@id"/></td>
              <td><xsl:value-of select="today_price"/></td>
              <td><xsl:value-of select="consumption"/></td>
              <td><xsl:value-of select="day_ahead_price"/></td>
              <td><xsl:value-of select="consumption_forecast"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- FUEL PRICES TABLE -->
        <h2>Fuel Prices</h2>
        <table>
          <tr>
            <th>Date</th>
            <th>Benzine 95-E10</th>
            <th>Diesel</th>
            <th>LPG</th>
						<th>Premium 98</th>
						<th>Super 95</th>
          </tr>

          <xsl:for-each select="germany_stats/fuel_prices/document">
            <tr>
              <td><xsl:value-of select="@id"/></td>
              <!-- Loop through all child elements -->
              <xsl:for-each select="*">
                <td><xsl:value-of select="."/></td>
              </xsl:for-each>
            </tr>
          </xsl:for-each>
        </table>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
