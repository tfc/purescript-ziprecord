module Lerp where

import Prelude

import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as R
import Type.Prelude (class IsSymbol)
import Type.Proxy (Proxy)
import Data.Int (toNumber, round)
import Data.Array (zipWith)
import Heterogeneous.Mapping as HM

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

data LerpMapping items = LerpMapping Number { | items }

instance lerpMappingWithIndex ::
  ( IsSymbol sym
  , Row.Cons sym a x as
  , Lerp a
  ) =>
  HM.MappingWithIndex (LerpMapping as) (Proxy sym) a a where
  mappingWithIndex (LerpMapping n as) prop = lerp n (R.get prop as)

instance lerpRecordInstance ::
  ( RL.RowToList a t
  , HM.MapRecordWithIndex t (LerpMapping a) a a
  ) =>
  Lerp (Record a) where
  lerp n = HM.hmapWithIndex <<< LerpMapping n

