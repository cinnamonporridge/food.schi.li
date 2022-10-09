const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.{html,rb}'
  ],
  theme: {
    extend: {
      fontSize: {
        '2xs': '0.625rem'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
  ]
}
