# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  # foreign_keyでfollowingモデル(仮想)のidを親のキーとしてもつ??

  #フォローする側のUser（Following）から見て、フォローされる側のUser（Follower）を(中間テーブルを介して)集める。
  # なので親はfollowing_id(フォローする側)
  has_many :active_relationships, class_name: "Follow", foreign_key: :following_id

  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  # followページを作るのに必要。
  has_many :followings, through: :active_relationships, source: :follower

  #フォローされる側のUser（Follower）から見て、フォローしてくる側のUser（Following）を(中間テーブルを介して)集める。
  # なので親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: "Follow", foreign_key: :follower_id

  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
end
