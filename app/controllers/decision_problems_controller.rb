class DecisionProblemsController < ApplicationController

  def new
    @decision_problem = DecisionProblem.new
  end

  def create
    @decision_problem = DecisionProblem.new(params[:decision_problem])
    if @decision_problem.save
      redirect_to specify_decision_problem_dimensions_path(@decision_problem.id)
    else
      render action: "new"
    end
  end

  def edit
    @decision_problem = DecisionProblem.find(params[:id])
  end

  def update
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to specify_decision_problem_dimensions_path(@decision_problem.id)
    else
      render action: "edit"
    end
  end

  def view_scores
    @decision_problem = DecisionProblem.find(params[:id])
    @options = @decision_problem.options.sort_by(&:score).reverse
  end

end
