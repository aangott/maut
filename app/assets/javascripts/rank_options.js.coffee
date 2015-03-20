$ ->
  Maut.RankOptions =

    initialize: ->
      @enableSortable()

    enableSortable: ->
      $('.sortable').sortable
        axis: 'y'
        containment: 'parent'
        stop: (evt, ui) =>
          @updateRanks(ui.item)
      $('.sortable').disableSelection()

    updateRanks: ($sortedItem) ->
      $groupElems = $sortedItem.closest('.sortable').find('.option-ranker')
      $groupElems.each (idx, elem) ->
        ratingId = $(elem).data('rating')
        $ratingInput = $("input[data-rating='#{ratingId}']")
        rank = idx + 1  # want ranks to be 1-based
        $ratingInput.val(rank)

  Maut.RankOptions.initialize()
