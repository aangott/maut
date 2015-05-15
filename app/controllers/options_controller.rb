class OptionsController < ApplicationController

  def specify
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.options.empty?
      DecisionProblem::MINIMUM_OPTIONS_COUNT.times do
        @decision_problem.options.build
      end
    end
  end

  def save
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    if @decision_problem.update_attributes(params[:decision_problem])
      if @decision_problem.sufficient_options?
        return redirect_to action: "rank"
      else
        flash[:error] = 'Please specify at least two options.'
      end
    else
      flash[:error] = @decision_problem.errors.full_messages.join(', ')
    end
    redirect_to action: "specify"
  end

  def rank
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    @decision_problem.setup_ratings
  end

  def save_ranks
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    @errors = []
    update_ratings(params[:ratings])
    @decision_problem.update_ratings_by_rank
    if @errors.empty?
      redirect_to action: "rate"
    else
      render action: "rank"
    end
  end

  def rate
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
  end

  def save_ratings
    @decision_problem = DecisionProblem.find(params[:decision_problem_id])
    @errors = []
    update_ratings(params[:ratings])
    @decision_problem.update_ratings_by_value
    if @errors.empty?
      redirect_to rank_decision_problem_dimensions_path(@decision_problem)
    else
      render action: "rate"
    end
  end

  def update_ratings(rating_params)
    rating_params.each do |id, attribs|
      rating = Rating.find(id)
      rating.update_attributes(attribs)
      @errors << rating.errors.full_messages if rating.errors.any?
    end
  end
  private :update_ratings

end
