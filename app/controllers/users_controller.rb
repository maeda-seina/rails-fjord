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
    # を定義していたのか
    # @users = user.active_relationships
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    # @users = user.passive_relationships
    @users = user.followers
    # なぜhas_many :followers, through: :passive_relationships, source: :followingがあるのか調査
    # →user情報を取れるから便利。passive_relationshipsでは取れない。
    #
    # user.passive_relationships
    # #<ActiveRecord::Associations::CollectionProxy
    # [#<Follow id: 1, following_id: 51, follower_id: 1, created_at: "2022-01-15 11:36:55.564687000 +0000", updated_at: "2022-01-15 11:36:55.564687000 +0000">
    # , #<Follow id: 2, following_id: 52, follower_id: 1, created_at: "2022-01-15 11:44:49.706156000 +0000", updated_at: "2022-01-15 11:44:49.706156000 +0000">]>
    #
    # user.followers
    # has_many :followers, through: :passive_relationships, source: :following
    # #<ActiveRecord::Associations::CollectionProxy
    # [#<User id: 51, email: "aaa@aaa.com", created_at: "2022-01-15 09:12:54.182702000 +0000", updated_at: "2022-01-15 09:12:54.182702000 +0000", name: "aaa", postal_code: "573-0102", address: "枚方市", s_introduction: "">
    # , #<User id: 52, email: "bbb@bbb.com", created_at: "2022-01-15 11:44:36.952727000 +0000", updated_at: "2022-01-15 11:44:36.952727000 +0000", name: "bbb", postal_code: "573-0102", address: "枚方市", self_introduction: "">]>
  end
end
