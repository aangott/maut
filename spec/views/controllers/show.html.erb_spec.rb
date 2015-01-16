require 'spec_helper'

describe "controllers/show" do
  before(:each) do
    @controller = assign(:controller, stub_model(Controller,
      :DecisionProblems => "Decision Problems"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Decision Problems/)
  end
end
