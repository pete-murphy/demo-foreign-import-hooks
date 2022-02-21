module App where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable as Nullable
import Debug (class DebugWarning)
import Debug as Debug
import Effect.Class.Console as Console
import Foreign.Hooks (MouseEvent(..))
import Foreign.Hooks as Foreign.Hooks
import React.Basic.DOM as R
import React.Basic.Events as Events
import React.Basic.Hooks (Component)
import React.Basic.Hooks as Hooks

mkApp :: DebugWarning => Component Unit
mkApp = do
  Hooks.component "App" \_ -> Hooks.do
    ref <- Hooks.useRef Nullable.null

    let
      handleClickAnywhere event = do
        Console.log ("Clicked anywhere")
        Debug.traceM event

    Foreign.Hooks.useEventListener MouseDown handleClickAnywhere Nothing

    let
      handleClickOutside = Events.handler_ (Console.log "Clicked outside")
      handleClickInside = Events.handler_ (Console.log "Clicked inside")

    Foreign.Hooks.useOnClickOutside ref handleClickOutside MouseUp

    pure
      ( R.button
          { onClick: handleClickInside
          , ref
          , style: R.css
              { width: "200px"
              , height: "200px"
              , background: "cyan"
              }
          }
      )
