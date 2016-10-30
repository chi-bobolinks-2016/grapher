require 'CSV'
require 'Statsample'

class ChartsController < ApplicationController

  def index
    @charts = Chart.all
  end

  def create
    x = [] ;
    y = [] ;

    filename = chart_params[:data_file]

    CSV.foreach(filename.tempfile,{:headers => true}) do |line|
      x << line[0].to_f
      y << line[1].to_f
    end
    options = {
      minimum_x: x.sort[0] - x.sort[0].abs*0.05,
      maximum_x: x.sort[-1] + x.sort[0].abs*0.05,
      minimum_y: y.sort[0] - y.sort[0].abs*0.05,
      maximum_y: y.sort[-1] + y.sort[0].abs*0.05
    }
    @chart = Chart.create(x_variables: x, y_variables: y,chart_string: Statsample::Graph::Scatterplot.new(x.to_vector,y.to_vector, options).to_svg,name: chart_params[:name])
    p Statsample::Graph::Scatterplot.new(x.to_vector,y.to_vector,options)
    redirect_to chart_path(@chart)
  end

  def show
    @chart = Chart.find_by(id: params[:id])
  end

  private

  def chart_params
    params.require(:chart).permit(:data_file,:name)
  end
end
