-- jdtls roots at the nearest .git by default, which for a course repo means one
-- eclipse project spanning every assignment folder, with the repo root as the
-- single source folder. Every file then owes a package matching its path
-- (projects/3dsolids -> "projects.3dsolids", not even a legal package name), so
-- a class in the same folder can't be resolved and jdtls reddens the call --
-- while javac in that folder compiles fine.
--
-- Root at a real build file when there is one, otherwise at the file's own
-- directory: a folder of loose .java files in the default package is exactly
-- what jdtls expects a source root to look like.
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      root_dir = function(path)
        return vim.fs.root(path, {
          -- multi-module: outermost wins
          { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts" },
          -- single-module
          { "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" },
        }) or vim.fs.dirname(path)
      end,
    },
  },
}
