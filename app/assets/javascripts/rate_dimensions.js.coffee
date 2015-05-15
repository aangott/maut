$ ->
  Maut.RateDimensions =

    initialize: ->
      @dimensionsForWeighting = Maut.dimensionsForWeighting || []
      @numDimensions = @dimensionsForWeighting.length
      return unless @numDimensions > 0

      @barHeight = 60
      @containerWidth = 750
      @containerHeight = @barHeight * @numDimensions

      @minRating = 10
      @maxRating = 100
      @defaultRating = 50

      @pullSize = 20
      @minBarWidth = 70
      @maxBarWidth = @containerWidth - @pullSize
      @barPadding = 0.15  # as portion of bar height

      @maxTransitionDelay = 500
      @transitionDuration = 1000

      @widthScale = d3.scale
        .linear()
        .domain([@minRating, @maxRating])
        .range([@minBarWidth, @maxBarWidth])
      @widthToScore = d3.scale
        .linear()
        .domain([@minBarWidth, @maxBarWidth])
        .range([@minRating, @maxRating])

      @setupRatings(d3.select(".dimension-rating-container"), @dimensionsForWeighting)

    setupRatings: (container, ratings) ->
      yScale = d3.scale
        .ordinal()
        .domain(d3.range(ratings.length))
        .rangeRoundBands([0, @containerHeight], @barPadding)

      # set up empty svg
      svg = container.append('svg')
        .attr('width', @containerWidth)
        .attr('height', @containerHeight)

      # create a bar for each rating, but start at min width
      bars = svg.selectAll('rect.bar')
        .data(ratings, (d) ->
          d.id
        )
        .enter()
        .append('rect')
        .classed('bar', true)
        .attr('data-rating', (d) ->
          d.id
        )
        .attr('x', 0)
        .attr('y', (d, i) ->
          yScale(i)
        )
        .attr('height', yScale.rangeBand())
        .attr('width', @minBarWidth)
        .attr('fill', 'hsl(0, 50%, 43%)')

      # create a pull on each bar, but at far left of svg
      pulls = svg.selectAll('rect.pull')
        .data(ratings, (d) ->
          d.id
        )
        .enter()
        .append('rect')
        .attr('class', 'pull')
        .attr('data-rating', (d) ->
          d.id
        )
        .attr('x', @minBarWidth - (@pullSize / 2))
        .attr('y', (d, i) =>
          yScale(i) + (yScale.rangeBand() / 2) - (@pullSize / 2)
        )
        .attr('height', 20)
        .attr('width', 20)
        .classed('locked', (d, i) ->
          if (i == 0 || i == ratings.length - 1)
            true
          else
            false
        )

      # transition the bars to their proper width
      bars.transition()
        .delay((d, i) =>
          i / ratings.length * @maxTransitionDelay
        )
        .duration(@transitionDuration)
        .attr('width', (d) =>
          @widthScale(@getValue(d))
        )
        .attr('fill', (d) =>
          @colorFromRating(@getValue(d))
        )

      # transition pulls to their proper position
      pulls.transition()
        .delay((d, i) =>
          i / ratings.length * @maxTransitionDelay
        )
        .duration(@transitionDuration)
        .attr('x', (d) =>
          @widthScale(@getValue(d)) - (@pullSize / 2)
        )
        .each('end', ->
          pull = d3.select(@)
          return unless pull.classed('locked')
          svg.append('image')
            .classed('lock', true)
            .attr('x', pull.attr('x'))
            .attr('y', +(pull.attr('y')) + 2)
            .attr('height', 15)
            .attr('width', pull.attr('width'))
            .attr('xlink:href', '/assets/lock.png')
            .attr('opacity', 0)
            .transition()
              .attr('opacity', 1)
              .duration(1000)
        )

      # make pulls draggable + set up listener
      drag = d3.behavior.drag()
        .on("drag", @dragmove.bind(@))
      pulls.call(drag)

    dragmove: (d) ->
      pull = d3.select(".pull[data-rating='#{d.id}']")
      if pull.classed('locked')
        return
      pull.attr('x', Math.max(
        @minBarWidth - (@pullSize / 2),
        Math.min(@maxBarWidth - (@pullSize / 2), d3.event.x)
      ))

      bar = d3.select(".bar[data-rating='#{d.id}']")
      bar.attr('fill', @colorFromRating(@widthToScore(bar.attr('width'))))
      bar.attr('width', Math.max(
        @minBarWidth,
        Math.min(@maxBarWidth, d3.event.x + (@pullSize / 2))
      ))

      input = d3.select("input[data-rating='#{d.id}']")
      input.attr('value', (Math.round(@widthToScore(bar.attr('width')))))

    getValue: (d) ->
      if d.weight == null
        @defaultRating
      else
        d.weight

    colorFromRating: (rating) ->
      "hsl(#{rating}, 72%, 65%)"

  Maut.RateDimensions.initialize()
