$ ->
  Maut.ViewScores =

    containerWidth: 600
    containerHeight: 400
    containerPaddingBottom: 50

    minBarHeight: 2
    minBarWidth: 5
    barPadding: 0.15  # as portion of bar height

    labelPaddingBottom: 20

    transitionDelay: 800
    transitionDuration: 800

    initialize: ->
      @optionScores = Maut.optionScores || []
      @setupCalculatedInstanceVars()
      @displayScores()

    setupCalculatedInstanceVars: ->
      @maxBarHeight = @containerHeight - @containerPaddingBottom
      @yScale = d3.scale
        .linear()
        .domain([0, d3.max(@optionScores, (d) ->
          d.score
        )])
        .range([@minBarHeight, @maxBarHeight])
      @xScale = d3.scale
        .ordinal()
        .domain(d3.range(@optionScores.length))
        .rangeRoundBands([0, @containerWidth], @barPadding)
      @colorScale = d3.scale
        .linear()
        .domain([0, d3.max(@optionScores, (d) ->
          d.score
        )])
        .range([0, 100])

    displayScores: ->
      container = d3.select('.scores-container')

      # set up empty svg
      svg = container.append('svg')
        .attr('width', @containerWidth)
        .attr('height', @containerHeight)

      # create a bar for each option, but start with height = 0
      bars = svg.selectAll('rect.bar')
        .data(@optionScores, (d) ->
          d.id
        )
        .enter()
        .append('rect')
        .classed('bar', true)
        .attr('x', (d, i) =>
          @xScale(i)
        )
        .attr('y', @containerHeight - @containerPaddingBottom)
        .attr('height', 0)  # change this to 0
        .attr('width', @xScale.rangeBand())
        .attr('fill', 'hsl(0, 50%, 43%)')

      # create a label for each bar
      labels = svg.selectAll('text')
        .data(@optionScores)
        .enter()
        .append('text')
        .classed('label', true)
        .text((d) ->
          d.description
        )
        .attr('x', (d, i) =>
          @xScale(i)
        )
        .attr('y', (d, i) =>
          @containerHeight - @labelPaddingBottom
        )
        .attr('opacity', 0)

      # transition the bars to their proper height
      bars.transition()
        .delay((d, i) =>
          i * @transitionDelay
        )
        .duration(@transitionDuration)
        .attr('height', (d) =>
          @yScale(d.score)
        )
        .attr('y', (d) =>
           @containerHeight - @containerPaddingBottom - @yScale(d.score)
        )
        .attr('fill', (d) =>
          @colorFromScore(d.score)
        )

      labels.transition()
        .delay((d, i) =>
          i * @transitionDelay
        )
        .duration(@transitionDuration / 2)
        .attr('opacity', 1)

    colorFromScore: (score) ->
      scaledScore = @colorScale(score)
      "hsl(#{scaledScore}, 72%, 65%)"

  Maut.ViewScores.initialize()
