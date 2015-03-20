$ ->
  Maut.SpecifyRatings =

    containerWidth: 900
    containerHeight: 300
    containerPadding: 20

    minRating: 0
    maxRating: 100
    defaultRating: 50

    minBarWidth: 5
    barPadding: 0.15  # as portion of bar height

    maxTransitionDelay: 500
    transitionDuration: 1000

    pullSize: 20

    initialize: ->
      @ratingsByDimension = Maut.ratingsByDimension
      @setupCalculatedInstanceVars()
      @setupDimensions()

    setupCalculatedInstanceVars: ->
      @maxBarWidth = (@containerWidth - (2 * @containerPadding))
      @widthScale = d3.scale
        .linear()
        .domain([@minRating, @maxRating])
        .range([@minBarWidth, @maxBarWidth])
      @widthToScore = d3.scale
        .linear()
        .domain([@minBarWidth, @maxBarWidth])
        .range([@minRating, @maxRating]);

    setupDimensions: ->
      for dimension in @ratingsByDimension
        console.log(dimension.description)
        container = d3.select("div[data-dimension='#{dimension.id}'")
        @setupRatings(container, dimension.sorted_ratings)

    setupRatings: (container, ratings) ->
      console.log(ratings)

      yScale = d3.scale
        .ordinal()
        .domain(d3.range(ratings.length))
        .rangeRoundBands([0, @containerHeight], @barPadding)

      # set up empty svg
      svg = container.append('svg')
        .attr('width', @containerWidth)
        .attr('height', @containerHeight)

      # create a bar for each rating, but start with width = 0
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
        .attr('x', @containerPadding)
        .attr('y', (d, i) ->
          yScale(i)
        )
        .attr('height', yScale.rangeBand())
        .attr('width', 0)
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
        .attr('x', @containerPadding - @pullSize / 2)
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
          @widthScale(@getValue(d)) + @containerPadding - (@pullSize / 2);
        )

      # make pulls draggable + set up listener
      drag = d3.behavior.drag()
        .on("drag", @dragmove.bind(@))
      pulls.call(drag)

    dragmove: (d) ->
      pull = d3.select(".pull[data-rating='#{d.id}']")
      if pull.classed('locked')
        return
      pull.attr('x', Math.max(@minBarWidth + @pullSize/2, Math.min(@maxBarWidth + @pullSize/2, d3.event.x)))

      bar = d3.select(".bar[data-rating='#{d.id}']")
      bar.attr('width', Math.max(@minBarWidth, Math.min(@maxBarWidth, d3.event.x - @pullSize/2)))
      bar.attr('fill', @colorFromRating(@widthToScore(bar.attr('width'))))

      input = d3.select("input[data-rating='#{d.id}']")
      input.attr('value', (Math.round(@widthToScore(bar.attr('width')))))

    getValue: (d) ->
      if d.value == null
        @defaultRating
      else
        d.value

    colorFromRating: (rating) ->
      "hsl(#{rating}, 72%, 65%)"

  Maut.SpecifyRatings.initialize()
