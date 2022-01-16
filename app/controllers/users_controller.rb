# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.with_attached_avatar.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def follows
    user = User.find(params[:id])
    # user.followingsができるようにuser.rbで、
    # has_many :followings, through: :active_relationships, source: :follower
    # を定義していたのか...
    byebug
    @users = user.active_relationships
  end

  def followers
    user = User.find(params[:id])
    byebug
    @users = user.passive_relationships
  end
end
