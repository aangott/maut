$ ->
  Maut.SpecifyRatings =

    initialize: ->
      @setInitialOptionOrderings()
      @setSelectBoxListeners()

    setInitialOptionOrderings: ->
      $('.make-ratings').each (idx, elem) =>
        @orderOptions($(elem))

    orderOptions: ($ratingsDiv) ->
      best_id = $ratingsDiv.find('.best-select').val()
      if best_id
        $optionRow = $ratingsDiv.find('.option_' + best_id)
        $sliderContainer = $ratingsDiv.find('.slider-container')
        $optionRow.detach()
        $sliderContainer.prepend($optionRow)

    handleSelectChange: (evt) ->
      ratingsDiv = $(evt.currentTarget).closest('.make-ratings')
      @orderOptions(ratingsDiv)

    setSelectBoxListeners: ->
      $('select').on 'change', (evt) =>
        @handleSelectChange(evt)

  Maut.SpecifyRatings.initialize()

