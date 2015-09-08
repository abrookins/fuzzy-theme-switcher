FuzzyThemeSwitcher = require '../lib/fuzzy-theme-switcher'

describe "FuzzyThemeSwitcher", ->
  [workspaceElement, activationPromise, themeSwitcher, themeSwitcherView] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('fuzzy-theme-switcher')
    atom.packages.loadPackage('atom-light-ui')
    atom.packages.loadPackage('atom-dark-ui')
    atom.packages.loadPackage('atom-light-syntax')
    atom.packages.loadPackage('atom-dark-syntax')

    # Activate the modal, so the package gets loaded
    dispatchCommand('toggle')

    waitsForPromise ->
      activationPromise.then (pack) ->
        themeSwitcher = pack.mainModule
        themeSwitcherView = themeSwitcher.createThemeSwitcherView()

    # Deactivate the modal, so we can activate it in tests
    dispatchCommand('toggle')

  waitForThemesToDisplay = (themeSwitcherView) ->
    waitsFor "themes to display", 2000, ->
      themeSwitcherView.list.children("li").length > 0

  dispatchCommand = (command) ->
    atom.commands.dispatch(workspaceElement, "fuzzy-theme-switcher:#{command}")

  describe "toggling", ->
    it "shows no themes when deactivated", ->
      expect(themeSwitcherView.list.find('li')).not.toExist()

    it "shows all available themes when activated", ->
      # Toggle on
      dispatchCommand('toggle')
      
      waitForThemesToDisplay(themeSwitcherView)

      runs ->
        expect(themeSwitcherView.list.find("li:contains(atom-light-ui)")).toExist()
        expect(themeSwitcherView.list.find("li:contains(atom-dark-ui)")).toExist()
        expect(themeSwitcherView.list.find("li:contains(atom-light-syntax)")).toExist()
        expect(themeSwitcherView.list.find("li:contains(atom-dark-syntax)")).toExist()

    it "shows a paint icon for ui themes", ->
      # Toggle on
      dispatchCommand('toggle')
      waitForThemesToDisplay(themeSwitcherView)

      runs ->
        expect(themeSwitcherView.list.find("li:contains(atom-light-ui)").find(".icon-paintcan")).toExist()

    it "shows a binary file icon for syntax themes", ->
      # Toggle on
      dispatchCommand('toggle')
      waitForThemesToDisplay(themeSwitcherView)

      runs ->
        expect(themeSwitcherView.list.find("li:contains(atom-light-syntax)").find(".icon-file-binary")).toExist()

  describe "searching", ->
    # TODO: Stuff like this: https://github.com/atom/fuzzy-finder/blob/master/spec/fuzzy-finder-spec.coffee#L691
