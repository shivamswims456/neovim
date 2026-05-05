return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "javascript",
            "typescript",
          },
          init_options = {
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = "always",
            showSuggestionsAsSnippets = true,
            includeLanguages = {
              javascript = "html",
              typescript = "html",
            },
            preferences = {
              ["output.selfClosingStyle"] = "html",
            },
            syntaxProfiles = {},
            variables = {},
          },
        },
      },
    },
  },
}
