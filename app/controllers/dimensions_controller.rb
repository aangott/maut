class DimensionsController < ApplicationController

  def specify
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.dimensions.empty?
      DecisionProblem::MINIMUM_DIMENSIONS_COUNT.times do
        @decision_problem.dimensions.create
      end
    end
  end

  def save
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to specify_decision_problem_options_path(@decision_problem)
    else
      flash[:error] = @decision_problem.errors.full_messages.join(', ')
      redirect_to action: "specify"
    end
  end

  def rank
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
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
