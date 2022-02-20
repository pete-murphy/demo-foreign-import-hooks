module Foreign.Hooks
  ( useEventListener
  , UseEventListener(..)
  , useOnClickOutside
  , UseOnClickOutside(..)
  , MouseEvent(..)
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn3)
import Effect.Uncurried as Uncurried
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Hook, Ref)
import React.Basic.Hooks as Hooks
import Web.Event.Internal.Types (Event)

useEventListener
  :: forall a
   . MouseEvent -- Could add more events, but I don't think there's anything like this in PureScript:
  -- https://microsoft.github.io/PowerBI-JavaScript/interfaces/_node_modules_typedoc_node_modules_typescript_lib_lib_dom_d_.windoweventmap.html
  -> (Event -> Effect Unit)
  -> Maybe (Ref a)
  -> Hook UseEventListener Unit
useEventListener mouseEvent handler element =
  Hooks.unsafeHook
    ( Uncurried.runEffectFn3
        _useEventListener
        (mouseEventToString mouseEvent)
        (Uncurried.mkEffectFn1 handler)
        (Nullable.toNullable element)
    )

newtype UseEventListener hooks = UseEventListener hooks

derive instance Newtype (UseEventListener hooks) _

foreign import _useEventListener
  :: forall a
   . EffectFn3
       String -- eventName: K
       (EffectFn1 Event Unit) -- (event: WindowEventMap[K]) => void
       (Nullable (Ref a)) -- element?: RefObject<T>
       Unit

useOnClickOutside
  :: forall a
   . Ref a
  -> EventHandler
  -> MouseEvent
  -> Hook UseOnClickOutside Unit
useOnClickOutside ref handler mouseEvent =
  Hooks.unsafeHook
    ( Uncurried.runEffectFn3
        _useOnClickOutside
        ref
        handler
        (mouseEventToString mouseEvent)
    )

newtype UseOnClickOutside hooks = UseOnClickOutside hooks

derive instance Newtype (UseOnClickOutside hooks) _

foreign import _useOnClickOutside
  :: forall a
   . EffectFn3
       (Ref a) -- ref: RefObject<T>
       EventHandler -- handler: Handler,
       String -- mouseEvent: 'mousedown' | 'mouseup' = 'mousedown'
       Unit

data MouseEvent = MouseDown | MouseUp

mouseEventToString :: MouseEvent -> String
mouseEventToString = case _ of
  MouseDown -> "mousedown"
  MouseUp -> "mouseup"
