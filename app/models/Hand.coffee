class window.Hand extends Backbone.Collection
  # Dealer Stands on All 17
  model: Card

  statusHash:
    0: 'Hit or Stand?'
    1: 'Bust'
    2: '21, you may wanna stand...'
    3: 'Blackjack, you may wanna stand...'

  initialize: (array, @deck, @isDealer) ->
    @handStatus = if isDealer then '' else @statusHash[@checkStatus()]
    @on 'add remove change', (card)=>
      statusKey = @checkStatus()
      @handStatus = if isDealer then '' else @statusHash[statusKey]
      @trigger 'updateHandView', card
      @trigger 'statusChanged', statusKey

  checkStatus: ->
    # when invoked, returns hand's current status in terms of statusHash key
    hard = @scores()[0]
    soft = @scores()[1]
    switch true
      when @length is 2 and (hard is 21 or soft is 21)
        3 # Blackjack
      when hard is 21 or soft is 21
        2 # 21
      when hard > 21
        1 # Bust
      else
        0 # Hit or Stand

  hit: ->
    @add(@deck.pop()).last()

  stand: ->
    @trigger 'stand', @

  scores: ->
    # returns an array of scores.
    # when ace in hand, returns 2 scores - hard score, soft score (hard + 10)
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false

    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0

    if hasAce
      if @isDealer
        if score + 10 > 21
          [score]
        else 
          [score + 10]
      else
        [score, score + 10]
    else [score]

  dealerTurn: -> # dealer keeps hitting until hard 17 or above, no soft score checking yet
    @at(0).flip()
    @hit() while @scores()[0] < 17
    @stand()
