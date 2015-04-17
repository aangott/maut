# adaped from: https://github.com/ryanb/nested_form/wiki/How-to:-limit-max-count-of-nested-fields
$ ->
  Maut.LimitNestedOptions =

    initialize: ->
      @addBtn = $('a.add_nested_fields')
      @maxFields = @addBtn.data('max-fields')
      @fieldsCount = $('.nested-field').length

      @addAddListener()
      @addDeleteListener()
      @toggleAddBtn()

    addAddListener: ->
      $(document).on 'nested:fieldAdded', (evt) =>
        @fieldsCount += 1
        @toggleAddBtn()

    addDeleteListener: ->
      $(document).on 'nested:fieldRemoved', (evt) =>
        @fieldsCount -= 1
        @toggleAddBtn()

    toggleAddBtn: ->
      @addBtn.toggle(@fieldsCount < @maxFields)

  Maut.LimitNestedOptions.initialize()
