<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Germany Investments and Stats</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
          thead th { position: sticky; top: 0; background: #f8f9fa; z-index: 1; }
          .card:hover { transform: scale(1.02); transition: 0.3s ease-in-out; cursor: pointer; }
          .card-icon { font-size: 1.5rem; margin-right: 5px; }
          .section-title { border-left: 5px solid #0d6efd; padding-left: 10px; margin-bottom: 1rem; font-weight: 600; }
					header{background-color:#f8f9fa;box-shadow:0 2px 4px rgba(0,0,0,.1);border-bottom:2px solid #dee2e6}
					.project-title{font-weight:700;font-size:1.8rem;color:#000;margin-bottom:.2rem}
					.subtitle{font-size:.95rem;color:#6c757d}
					.contributors span{background-color:#e6e6e6;color:#000;padding:.35rem .75rem;border-radius:15px;font-weight:600;font-size:.9rem;margin-left:.5rem;user-select:none;transition:background-color .3s;cursor:default}
					.contributors span:first-child{margin-left:0}
					.contributors span:hover{background-color:#d4d4d4}
        </style>
      </head>
      <body class="bg-light">
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
        <div class="container py-4">
          <!-- Electricity Section -->
          <h4 class="section-title">⚡Latest Electricity Stats </h4>
          <xsl:variable name="latestElec" select="germany_stats/electricity/document[last()]"/>
          <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-5">
            <div class="col">
              <div class="card text-bg-light border-primary shadow-sm rounded-3">
                <div class="card-body text-center">
                  <h6 class="card-title text-primary">
                    <i class="bi bi-lightning-fill card-icon"></i>Today's Price (€/MWh)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/today_price"/></p>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card text-bg-light border-secondary shadow-sm rounded-3">
                <div class="card-body text-center">
                  <h6 class="card-title text-secondary">
                    <i class="bi bi-calendar-week-fill card-icon"></i>Day Ahead Price (€/MWh)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/day_ahead_price"/></p>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card text-bg-light border-info shadow-sm rounded-3">
                <div class="card-body text-center">
                  <h6 class="card-title text-info">
                    <i class="bi bi-graph-up-arrow card-icon"></i>Consumption Forecast (MWh)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestElec/consumption_forecast"/></p>
                </div>
              </div>
            </div>
          </div>

					<div class="row">
            <div class="col-md-6">
							<h4 class="section-title">📊 Electricity Price Trend</h4>
							<canvas id="priceChart" class="mb-5" height="100"></canvas>
						</div>
						
						<div class="col-md-6">
							<h4 class="section-title">📊 Electricity Consumption Trend</h4>
							<canvas id="consumptionChart" class="mb-5" height="100"></canvas>
						</div>
					</div>

          <!-- Fuel Section -->
					<xsl:variable name="latestFuel" select="germany_stats/fuel_prices/document[last()]"/>
          <h4 class="section-title">⛽ Latest Fuel Prices</h4>
					<div class="row row-cols-1 row-cols-md-2 row-cols-lg-5 g-4 mb-5">
            <div class="col">
              <div class="card text-bg-light shadow-sm rounded-3" style="border: 2px solid rgba(255, 99, 132, 1)">
                <div class="card-body text-center">
                  <h6 class="card-title" style="color: rgba(255, 99, 132, 1)">
                    <i></i>Diesel (€/l)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestFuel/Diesel"/></p>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card text-bg-light shadow-sm rounded-3" style="border: 2px solid rgba(54, 162, 235, 1)">
                <div class="card-body text-center">
                  <h6 class="card-title" style="color: rgba(54, 162, 235, 1)">
                    <i></i>Premium 98 (€/l)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestFuel/Premium_98"/></p>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card text-bg-light shadow-sm rounded-3" style="border: 2px solid rgba(255, 206, 86, 1)">
                <div class="card-body text-center">
                  <h6 class="card-title" style="color: rgba(255, 206, 86, 1)">
                    <i></i>LPG (€/l)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestFuel/LPG"/></p>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card text-bg-light shadow-sm rounded-3" style="border: 2px solid rgba(75, 192, 192, 1)">
                <div class="card-body text-center">
                  <h6 class="card-title" style="color: rgba(75, 192, 192, 1)">
                    <i></i>Benzine 95-E10 (€/l)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestFuel/Benzine_95_E10"/></p>
                </div>
              </div>
            </div>
						<div class="col">
              <div class="card text-bg-light shadow-sm rounded-3" style="border: 2px solid rgba(153, 102, 255, 1)">
                <div class="card-body text-center">
                  <h6 class="card-title" style="color: rgba(153, 102, 255, 1)">
                    <i></i>Super 95 (€/l)
                  </h6>
                  <p class="card-text fs-5"><xsl:value-of select="$latestFuel/Super_95"/></p>
                </div>
              </div>
            </div>
          </div>
					
					<div class="row">
						<div class="col-md-12">
							<h4 class="section-title">📉 Fuel Prices Trend</h4>
							<canvas id="fuelChart" height="100"></canvas>
						</div>
					</div>
        </div>

        <script type="text/javascript">
					const priceLabels = [
						<xsl:for-each select="germany_stats/electricity/document">
							"<xsl:value-of select="@id"/>"<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					];

					const priceData = [
						<xsl:for-each select="germany_stats/electricity/document">
							<xsl:value-of select="today_price"/><xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					];

					new Chart(document.getElementById('priceChart'), {
						type: 'line',
						data: {
							labels: priceLabels,
							datasets: [{
								label: 'Electricity Price (€/MWh)',
								data: priceData,
								fill: true,
								backgroundColor: 'rgba(75, 192, 192, 0.5)',
								borderColor: 'rgba(75, 192, 192, 1)',
								borderWidth: 1,
								tension: 0.3
							}]
						},
						options: {
							responsive: true,
							plugins: {
								legend: { position: 'top' },
								tooltip: { mode: 'index', intersect: false }
							},
							interaction: {
								mode: 'nearest',
								axis: 'x',
								intersect: false
							},
							scales: {
								y: {
									beginAtZero: true
								}
							}
						}
					});
					
					const consumptionLabels = [
						<xsl:for-each select="germany_stats/electricity/document">
							"<xsl:value-of select="@id"/>"<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					];

					const consumptionData = [
						<xsl:for-each select="germany_stats/electricity/document">
							<xsl:value-of select="consumption"/><xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					];

					new Chart(document.getElementById('consumptionChart'), {
						type: 'line',
						data: {
							labels: consumptionLabels,
							datasets: [{
								label: 'Grid Load (MWh)',
								data: consumptionData,
								fill: true,
								backgroundColor: 'rgba(75, 192, 192, 0.5)',
								borderColor: 'rgba(75, 192, 192, 1)',
								borderWidth: 1,
								tension: 0.3
							}]
						},
						options: {
							responsive: true,
							plugins: {
								legend: { position: 'top' },
								tooltip: { mode: 'index', intersect: false }
							},
							interaction: {
								mode: 'nearest',
								axis: 'x',
								intersect: false
							},
							scales: {
								y: {
									beginAtZero: true
								}
							}
						}
					});
					
				const fuelLabels = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						"<xsl:value-of select="@id"/>"<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];

				const dieselData = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						<xsl:value-of select="Diesel"/><xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];

				const super95Data = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						<xsl:value-of select="Super_95"/><xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];
				
				const premium98Data = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						<xsl:value-of select="Premium_98"/><xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];

				const lpgData = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						<xsl:value-of select="LPG"/><xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];

				const benzineE10Data = [
					<xsl:for-each select="germany_stats/fuel_prices/document">
						<xsl:value-of select="Benzine_95_E10"/><xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				];


				new Chart(document.getElementById('fuelChart'), {
					type: 'line',
					data: {
						labels: fuelLabels,
						datasets: [
							{
								label: 'Diesel',
								data: dieselData,
								borderColor: 'rgba(255, 99, 132, 1)',
								backgroundColor: 'rgba(255, 99, 132, 0.2)',
								tension: 0.3
							},
							{
								label: 'Premium 98',
								data: premium98Data,
								borderColor: 'rgba(54, 162, 235, 1)',
								backgroundColor: 'rgba(54, 162, 235, 0.2)',
								tension: 0.3
							},
							{
								label: 'LPG',
								data: lpgData,
								borderColor: 'rgba(255, 206, 86, 1)',
								backgroundColor: 'rgba(255, 206, 86, 0.2)',
								tension: 0.3
							},
							{
								label: 'Benzine 95-E10',
								data: benzineE10Data,
								borderColor: 'rgba(75, 192, 192, 1)',
								backgroundColor: 'rgba(75, 192, 192, 0.2)',
								tension: 0.3
							},
							{
								label: 'Super 95',
								data: super95Data,
								borderColor: 'rgba(153, 102, 255, 1)',
								backgroundColor: 'rgba(153, 102, 255, 0.2)',
								tension: 0.3
							}
						]
					},
					options: {
						responsive: true,
						plugins: {
							legend: { position: 'top' },
							tooltip: { mode: 'index', intersect: false }
						},
						interaction: {
							mode: 'nearest',
							axis: 'x',
							intersect: false
						},
						scales: {
							y: {
								beginAtZero: false,
								title: {
									display: true,
									text: 'Price in €/l'
								}
							},
							x: {
								title: {
									display: true,
									text: 'Date'
								}
							}
						}
					}
				});
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
