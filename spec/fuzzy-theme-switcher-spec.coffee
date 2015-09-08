FuzzyThemeSwitcher = require '../lib/fuzzy-theme-switcher'

describe "FuzzyThemeSwitcher", ->
  [workspaceElement, activationPromise, themeSwitcher, themeSwitcherView] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('fuzzy-theme-switcher')

    dispatchCommand('toggle')

    waitsForPromise ->
      activationPromise.then (pack) ->
        themeSwitcher = pack.mainModule
        themeSwitcherView = themeSwitcher.createThemeSwitcherView()

  waitForThemesToDisplay = (themeSwitcherView) ->
    waitsFor "themes to display", 2000, ->
      themeSwitcherView.list.children("li").length > 0

  dispatchCommand = (command) ->
    atom.commands.dispatch(workspaceElement, "fuzzy-theme-switcher:#{command}")

  describe "toggling", ->
    it "shows all themes when activated", ->
      loadedThemes = atom.config.get('core.themes')
        
      dispatchCommand('toggle')
      
      waitForThemesToDisplay(themeSwitcherView)

      runs ->
        expect(projectView.list.find("li:contains(atom-dark-ui)")).toExist()
