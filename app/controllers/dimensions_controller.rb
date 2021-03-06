class DimensionsController < ApplicationController

  def specify
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.dimensions.empty?
      DecisionProblem::MINIMUM_DIMENSIONS_COUNT.times do
        @decision_problem.dimensions.build
      end
    end
  end

  def save
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.update_attributes(params[:decision_problem])
      if @decision_problem.sufficient_dimensions?
        return redirect_to specify_decision_problem_options_path(@decision_problem)
      else
        flash[:error] = 'Please specify at least one dimension.'
      end
    else
      flash[:error] = @decision_problem.errors.full_messages.join(', ')
    end
    render :specify
  end

  def rank
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.dimensions.count > 1
      render :rank
    else
      @decision_problem.dimensions.first.update_attributes(rank: 1)
      @decision_problem.update_dimension_weights_by_rank
      render :no_rankings_required
    end
  end

  def save_ranks
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    @errors = []
    update_dimensions(params[:dimensions])
    @decision_problem.update_dimension_weights_by_rank
    if @errors.empty?
      redirect_to action: "weight"
    else
      render action: "rank"
    end
  end

  def weight
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.dimensions.count > 2
      render :weight
    else
      render :no_weightings_required
    end
  end

  def save_weights
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    @errors = []
    update_dimensions(params[:dimensions])
    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to view_scores_decision_problem_path(@decision_problem)
    else
      render action: "weight"
    end
  end

  def update_dimensions(dimension_params)
    dimension_params.each do |id, attribs|
      dimension = Dimension.find(id)
      dimension.update_attributes(attribs)
      @errors << dimension.errors.full_messages if dimension.errors.any?
    end
  end
  private :update_dimensions

end
