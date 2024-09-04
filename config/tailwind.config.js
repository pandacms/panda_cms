module.exports = {
  content: {
    relative: true,
    files: [
      "../public/*.html",
      "../app/views/**/*.html.erb",
      "../app/builders/panda_cms/**/*.rb",
      "../app/components/panda_cms/**/*.html.erb",
      "../app/components/panda_cms/**/*.rb",
      "../app/helpers/panda_cms/**/*.rb",
      "../app/javascript/panda_cms/**/*.js",
      "../vendor/javascript/**/*.js",
    ],
  },
  theme: {
    colors: {
      transparent: "transparent",
      current: "currentColor",
      white: "rgb(var(--color-white) / <alpha-value>)",
      black: "rgb(var(--color-black) / <alpha-value>)",
      light: "rgb(var(--color-light) / <alpha-value>)",
      mid: "rgb(var(--color-mid) / <alpha-value>)",
      dark: "rgb(var(--color-dark) / <alpha-value>)",
      highlight: "rgb(var(--color-highlight) / <alpha-value>)",
      active: "rgb(var(--color-active) / <alpha-value>)",
      warning: "rgb(var(--color-warning) / <alpha-value>)",
      error: "rgb(var(--color-error) / <alpha-value>)",
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
