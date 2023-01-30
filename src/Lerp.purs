module Lerp where

import Prelude

import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as R
import Type.Prelude (class IsSymbol)
import Type.Proxy (Proxy(..))
import Record.Builder (Builder)
import Record.Builder as Builder
import Data.Int (toNumber, round)
import Data.Array (zipWith)

class Lerp a where
  lerp :: Number -> a -> a -> a

instance lerpNumber :: Lerp Number where
  lerp n a b = a + (b - a) * n

instance lerpInt :: Lerp Int where
  lerp n a b = round $ lerp n (toNumber a) (toNumber b)

instance lerpBoolean :: Lerp Boolean where
  lerp n a b = roundBool $ lerp n (fromBool a) (fromBool b)
    where
    fromBool = if _ then 1.0 else 0.0
    roundBool x = round x > 0

instance lerpArray :: Lerp a => Lerp (Array a) where
  lerp n a b = zipWith (lerp n) a b

class
  LerpRecord
    (rl :: RL.RowList Type)
    (r :: Row Type)
    (from :: Row Type)
    (to :: Row Type)
  | rl -> r from to
  where
  lerpRecordImpl
    :: Number
    -> Proxy rl
    -> Record r
    -> Record r
    -> Builder { | from } { | to }

instance lerpRecordNil :: LerpRecord RL.Nil trashA () () where
  lerpRecordImpl _ _ _ _ = identity

instance lerpRecordCons ::
  ( LerpRecord t r from to'
  , Row.Cons k a trashA r
  , Row.Cons k a to' to
  , Row.Lacks k to'
  , IsSymbol k
  , Lerp a
  ) =>
  LerpRecord (RL.Cons k a t) r from to where
  lerpRecordImpl n _ a b = current <<< next
    where
    current = Builder.insert key lerpedValue
    next = lerpRecordImpl n tail a b
    lerpedValue = lerp n (R.get key a) (R.get key b)
    key = Proxy :: _ k
    tail = Proxy :: _ t

lerpRecord
  :: forall t r
   . RL.RowToList r t
  => LerpRecord t r () r
  => Number
  -> Record r
  -> Record r
  -> Record r
lerpRecord n a b = Builder.build builder {}
  where
  tail = Proxy :: _ t
  builder = lerpRecordImpl n tail a b

instance lerpRecordInstance ::
  ( RL.RowToList a t
  , LerpRecord t a () a
  ) =>
  Lerp (Record a) where
  lerp = lerpRecord
