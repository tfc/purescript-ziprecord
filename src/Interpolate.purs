module Interpolate where

import Prelude

import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as R
import Type.Prelude (class IsSymbol)
import Type.Proxy (Proxy(..))
import Record.Builder (Builder)
import Record.Builder as Builder
import Data.Int (toNumber, round)

class Interpolate a where
  interpolate :: Number -> a -> a -> a

instance interpolateNumber :: Interpolate Number where
  interpolate n a b = a + (b - a) * n

instance interpolateInt :: Interpolate Int where
  interpolate n a b = round $ interpolate n (toNumber a) (toNumber b)

instance interpolateBoolean :: Interpolate Boolean where
  interpolate n a b = roundBool $ interpolate n (fromBool a) (fromBool b)
    where
    fromBool = if _ then 1.0 else 0.0
    roundBool x = round x > 0

class
  InterpolateRecord
    (rl :: RL.RowList Type)
    (r :: Row Type)
    (from :: Row Type)
    (to :: Row Type)
  | rl -> r from to
  where
  interpolateRecordImpl
    :: Number
    -> Proxy rl
    -> Record r
    -> Record r
    -> Builder { | from } { | to }

instance interpolateRecordNil :: InterpolateRecord RL.Nil trashA () () where
  interpolateRecordImpl _ _ _ _ = identity

instance interpolateRecordCons ::
  ( IsSymbol k
  , Row.Cons k a trashA r
  , Row.Cons k a from' to
  , Row.Lacks k from'
  , InterpolateRecord t r from from'
  , Interpolate a
  ) =>
  InterpolateRecord (RL.Cons k a t) r from to where
  interpolateRecordImpl n _ a b = current <<< next
    where
    current = Builder.insert name head
    next = interpolateRecordImpl n proxyA a b
    name = Proxy :: _ k
    head = interpolate n (R.get name a) (R.get name b)
    proxyA = Proxy :: _ t

interpolateRecord
  :: forall t r
   . RL.RowToList r t
  => InterpolateRecord t r () r
  => Number
  -> Record r
  -> Record r
  -> Record r
interpolateRecord n a b = Builder.build builder {}
  where
  proxyA = Proxy :: _ t
  builder = interpolateRecordImpl n proxyA a b

instance interpolateRecordInstance ::
  ( RL.RowToList a t
  , InterpolateRecord t a () a
  ) =>
  Interpolate (Record a) where
  interpolate = interpolateRecord
