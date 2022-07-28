
local config = {
  cmd = {

    'java', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-javaagent:/home/liam-epam/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar',
    --'-Xbootclasspath/a:/home/liam-epam/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar',
    '-jar', '/home/liam-epam/java_language_server/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',

    '-configuration', '/home/liam-epam/java_language_server/config_linux/',


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', '/home/liam-epam/Collibra/workspace'
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
        settings = {
    java = {
      eclipse = {

        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",

        "java.util.Objects.requireNonNullElse",

        "org.mockito.Mockito.*",
      },
    },
    contentProvider = { preferred = "fernflower" },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)


if ft == "java" then
  keymap_c = {
    name = "Code",
    o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
    v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
    t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
    n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
  }
  keymap_c_v = {
    name = "Code",
    v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
    m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
  }
end

