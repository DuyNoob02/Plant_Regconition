/** @type {import('tailwindcss').Config} */
// export default {
//   content: [],
//   
//   theme: {
//     extend: {},
//   },
//   plugins: [],
// }

// tailwind.config.js
export default {
  // purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
 // or 'media' or 'class'
  theme: {
    extend: {},
  },
  media: false,

  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  variants: {
    extend: {},
  },
  plugins: [],
}