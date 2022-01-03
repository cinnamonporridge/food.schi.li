const colors = require('tailwindcss/colors')

module.exports = {
  // mode: 'jit',
  content: [
    './app/components/**/*.html.haml',
    './app/components/**/*.rb',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './config/settings.yml'
  ],
  plugins: [
    require('@tailwindcss/forms'),
  ]
}
