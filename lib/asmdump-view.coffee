{$, ScrollView} = require 'atom-space-pen-views'
entities = require 'entities'

module.exports =
class AsmdumpView extends ScrollView
  @content: ->
    @div class: 'hex-view padded pane-item', tabindex: -1, =>
      @div class: 'hex-dump', outlet: 'hexDump'

  initialize: =>
    super

  attached: ->
    @hexDump.css
      'font-family': atom.config.get('editor.fontFamily')
      'font-size': atom.config.get('editor.fontSize')

  getTitle: -> "Mario"

  """
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('asmdump')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Asmdump package is Alive! It's ALIVE!"
    message.classList.add('message')
    # @element.appendChild(message)
  """

  constructor: ->
    super

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  show: (element) ->
    console.log element
    @hexDump.append element
