export default [
  {
    files: ["**/*.js", "**/*.ts"],
    languageOptions: {
      ecmaVersion: 2017,
      sourceType: "module",
      parser: "@typescript-eslint/parser",
      parserOptions: {
        project: "./tsconfig.json",
      },
    },
    plugins: {
      "@typescript-eslint": "@typescript-eslint",
      "import": "import",
    },
    rules: {
      "quotes": ["error", "double"],
      "indent": ["error", 2],
      "object-curly-spacing": ["error", "never"],
      "max-len": ["error", {"code": 120}],
    },
    ignores: [
      "lib/**",
      "node_modules/**",
    ],
  },
];
