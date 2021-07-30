class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :change_admin_rights]
  before_action :check_role!, only: [:index, :change_admin_rights]

  def index
    @users = User.all
  end

  def change_admin_rights
    @user = User.find(params[:id])

    if @user.update(admin: !@user.admin)
      redirect_to '/users'
    end
  end

  private

  def check_role!
    if current_user.admin != true
      redirect_to "/"
    end
  end
end