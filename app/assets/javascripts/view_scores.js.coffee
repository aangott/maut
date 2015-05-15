$ ->
  Maut.ViewScores =

    initialize: ->
      @optionScores = Maut.optionScores || []
      return unless @optionScores.length > 0

      @containerWidth = 900
      @containerHeight = 400

      @minBarHeight = 2
      @minBarWidth = 5
      @barPadding = 0.15  # as portion of bar height

      @transitionDelay = 800
      @transitionDuration = 800

      @maxBarHeight = @containerHeight
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

      @adjustLabels()
      @displayScores()

    adjustLabels: ->
      labelWidth = (@containerWidth - 30) / @optionScores.length
      d3.selectAll('td').style('max-width', "#{labelWidth}px")
      d3.selectAll('td').style('min-width', "#{labelWidth}px")

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
        .attr('y', @containerHeight)
        .attr('height', 0)  # change this to 0
        .attr('width', @xScale.rangeBand())
        .attr('fill', 'hsl(0, 50%, 43%)')

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
           @containerHeight - @yScale(d.score)
        )
        .attr('fill', (d) =>
          @colorFromScore(d.score)
        )

      d3.selectAll('td').transition()
        .delay((d, i) =>
          i * @transitionDelay
        )
        .duration(@transitionDuration / 2)
        .style('color', 'rgba(255, 255, 255, 1)')

    colorFromScore: (score) ->
      scaledScore = @colorScale(score)
      "hsl(#{scaledScore}, 72%, 65%)"

  Maut.ViewScores.initialize()
