module.exports = {
  purge: {
    enabled: false,
    content: [
      'app/**/*.haml',
      'app/**/*.css',
    ]
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
