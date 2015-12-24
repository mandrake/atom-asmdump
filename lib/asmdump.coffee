AsmdumpView = require './asmdump-view'
GBDumper = require './dumper/GBDumper'
{CompositeDisposable} = require 'atom'
fs = require 'fs-plus'

module.exports = Asmdump =
  asmdumpView: null
  subscriptions: null
  openerDisposeable: null

  activate: (state) ->
    # @modalPanel = atom.workspace.addModalPanel(item: @asmdumpView.getElement(), visible: false)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'asmdump:disassemble': => @disassemble()
    @openerDisposeable = atom.workspace.addOpener(@openHandler)

  deactivate: ->
    @subscriptions.dispose()
    @asmdumpView.destroy()

  serialize: ->
    asmdumpViewState: @asmdumpView.serialize()

  openHandler: (openURI) ->
    gbd = new GBDumper
    currentFile = openURI.replace 'asmdump://', ''
    return unless openURI.substr(0, 8) is 'asmdump:'

    stream = fs.ReadStream(currentFile)
    stream.on 'data', (chunk) => gbd.loadBuffer(chunk)
    #asm = @asmdumpView
    @asmdumpView = new AsmdumpView
    stream.on 'end', () =>
      @asmdumpView.show(gbd.process())

    return @asmdumpView

  disassemble: ->
    currentFile = atom.workspace.getActivePaneItem()
                                .getPath()
    console.log "Disassembling #{currentFile}!"
    atom.workspace.open "asmdump://#{currentFile}"
