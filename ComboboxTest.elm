module ComboboxTest where
-- Bible
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Debug
import Signal
import LocalChannel as LC
import Maybe
-- Custom
import Combobox
import Countries

type alias Model = { combo1 : Combobox.Model
                    ,combo2 : Combobox.Model
                    }

type Action = NoOp
            | ComboAction1 Combobox.Action
            | ComboAction2 Combobox.Action

initialModel = { combo1 = Combobox.initialModel Countries.list 10
               , combo2 = Combobox.initialModel Countries.list  5 }

-- VIEW

view : Model -> Html
view model = div [class "container combo-test"]
  [ h2 [] [text "Combobox example (countries example)"]
  , h3 [] [text "Combobox 1"]
  , Combobox.view (LC.create ComboAction1 actionChannel) model.combo1
  , h3 [] [text "Combobox 2"]
  , Combobox.view (LC.create ComboAction2 actionChannel) model.combo2
  ]

main : Signal Html
main =
  Signal.map view modelSignal

actionChannel : Signal.Channel Action
actionChannel =
  Signal.channel NoOp

modelSignal : Signal Model
modelSignal =
  Signal.foldp update initialModel (Signal.subscribe actionChannel)

update : Action -> Model -> Model
update action model =
    case action of
      ComboAction1 act -> {model | combo1 <- Combobox.update act model.combo1}
      ComboAction2 act -> {model | combo2 <- Combobox.update act model.combo2}
      _ -> model