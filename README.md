# Purescript example: How to Zip Records with a Binary Function

Given an example typeclass `Foo` that provides a function `foo :: a -> a -> a`
for all members of the type class, how to make all possible records part of
this type class (Assuming all record members are themselves part of `Foo`)?

This is the target functionality:

```purescript
> import ZipRecord

-- simple merging of type class members Int, Number, and String:

> foo 1 2
3
> foo 1.0 2.0
3.0
> foo "foo" "bar"
"foobar"

-- Now let's merge records that have Int, Number, and String values:

> r1 = { a: 1, b: 1.0, c: { d: "foo", e: 10.0 } }
> r2 = { a: 2, b: 2.0, c: { d: "bar", e: 20.0 } }

> zipRecord r1 r2
{ a: 3, b: 3.0, c: { d: "foobar", e: 30.0 } }
```

## How to build and test

Either install `node`, `spago`, and `purescript` yourself, or just run a
[nix shell](https://nixos.org/download.html):

```sh
$ nix-shell

# build the product and run the unit tests
$ spago test
```
