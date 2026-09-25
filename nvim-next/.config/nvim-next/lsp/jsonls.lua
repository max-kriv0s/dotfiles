-- JSON. Схемы из schemastore: package.json, tsconfig, eslint, prettier и сотни других
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
