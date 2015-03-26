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
      $groupElems = $sortedItem.closest('.sortable').find('.ranker')
      $groupElems.each (idx, elem) ->
        key = $(elem).data('key')
        $rankInput = $("input[data-key='#{key}']")
        rank = idx + 1  # want ranks to be 1-based
        $rankInput.val(rank)

  Maut.RankOptions.initialize()
