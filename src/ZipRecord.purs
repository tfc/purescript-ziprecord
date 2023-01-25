module ZipRecord where

import Prelude

import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as R
import Type.Prelude (class IsSymbol)
import Type.Proxy (Proxy(..))
import Record.Builder (Builder)
import Record.Builder as Builder

class Fooable a where
  foo :: a -> a -> a

instance fooableInt :: Fooable Int where
  foo a b = a + b

instance fooableNumber :: Fooable Number where
  foo a b = a + b

instance fooableString :: Fooable String where
  foo a b = a <> b

class
  ZipRecord
    (rl :: RL.RowList Type)
    (a :: Row Type)
    (from :: Row Type)
    (to :: Row Type)
  | rl -> a from to
  where
  zipRecordImpl
    :: Proxy rl
    -> Record a
    -> Record a
    -> Builder { | from } { | to }

instance zipRecordNil :: ZipRecord RL.Nil trashA () () where
  zipRecordImpl _ _ _ = identity

instance zipRecordCons ::
  ( IsSymbol k
  , Row.Cons k a trashA ra
  , Row.Cons k a from' to
  , Row.Lacks k from'
  , ZipRecord t ra from from'
  , Fooable a
  ) =>
  ZipRecord (RL.Cons k a t) ra from to where
  zipRecordImpl _ a b = Builder.insert name head <<< zipRecordImpl proxyA a b
    where
    name = Proxy :: _ k
    head = foo (R.get name a) (R.get name b)
    proxyA = Proxy :: _ t

zipRecord
  :: forall t r
   . RL.RowToList r t
  => ZipRecord t r () r
  => Record r
  -> Record r
  -> Record r
zipRecord a b = Builder.build builder {}
  where
  proxyA = Proxy :: _ t
  builder = zipRecordImpl proxyA a b

instance fooableRecord ::
  ( RL.RowToList a t
  , ZipRecord t a () a
  ) =>
  Fooable (Record a) where
  foo = zipRecord
