class DecisionProblemsController < ApplicationController

  def new
    @decision_problem = DecisionProblem.new
  end

  def create
    @decision_problem = DecisionProblem.new(params[:decision_problem])

    if @decision_problem.save
      redirect_to action: "specify_dimensions", id: @decision_problem.id
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
      redirect_to action: "specify_dimensions", id: @decision_problem.id
    else
      render action: "edit"
    end
  end

  def specify_dimensions
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.dimensions.empty?
      DecisionProblem::MINIMUM_DIMENSIONS_COUNT.times do
        @decision_problem.dimensions.create
      end
    end
  end

  def save_dimensions
    @decision_problem = DecisionProblem.find(params[:id])

    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to action: "specify_options"
    else
      render action: "specify_dimensions"
    end
  end

  def specify_options
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.options.empty?
      DecisionProblem::MINIMUM_OPTIONS_COUNT.times do
        @decision_problem.options.create
      end
    end
  end

  def save_options
    @decision_problem = DecisionProblem.find(params[:id])

    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to action: "rank_options"
    else
      render action: "specify_options"
    end
  end

  def rank_options
    @decision_problem = DecisionProblem.find(params[:id])
    @decision_problem.setup_ratings
  end

  def save_option_ranks
    @decision_problem = DecisionProblem.find(params[:id])
    @errors = []
    update_ratings(params[:ratings])
    @decision_problem.update_ratings_by_rank
    if @errors.empty?
      redirect_to action: "specify_ratings"
    else
      render action: "rank_options"
    end
  end

  def specify_ratings
    @decision_problem = DecisionProblem.find(params[:id])
  end

  def save_ratings
    @decision_problem = DecisionProblem.find(params[:id])
    @errors = []
    update_ratings(params[:ratings])
    @decision_problem.update_ratings_by_value
    if @errors.empty?
      redirect_to action: "rank_dimensions"
    else
      render action: "specify_ratings"
    end
  end

  # GET /decision_problems/1/rank_dimensions
  def rank_dimensions
    @decision_problem = DecisionProblem.find(params[:id])
  end

  # PUT /decision_problems/1/save_dimension_ranks
  def save_dimension_ranks
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to action: "weight_dimensions"
    else
      render action: "rank_dimensions"
    end
  end

  # GET /decision_problems/1/weight_dimensions
  def weight_dimensions
    @decision_problem = DecisionProblem.find(params[:id])
  end

  # PUT /decision_problems/1/save_dimension_weights
  def save_dimension_weights
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.update_attributes(params[:decision_problem])
      redirect_to action: "view_scores"
    else
      render action: "weight_dimensions"
    end
  end

  # GET /decision_problems/1/view_scores
  def view_scores
    @decision_problem = DecisionProblem.find(params[:id])
    @options = @decision_problem.options.sort_by(&:score).reverse
  end



  # # GET /decision_problems
  # def index
  #   @decision_problems = DecisionProblem.all
  # end

  # # GET /decision_problems/1
  # def show
  #   @decision_problem = DecisionProblem.find(params[:id])
  # end





  # # DELETE /decision_problems/1
  # def destroy
  #   @decision_problem = DecisionProblem.find(params[:id])
  #   @decision_problem.destroy
  # end


  def update_ratings(rating_params)
    rating_params.each do |id, attribs|
      rating = Rating.find(id)
      rating.update_attributes(attribs)
      @errors << rating.errors.full_messages if rating.errors.any?
    end
  end
  private :update_ratings

end
