class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %>
                      (<span class="score"></span>)
                      <span class="handStatus"> : <%= handStatus %></span></h2>'

  initialize: ->
    @collection.on 'updateView', => @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    scores = @collection.scores()
    @$('.score').text scores[0] + if scores[1]? then ' - soft '+scores[1] else ''
