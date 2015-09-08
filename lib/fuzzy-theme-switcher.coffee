FuzzyThemeSwitcherView = require './fuzzy-theme-switcher-view'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    preserveLastSearch:
      type: 'boolean'
      default: false

  activate: (state) ->
    @active = true

    atom.commands.add 'atom-workspace',
      'fuzzy-theme-switcher:toggle': =>
        @createThemeSwitcherView().toggle()

  deactivate: ->
    if @themeSwitcherView?
      @themeSwitcherView.destroy()
      @themeSwitcherView = null
    @active = false

  createThemeSwitcherView: ->
    unless @themeSwitcherView?
      FuzzyThemeSwitcherView  = require './fuzzy-theme-switcher-view'
      @themeSwitcherView = new FuzzyThemeSwitcherView()
    @themeSwitcherView
