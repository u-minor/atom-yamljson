fs = require 'fs'
path = require 'path'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'AtomYamlJson', ->
  [workspace, workspaceElement] = []

  beforeEach ->
    workspace = atom.workspace
    workspaceElement = atom.views.getView atom.workspace
    atom.packages.activatePackage 'atom-yamljson'

  describe 'when the yaml2json:convert-yaml-to-json event is triggered', ->
    it 'should convert yaml to json', ->
      afterText = fs.readFileSync(path.join(__dirname, './fixtures/yaml2json/after.json'), 'utf8').trim()

      waitsForPromise ->
        workspace.open path.join(__dirname, './fixtures/yaml2json/before.yml')
        .then (editor) ->
          atom.commands.dispatch workspaceElement, 'yaml2json:convert-yaml-to-json'

      waitsFor ->
        return workspace.getPaneItems().length == 2

      runs ->
        convertedText = workspace.getActiveTextEditor().getText().trim()
        expect(convertedText).toEqual afterText

  describe 'when the json2yaml:convert-json-to-yaml event is triggered', ->
    it 'should convert json to yaml', ->
      afterText = fs.readFileSync(path.join(__dirname, './fixtures/json2yaml/after.yml'), 'utf8').trim()

      waitsForPromise ->
        workspace.open path.join(__dirname, './fixtures/json2yaml/before.json')
        .then (editor) ->
          atom.commands.dispatch workspaceElement, 'json2yaml:convert-json-to-yaml'

      waitsFor ->
        return workspace.getPaneItems().length == 2

      runs ->
        convertedText = workspace.getActiveTextEditor().getText().trim()
        expect(convertedText).toEqual afterText
