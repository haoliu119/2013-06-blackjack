#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  playerPot: []

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on 'statusChanged', (statusKey)=>
      @playerBust() if statusKey is 1
    @get('playerHand').on 'stand', =>
      @trigger 'playerTurnEnded'
      @dealerTurn()
    @get('dealerHand').on 'stand', =>
      message = @checkScores()
      @trigger 'endGame', message
      @playerPot.push message
      @initialize()
      @trigger 'newGame'
      console.log @playerPot


  playerBust: ->
    @trigger 'playerTurnEnded'
    @dealerTurn()

  dealerTurn: ->
    @get('dealerHand').dealerTurn()

  checkScores: ->
    playerStatus = @get('playerHand').checkStatus()
    dealerStatus = @get('dealerHand').checkStatus()

    playerHardScore = @get('playerHand').scores()[0]
    playerSoftScore = @get('playerHand').scores()[1]

    playerScore = if playerSoftScore? and playerSoftScore < 22 then playerSoftScore else playerHardScore
    dealerScore = @get('dealerHand').scores()[0]
    if playerStatus is 1 # if player busts, player loses, even if deal busts
      'playerLost'
    else if playerStatus is 3 and playerStatus > dealerStatus
      'playerWonBlackJack'
    else if playerStatus > 1 and playerStatus is dealerStatus
      'push' #push 21 or blackjack
    else if dealerStatus is 1 # dealer busts, player didn't bust
      'playerWon'
    else
      if playerScore is dealerScore # equal scores
        if playerStatus < dealerStatus
          'playerLost'
        else
          'push'
      else
        if playerScore > dealerScore
          'playerWon'
        else
          'playerLost'