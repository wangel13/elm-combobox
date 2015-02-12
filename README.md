# elm-bootstrap-boilerplate
Elm-lang + Bootstrap Html boilerplate

## How to use

Write elm-code for combobox use:

```elm
  Combobox.view [class "combobox custom-skin1"] (LC.create ComboAction1 actionChannel) model.combo1
```

You can change combobox style by adding css-classes `.custom-skin`, default class `.combobox`, in `css/style.css`.
There are predefined black - `.custom-skin1` & white - `.combobox` classes.

Elm generate html:

```html
<div class="combobox custom-skin1">
  <input type="text">
  <div class="fadeIn combobox-list">
    <div class="combobox-list-item combobox-active">
      Your data
    </div>
    <div class="combobox-list-item">
      Your data
    </div>
  </div>
</div>
```

Data pushing in model:

```elm
initialModel = { combo1 = Combobox.initialModel Countries.list 10
               , combo2 = Combobox.initialModel Countries.list  5}
```

`5`, `10` - Custom Int size of dropdown list