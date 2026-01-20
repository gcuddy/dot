# {{ name }} theme for lazygit
gui:
  theme:
    activeBorderColor:
      - "{{ accent }}"
      - bold
    inactiveViewSelectedLineBgColor:
      - "{{ ui_selected }}"
    inactiveBorderColor:
      - "{{ ui_gray }}"
    optionsTextColor:
      - "{{ accent }}"
    selectedLineBgColor:
      - "{{ ui_selected }}"
    selectedRangeBgColor:
      - "{{ ui_selected }}"
    cherryPickedCommitBgColor:
      - "{{ ui_match }}"
    cherryPickedCommitFgColor:
      - "{{ foreground }}"
    unstagedChangesColor:
      - "{{ color1 }}"
    defaultFgColor:
      - "{{ foreground }}"
git:
  paging:
    colorArg: always
    pager: delta --{{ appearance }} --paging=never
