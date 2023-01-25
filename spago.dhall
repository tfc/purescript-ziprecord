{ name = "my-project"
, dependencies =
  [ "aff"
  , "effect"
  , "prelude"
  , "record"
  , "spec"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
