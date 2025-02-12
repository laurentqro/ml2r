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
        background: 'rgba(34, 197, 94, 0.2)', // green-100
        border: 'rgb(34, 197, 94)'           // green-800
      }
    } else if (score <= 70) {
      return {
        background: 'rgba(234, 179, 8, 0.2)',  // yellow-100
        border: 'rgb(234, 179, 8)'            // yellow-800
      }
    } else {
      return {
        background: 'rgba(236, 47, 14, 0.2)', // red-100
        border: 'rgb(236, 47, 14)'           // red-800
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
          pointHoverBorderColor: colors.border
        }]
      },
      options: {
        scales: {
          r: {
            angleLines: {
              display: true
            },
            suggestedMin: 0,
            suggestedMax: 100,
            ticks: {
              stepSize: 20
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