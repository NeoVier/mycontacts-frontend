module UI exposing (Variant(..), button, pageHeader)

import Css
import Css.Transitions
import Gen.Route
import Html.Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Decode
import Themes exposing (Theme)


type Variant
    = Primary
    | Danger


button :
    Theme
    -> Variant
    -> { onClick : Maybe msg, disabled : Bool }
    -> List Css.Style
    -> List (Html.Styled.Html msg)
    -> Html.Styled.Html msg
button theme variant { onClick, disabled } styles children =
    let
        background =
            case variant of
                Primary ->
                    theme.colors.primary.main

                Danger ->
                    theme.colors.danger.main

        hoverBg =
            case variant of
                Primary ->
                    theme.colors.primary.light

                Danger ->
                    theme.colors.danger.light

        activeBg =
            case variant of
                Primary ->
                    theme.colors.primary.dark

                Danger ->
                    theme.colors.danger.dark
    in
    Html.Styled.button
        [ optionalAttribute (Events.preventDefaultOn "click")
            (Maybe.map (\handler -> Json.Decode.succeed ( handler, True )) onClick)
        , Attributes.disabled disabled
        , Attributes.css
            (Css.backgroundColor background
                :: Css.color theme.colors.white
                :: Css.outline Css.none
                :: Css.border Css.zero
                :: Css.borderRadius theme.borderRadius
                :: Css.padding (Css.rem 1)
                :: Css.fontWeight Css.bold
                :: Css.cursor Css.pointer
                :: Css.Transitions.transition
                    [ Css.Transitions.backgroundColor3 200 0 Css.Transitions.linear
                    ]
                :: Css.hover [ Css.backgroundColor hoverBg ]
                :: Css.focus [ Css.backgroundColor hoverBg ]
                :: Css.pseudoClass "focus-visible"
                    [ Css.boxShadow5 Css.zero Css.zero Css.zero (Css.px 4) theme.colors.primary.lighter
                    ]
                :: Css.active [ Css.backgroundColor activeBg ]
                :: Css.disabled
                    [ Css.backgroundColor theme.colors.gray.light
                    , Css.cursor Css.default
                    ]
                :: styles
            )
        ]
        children


pageHeader : Theme -> String -> Html.Styled.Html msg
pageHeader theme title =
    Html.Styled.header
        [ Attributes.css
            [ Css.marginBottom (Css.rem 1.5)
            ]
        ]
        [ Html.Styled.a
            [ Attributes.href (Gen.Route.toHref Gen.Route.Home_)
            , Attributes.css
                [ Css.textDecoration Css.none
                , Css.hover [ Css.textDecoration Css.underline ]
                , Css.focus [ Css.textDecoration Css.underline ]
                , Css.pseudoClass "focus-visible"
                    [ Css.outline3 theme.borderWidth Css.solid theme.colors.primary.main
                    , Css.outlineOffset (Css.px 2)
                    , Css.borderRadius theme.borderRadius
                    ]
                ]
            ]
            [ Html.Styled.img
                [ Attributes.src "/icons/arrowUp.svg"
                , Attributes.css
                    [ Css.transforms
                        [ Css.rotate (Css.deg -90)
                        , Css.translateX (Css.px -2)
                        ]
                    ]
                ]
                []
            , Html.Styled.span
                [ Attributes.css
                    [ Css.fontWeight Css.bold
                    , Css.color theme.colors.primary.main
                    , Css.marginLeft (Css.rem 0.5)
                    ]
                ]
                [ Html.Styled.text "Voltar" ]
            ]
        , Html.Styled.h1
            [ Attributes.css
                [ Css.fontSize (Css.rem 1.5)
                ]
            ]
            [ Html.Styled.text title ]
        ]



-- UTILS


optionalAttribute : (a -> Html.Styled.Attribute msg) -> Maybe a -> Html.Styled.Attribute msg
optionalAttribute attr maybeValue =
    case maybeValue of
        Nothing ->
            Attributes.class ""

        Just value ->
            attr value
