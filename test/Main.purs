module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Interpolate (interpolate)

main :: Effect Unit
main = launchAff_ $ runSpec [ consoleReporter ] do
  describe "Interpolate class" do
    it "correctly interpolates ints" do
      interpolate 0.0 0 10 `shouldEqual` 0
      interpolate 0.1 0 10 `shouldEqual` 1
      interpolate 0.5 0 10 `shouldEqual` 5
      interpolate 1.0 0 10 `shouldEqual` 10
    it "correctly interpolates Floats" do
      interpolate 0.0 0.0 10.0 `shouldEqual` 0.0
      interpolate 0.5 0.0 10.0 `shouldEqual` 5.0
      interpolate 1.0 0.0 10.0 `shouldEqual` 10.0
    it "correctly interpolates Booleans" do
      interpolate 0.0 false true `shouldEqual` false
      interpolate 0.1 false true `shouldEqual` false
      interpolate 0.5 false true `shouldEqual` true
      interpolate 1.0 false true `shouldEqual` true
    it "correctly interpolates non-nested records" do
      interpolate 0.5 { a: 0 } { a: 10 } `shouldEqual` { a: 5 }
    it "correctly interpolates nested records" do
      let
        a =
          { a: 0.0
          , b: 0
          , c:
              { d: 0.0
              , e: false
              }
          }
        b =
          { a: 10.0
          , b: 10
          , c:
              { d: 10.0
              , e: true
              }
          }
        c =
          { a: 7.0
          , b: 7
          , c:
              { d: 7.0
              , e: true
              }
          }
      interpolate 0.7 a b `shouldEqual` c
