class Api::ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @projects = Project.all
    render :index
  end

  def show
    @project = Project.find(params[:id])
    render :show
  end

  def create
    params[:project][:rewards_attributes] = JSON.parse(params[:project][:rewards_attributes])
    params[:project][:image_url] = "https://s3.amazonaws.com/minkstarter1/stripe_background.jpg"

    current_user = User.find_by(session_token: params[:user][:session_token])
    @project = current_user.projects.new(project_params)

    if @project.save
      render :show
    else
      render json: @project.errors.full_messages, status: 422
    end

  end

  def update
    current_user = User.find_by(session_token: params[:user][:session_token])
    @project = current_user.projects.find(params[:id])
    params[:project][:rewards_attributes] = JSON.parse(params[:project][:rewards_attributes])

    if @project.update(project_params)
      render :show
    else
      render json: @project.errors.full_messages, status: 422
    end
  end

  def destroy
    @project = Project.find_by(id: project_id[:id])
    @project.destroy
    render json: @project
  end

  def search
    search = params[:search].downcase

    if params[:search].present?
      @projects = Project
        .joins(:creator)
        .where("title like? OR description like? OR users.name like?", "%#{search}%", "%#{search}%", "%#{search}%")

      render :search
    end
  end

  private
  def project_id
    params
      .permit(:id)
  end

  def project_params
    params
      .require(:project)
      .permit(:title, :image_url, :image, :image_file_name, :url, :description, :end_date, :funding_goal, :details, :category_id, rewards_attributes: [:title, :description, :cost, :delivery_date])
  end
end
