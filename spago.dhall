{ name = "my-project"
, dependencies =
  [ "aff"
  , "arrays"
  , "effect"
  , "integers"
  , "prelude"
  , "record"
  , "spec"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
