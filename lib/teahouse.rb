require 'ohm'
require 'faye'
require 'json'
require 'liquid'
require 'sinatra/base'
require 'teahouse/room'
require 'teahouse/message'
module Teahouse
  class App < Sinatra::Base
    use Faye::RackAdapter, mount: '/faye', timeout: 25

    set :views,         Proc.new { File.join(root, '..', 'themes', 'bootstrap') }
    set :public_folder, Proc.new { File.join(root, '..', 'themes', 'bootstrap') }

    before '/rooms/:uuid/*' do
      @room = Room.find_or_create_by_uuid(params[:uuid])
    end

    helpers do
      def room_messages_path(room, username)
        "/rooms/#{room.uuid}/messages/#{username}"
      end

      def room_user_path(room, username)
        "/rooms/#{room.uuid}/users/#{username}"
      end
    end

    get '/rooms/:uuid/admins/:username' do
      @room.add_admin(params[:username])
      @room_h = @room.build_hash
      @room_h['url'] = room_messages_path(@room, params[:username])
      @messages = @room.messages.map{ |m| m.build_hash }
      liquid :index, locals: {room: @room_h, username: params[:username], messages: @messages}
    end

    get '/rooms/:uuid/users/:username' do
      @room.add_participant(params[:username])
      locals = {username: params[:username]}
      locals[:name] = params[:name] || params[:id]
      liquid :index, locals: locals
    end

    post '/rooms/:uuid/messages/:username' do
      content_type :json
      @message = Message.create(username: params[:username], content: params[:content], created_at: Time.now.to_i)
      @room.messages.push(@message)
      @message.to_hash.to_json
    end

  end
end

