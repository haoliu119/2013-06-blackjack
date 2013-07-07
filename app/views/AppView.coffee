class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()

  initialize: ->
    console.log 'appView initialized'
    @model = new App()
    @render()
    @model.on 'playerTurnEnded', =>
      @$el.find('.stand-button, .hit-button').prop 'disabled', true
    @model.on 'playerLost', ->
      alert 'Player Lost'
    @model.on 'playerWon', ->
      alert 'Player Won'
    @model.on 'push', ->
      alert 'Push'
    @model.on 'playerWonBlackJack', ->
      alert 'Player Won with Blackjack: 3:2 Payout'
    @model.on 'NewGame', ->
      console.log 'new game heard'
      @initialize()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
