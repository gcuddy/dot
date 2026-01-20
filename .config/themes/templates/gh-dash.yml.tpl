# {{ name }} theme for gh-dash
theme:
  ui:
    sectionsShowCount: true
    table:
      compact: false
  colors:
    text:
      primary: "{{ foreground }}"
      secondary: "{{ ui_gray }}"
      inverted: "{{ background }}"
      faint: "{{ color8 }}"
      warning: "{{ color3 }}"
      success: "{{ color2 }}"
    background:
      selected: "{{ ui_selected }}"
    border:
      primary: "{{ ui_border }}"
      secondary: "{{ ui_border_secondary }}"
      faint: "{{ ui_border_faint }}"
