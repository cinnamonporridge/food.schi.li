const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/components/**/*.html.haml',
    './app/components/**/*.rb',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './config/settings.yml'
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
