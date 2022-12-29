# frozen_string_literal: true

# Controller for chat rooms
class RoomsController < ApplicationController
  #  The authenticate_user! method comes from Devise
  before_action :authenticate_user!

  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)

    render 'index'
  end

  def create
    @room = Room.create(whitelist_room_params)
  end

  def show
    @current_room = Room.find(params[:id])

    @room = Room.new
    @rooms = Room.public_rooms

    @message = Message.new
    @messages = @current_room.messages.order(created_at: :asc)

    @users = User.all_except(current_user)

    render 'index'
  end

  private

  def whitelist_room_params
    params.require(:room).permit(:name)
  end
end
