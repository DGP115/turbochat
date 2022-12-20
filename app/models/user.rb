# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # This scope statement is a helper that discludes us, the current user, from
  # the list of users to chat with
  scope :all_except, ->(user) { where.not(id: user) }
end
