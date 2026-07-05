import { createChart, CandlestickSeries, LineSeries, createSeriesMarkers } from "lightweight-charts"

const CandleChart = {
  mounted() {
    this.renderChart(this.el.dataset.chart)
    this.resizeObserver = new ResizeObserver(() => this.resizeChart())
    this.resizeObserver.observe(this.el)

    this.handleEvent("chart-data", data => {
      this.renderChart(JSON.stringify(data))
    })
  },

  updated() {
    this.renderChart(this.el.dataset.chart)
  },

  destroyed() {
    if (this.resizeObserver) {
      this.resizeObserver.disconnect()
    }
    if (this.chart) {
      this.chart.remove()
      this.chart = null
    }
  },

  resizeChart() {
    if (this.chart) {
      this.chart.applyOptions({ width: this.el.clientWidth })
    }
  },

  renderChart(raw) {
    if (!raw || raw === "null") return

    const data = JSON.parse(raw)
    if (!data.candles || data.candles.length === 0) return

    if (this.chart) {
      this.chart.remove()
    }

    this.chart = createChart(this.el, {
      width: this.el.clientWidth,
      height: 720,
      layout: {
        background: { color: "#ffffff" },
        textColor: "#333"
      },
      grid: {
        vertLines: { color: "#f0f0f0" },
        horzLines: { color: "#f0f0f0" }
      },
      timeScale: {
        borderColor: "#d1d5db",
        timeVisible: true
      }
    })

    const candleSeries = this.chart.addSeries(CandlestickSeries, {
      upColor: "#26a69a",
      downColor: "#ef5350",
      borderVisible: false,
      wickUpColor: "#26a69a",
      wickDownColor: "#ef5350"
    }, 0)

    candleSeries.setData(
      data.candles.map(c => ({
        time: c.time,
        open: c.open,
        high: c.high,
        low: c.low,
        close: c.close
      }))
    )

    createSeriesMarkers(candleSeries, data.signals || [])

    this.chart.addPane()
    const rsiSeries = this.chart.addSeries(LineSeries, {
      color: "#2962ff",
      lineWidth: 2,
      title: "RSI14"
    }, 1)

    rsiSeries.setData(data.rsi || [])
    ;[30, 70].forEach(level => {
      rsiSeries.createPriceLine({
        price: level,
        color: "#9ca3af",
        lineWidth: 1,
        lineStyle: 2,
        axisLabelVisible: true,
        title: String(level)
      })
    })

    this.chart.addPane()
    const stochKSeries = this.chart.addSeries(LineSeries, {
      color: "#00897b",
      lineWidth: 2,
      title: "%K"
    }, 2)

    const stochDSeries = this.chart.addSeries(LineSeries, {
      color: "#e53935",
      lineWidth: 2,
      title: "%D"
    }, 2)

    stochKSeries.setData(data.stoch_k || [])
    stochDSeries.setData(data.stoch_d || [])

    ;[20, 80].forEach(level => {
      stochKSeries.createPriceLine({
        price: level,
        color: "#9ca3af",
        lineWidth: 1,
        lineStyle: 2,
        axisLabelVisible: true,
        title: String(level)
      })
    })

    this.chart.timeScale().fitContent()
  }
}

export default CandleChart
