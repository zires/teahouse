# encoding: utf-8
require 'ohm'
require 'faye'
require 'json'
require 'sinatra/base'
require 'teahouse/room'
require 'teahouse/message'
module Teahouse
  class App < Sinatra::Base
    use Faye::RackAdapter, mount: '/faye', timeout: 25

    set :default_encoding, 'utf-8'
    set :public_folder, Proc.new { File.join(root, '..', 'themes', 'bootstrap') }

    helpers do
      def build_locals(uuid, username)
        @room  = Room.find_or_create_by_uuid(uuid)
        room_h = @room.build_hash
        room_h['username'] = username
        room_h
      end

      def html(view)
        File.read(File.join(settings.public_folder, "#{view.to_s}.html"))
      end
    end

    get '/rooms/:uuid/admins/:username.?:format?', provides: [:html, :json] do
      if params[:format] == 'json'
        @locals = build_locals(params[:uuid], params[:username])
        @room.add_admin(params[:username])
        content_type :js, charset: 'utf-8'
        "#{params[:callback]}(#{@locals.to_json})"
      else
        html :index
      end
    end

    get '/rooms/:uuid/users/:username.?:format?', provides: [:html, :json] do
      if params[:format] == 'json'
        @locals = build_locals(params[:uuid], params[:username])
        @room.add_participant(params[:username])
        content_type :js, charset: 'utf-8'
        "#{params[:callback]}(#{@locals.to_json})"
      else
        html :index
      end
    end

    post '/rooms/:uuid/messages/:username' do
      content_type :json, charset: 'utf-8'
      @room    = Room.find_or_create_by_uuid(params[:uuid])
      @message = Message.create(username: params[:username], content: params[:content], created_at: Time.now.to_i)
      @room.messages.push(@message)
      @message.to_hash.to_json
    end

  end
end

