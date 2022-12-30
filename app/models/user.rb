# frozen_string_literal: true

# models teh user of this app
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  # This scope statement is a helper that discludes us, the current user, from
  # the list of users to chat with
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }
  has_many :messages
  has_one_attached :avatar

  after_commit :add_default_avatar, on: %i[create update]
  #
  # Customization to have Devise use username as login
  attr_writer :login

  validate :validate_username

  def login
    @login || username || email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions[:username].nil?
      where(conditions).first
    else
      where(username: conditions[:username]).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  def chat_avatar
    avatar.variant(resize_to_limit: [50, 50]).processed
  end

  private

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
    io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.jpg')),
    filename: 'default_avatar.jpg',
    content_type: 'image/jpg'
    )
  end

end
