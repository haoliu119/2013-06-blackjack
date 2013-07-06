class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer, @handStatus = 'Hit or stand?') ->
    @on 'add remove change', => @checkStatus()

  checkStatus: ->
    score = @scores()[0]
    console.log score
    @handStatus = switch
      when score is 21 and @length is 2
        'Blackjack!'
      when score is 21
        '21'
      when score > 21
        @trigger 'bust'
        'Bust'
      else
        'Hit or Stand?'
    @trigger 'updateView'

  hit: ->
    @add(@deck.pop()).last()

  stand: ->
    @trigger 'stand', @

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]
