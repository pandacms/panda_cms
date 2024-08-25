module.exports = {
  content: [
    "./app/helpers/**/*.rb",
    "./app/components/**/*.rb",
    "./app/components/**/*.html.erb",
  ],
  theme: {
    extend: {
      colors: {
        panda: {
          light: "#86a9db",
          dark: "#404c5c",
          alternate: "#ea565d"
        }
      }
    },
  },
  plugins: [],
  prefix: "panda-cms-"
}
