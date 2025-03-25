import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    scores: Array,
    totalScore: Number
  }

  connect() {
    window.addEventListener('resize', this.resizeChart)
    this.initializeChart()
  }

  disconnect() {
    window.removeEventListener('resize', this.resizeChart)
  }

  getChartColors() {
    const score = this.totalScoreValue

    if (score <= 40) {
      return {
        background: 'rgba(34, 197, 94, 0.1)', // green-100 with lower opacity
        border: 'rgba(34, 197, 94, 0.4)'      // green-800 with lower opacity
      }
    } else if (score <= 70) {
      return {
        background: 'rgba(234, 179, 8, 0.1)',  // yellow-100 with lower opacity
        border: 'rgba(234, 179, 8, 0.4)'       // yellow-800 with lower opacity
      }
    } else {
      return {
        background: 'rgba(236, 47, 14, 0.1)', // red-100 with lower opacity
        border: 'rgba(236, 47, 14, 0.4)'      // red-800 with lower opacity
      }
    }
  }

  initializeChart() {
    const ctx = this.canvasTarget
    const colors = this.getChartColors()

    new Chart(ctx, {
      type: 'radar',
      data: {
        labels: [
          'Country',
          'Client',
          'Products & Services',
          'Distribution Channel',
          'Transaction'
        ],
        datasets: [{
          label: 'Score',
          data: this.scoresValue,
          fill: true,
          backgroundColor: colors.background,
          borderColor: colors.border,
          pointBackgroundColor: colors.border,
          pointBorderColor: '#fff',
          pointHoverBackgroundColor: '#fff',
          pointHoverBorderColor: colors.border,
          borderWidth: 1.5,
          lineTension: 0.2
        }]
      },
      options: {
        scales: {
          r: {
            angleLines: {
              display: true,
              color: '#e5e7eb', // light grey (gray-200)
              lineWidth: 0.5
            },
            grid: {
              color: '#e5e7eb', // light grey (gray-200)
              lineWidth: 0.5
            },
            suggestedMin: 0,
            suggestedMax: 100,
            ticks: {
              stepSize: 20,
              color: '#9ca3af', // medium grey (gray-400)
              backdropColor: 'transparent'
            },
            pointLabels: {
              font: {
                size: 14,
                weight: '500'
              },
              color: '#4b5563' // gray-600 for better readability
            }
          }
        },
        plugins: {
          legend: {
            display: false
          }
        }
      }
    })
  }

  resizeChart() {
    if (window.Chart && window.Chart.instances) {
      Object.values(window.Chart.instances).forEach(chart => {
        chart.resize()
      })
    }
  }
} 