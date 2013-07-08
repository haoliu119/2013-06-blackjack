class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %>
                      (<span class="score"></span>)
                      <span> : </span><span class="handStatus"><%= handStatus %></span></h2>'

  initialize: ->
    @render()
    @collection.on 'updateHandView', (card)=> 
      @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    scores = @collection.scores()
    @$('.score').text scores[0] + if scores[1]? then ' - soft '+scores[1] else ''
    @collection.each (card) => @updateHandView(card)

  updateHandView: (card)->
    @$el.append(new CardView(model: card).$el)
    
