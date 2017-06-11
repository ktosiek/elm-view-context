module ExtraLazy exposing (..)

import Native.ExtraLazy
import Html exposing (Html)


lazy4 : (a -> b -> c -> d -> Html msg) -> a -> b -> c -> d -> Html msg
lazy4 =
    Native.ExtraLazy.lazy4


lazy5 : (a -> b -> c -> d -> e -> Html msg) -> a -> b -> c -> d -> e -> Html msg
lazy5 =
    Native.ExtraLazy.lazy5
