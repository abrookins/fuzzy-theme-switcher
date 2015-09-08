{$$, SelectListView} = require 'atom-space-pen-views'
{match} = require 'fuzzaldrin'

module.exports = class FuzzyThemeSwitcherView extends SelectListView
  initialize: ->
    super

    @addClass('fuzzy-finder fuzzy-theme-switcher')
    @setMaxItems(10)

  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      @populate()
      @show()

  getFilterKey: ->
    'name'

  cancel: ->
    if atom.config.get('fuzzy-theme-switcher.preserveLastSearch')
      lastSearch = @getFilterQuery()
      super

      @filterEditorView.setText(lastSearch)
      @filterEditorView.getModel().selectAll()
    else
      super

  destroy: ->
    @cancel()
    @panel?.destroy()

  viewForItem: (theme) ->

    # Style matched characters in search results
    filterQuery = @getFilterQuery()
    matches = match(theme.name, filterQuery)

    $$ ->

      highlighter = (theme, matches) =>
        lastIndex = 0
        matchedChars = [] # Build up a set of matched chars to be more semantic

        for matchIndex in matches
          unmatched = theme.name.substring(lastIndex, matchIndex)
          if unmatched
            @span matchedChars.join(''), class: 'character-match' if matchedChars.length
            matchedChars = []
            @text unmatched
          matchedChars.push(theme.name[matchIndex])
          lastIndex = matchIndex + 1

        @span matchedChars.join(''), class: 'character-match' if matchedChars.length

        # Remaining characters are plain text
        @text theme.name.substring(lastIndex)

      @li class: 'one-line', =>
        if theme.metadata.theme == 'ui'
          typeClass = 'icon-paintcan'
        else
          typeClass = 'icon-file-binary'

        @div class: "primary-line icon #{typeClass}", 'data-name': theme.name, -> highlighter(theme, matches)

  confirmed: (theme) ->
    @openTheme(theme)

  populate: ->
    @setItems(atom.themes.getLoadedThemes())

  openTheme: (theme) ->
    if theme?
      currentThemes = atom.config.get('core.themes')
      if theme.metadata.theme == 'ui'
        currentThemes[0] = theme.name
      else
        currentThemes[1] = theme.name
      atom.config.set('core.themes', currentThemes)

  show: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

  hide: ->
    @panel?.hide()

  cancelled: ->
    @hide()
