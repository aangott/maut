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
        .attr('data-key', (d) ->
          d.desc
        )
        .attr('x', @containerPadding)
        .attr('y', (d, i) ->
          yScale(i)
        )
        .attr('height', yScale.rangeBand())
        .attr('width', 0)
        .attr('fill', 'hsl(0, 50%, 43%)')

      # transition the bars to their proper width
      bars.transition()
        .delay((d, i) =>
          i / ratings.length * @maxTransitionDelay
        )
        .duration(@transitionDuration)
        .attr('width', (d) =>
          @widthScale(if d.value == null then @defaultRating else d.value)
        )
        .attr('fill', (d) =>
          @colorFromRating(if d.value == null then @defaultRating else d.value)
        )

    colorFromRating: (rating) ->
      "hsl(#{rating}, 72%, 65%)"

  Maut.SpecifyRatings.initialize()

