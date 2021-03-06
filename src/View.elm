module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Css exposing (backgroundColor, borderBox, boxSizing, color, fontFamilies, fontSize, margin, padding, px, sansSerif, zero)
import Css.Global exposing (body, everything, global)
import Html.Styled exposing (div, img)
import Html.Styled.Attributes exposing (css, src)
import Themes exposing (Theme)


type alias View msg =
    List (Html.Styled.Html msg)


placeholder : String -> View msg
placeholder str =
    [ Html.Styled.text str ]


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    List.map (Html.Styled.map fn) view


toBrowserDocument : Theme -> View msg -> Browser.Document msg
toBrowserDocument theme view =
    { title = "MyContacts"
    , body =
        [ global
            [ everything
                [ margin zero
                , padding zero
                , boxSizing borderBox
                , fontFamilies [ "Sora", sansSerif.value ]
                , fontSize (px 16)
                ]
            , body
                [ backgroundColor theme.colors.background
                , color theme.colors.foreground
                ]
            ]
        , defaultContainer (header :: view)
        ]
            |> List.map Html.Styled.toUnstyled
    }


header : Html.Styled.Html msg
header =
    div
        [ css
            [ Css.marginTop (Css.px 74)
            , Css.marginBottom (Css.px 48)
            , Css.displayFlex
            , Css.alignItems Css.center
            , Css.justifyContent Css.center
            ]
        ]
        [ img [ src "/images/logo.svg" ] [] ]


defaultContainer : List (Html.Styled.Html msg) -> Html.Styled.Html msg
defaultContainer children =
    div
        [ css
            [ Css.width (Css.pct 100)
            , Css.maxWidth (Css.calc (Css.px 500) Css.plus (Css.rem 1))
            , Css.margin2 zero Css.auto
            , Css.padding2 zero (Css.rem 1)
            , Css.paddingBottom (Css.px 100)
            ]
        ]
        children
