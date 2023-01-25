module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import ZipRecord (foo)

main :: Effect Unit
main = launchAff_ $ runSpec [ consoleReporter ] do
  describe "Foo class" do
    it "correctly foos ints" do
      foo 1 2 `shouldEqual` 3
    it "correctly foos Floats" do
      foo 1.0 2.0 `shouldEqual` 3.0
    it "correctly foos Strings" do
      foo "foo" "bar" `shouldEqual` "foobar"
    it "correctly foos non-nested records" do
      foo { a: 1 } { a: 2 } `shouldEqual` { a: 3 }
    it "correctly foos nested records" do
      let
        a =
          { a: 1.0
          , b: 1
          , c:
              { d: 10.0
              , e: "a"
              }
          }
        b =
          { a: 2.0
          , b: 2
          , c:
              { d: 20.0
              , e: "b"
              }
          }
        c =
          { a: 3.0
          , b: 3
          , c:
              { d: 30.0
              , e: "ab"
              }
          }
      foo a b `shouldEqual` c
