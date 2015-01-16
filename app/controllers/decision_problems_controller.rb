class DecisionProblemsController < ApplicationController

  # GET /decision_problems/new
  def new
    @decision_problem = DecisionProblem.new
  end

  # POST /decision_problems
  def create
    @decision_problem = DecisionProblem.new(params[:decision_problem])

    if @decision_problem.save
      redirect_to action: "specify_dimensions", id: @decision_problem.id
    else
      render action: "new"
    end
  end

  # GET /decision_problems/1/specify_dimensions
  def specify_dimensions
    @decision_problem = DecisionProblem.find(params[:id])
    if @decision_problem.dimensions.empty?
      DecisionProblem::MINIMUM_DIMENSIONS_COUNT.times do
        @decision_problem.dimensions.create
      end
    end
  end

  # PUT /decision_problems/1/save_dimensions
  def save_dimensions
    @decision_problem = DecisionProblem.find(params[:id])
    # binding.pry

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













  # GET /decision_problems/1/edit
  def edit
    @decision_problem = DecisionProblem.find(params[:id])
  end


  # # GET /decision_problems
  # def index
  #   @decision_problems = DecisionProblem.all
  # end

  # # GET /decision_problems/1
  # def show
  #   @decision_problem = DecisionProblem.find(params[:id])
  # end




  # # PUT /decision_problems/1
  # def update
  #   @decision_problem = DecisionProblem.find(params[:id])

  #   if @decision_problem.update_attributes(params[:decision_problem])
  #     format.html { redirect_to @decision_problem, notice: 'DecisionProblem was successfully updated.' }
  #   else
  #     format.html { render action: "edit" }
  #   end
  # end

  # # DELETE /decision_problems/1
  # def destroy
  #   @decision_problem = DecisionProblem.find(params[:id])
  #   @decision_problem.destroy
  # end

end
