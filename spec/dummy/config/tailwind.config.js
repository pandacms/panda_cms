module.exports = {
  content: {
    relative: true,
    files: [
      "../public/*.html",
      "../app/views/**/*.html.erb",
      "../app/components/**/*.html.erb",
      "../app/components/**/*.rb",
      "../app/helpers/**/*.rb",
      "../app/javascript/**/*.js",
      "../vendor/javascript/**/*.js",
    ],
  },
  theme: {},
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
