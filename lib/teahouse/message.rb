module Teahouse
  class Message < Ohm::Model
    attribute :username
    attribute :content
    attribute :created_at

    def build_hash
      {
        'username'   => username,
        'content'    => content,
        'created_at' => Time.at(created_at.to_i)
      }
    end

  end
end

