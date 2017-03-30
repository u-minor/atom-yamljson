YAML = require 'js-yaml'
{CompositeDisposable} = require 'atom'

yamlToJson = ->
  editor = atom.workspace.getActiveTextEditor()
  #return unless editor.getRootScopeDescriptor().scopes[0] is 'source.yaml'

  try
    obj = YAML.safeLoad editor.getText(), schema: YAML.JSON_SCHEMA
  catch e
    atom.notifications?.addError 'yaml2json: YAML parse error',
      dismissable: true
      detail: e.toString()
    return

  atom.workspace.open ''
  .then (newEditor) ->
    newEditor.setGrammar atom.grammars.selectGrammar('untitled.json')
    indent = atom.config.get 'atom-yamljson.jsonIndentSize'
    text = JSON.stringify obj, null, new Array(indent + 1).join(' ')
    newEditor.setText text
  return

jsonToYaml = ->
  editor = atom.workspace.getActiveTextEditor()
  #return unless editor.getRootScopeDescriptor().scopes[0] is 'source.json'

  try
    obj = JSON.parse editor.getText()
  catch e
    atom.notifications?.addError 'json2yaml: JSON parse error',
      dismissable: true
      detail: e.toString()
    return

  atom.workspace.open ''
  .then (newEditor) ->
    newEditor.setGrammar atom.grammars.selectGrammar('untitled.yml')
    indent = atom.config.get 'atom-yamljson.yamlIndentSize'
    text = YAML.safeDump obj,
      indent: atom.config.get 'atom-yamljson.yamlIndentSize'
      flowLevel: atom.config.get 'atom-yamljson.yamlFlowLevel'
    newEditor.setText text
  return

module.exports =
  config:
    jsonIndentSize:
      type: 'integer'
      default: 2
      minimum: 0
    yamlIndentSize:
      type: 'integer'
      default: 2
      minimum: 0
    yamlFlowLevel:
      type: 'integer'
      default: -1
      minimum: -1

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'yaml2json:convert-yaml-to-json', -> yamlToJson()
    @subscriptions.add atom.commands.add 'atom-workspace', 'json2yaml:convert-json-to-yaml', -> jsonToYaml()

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
