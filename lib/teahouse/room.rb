module Teahouse
  class Room < Ohm::Model
    attribute :uuid
    attribute :name
    unique    :uuid
    index     :uuid
    list      :messages, 'Teahouse::Message'

    class << self
      def find_or_create_by_uuid(uuid)
        with(:uuid, uuid) || create(uuid: uuid)
      end
    end

    def add_admin(name)
      Ohm.redis.call "SADD", "#{key}:admins", name
    end

    def add_participant(name)
      Ohm.redis.call "SADD", "#{key}:partics", name
    end

    def admins
      Ohm.redis.call "SMEMBERS", "#{key}:admins"
    end

    def participants
      Ohm.redis.call "SMEMBERS", "#{key}:partics"
    end

    def display_name
      name || uuid
    end

    def build_hash
      {
        'room' => {
          'name' => display_name,
          'subscription' => "/rooms/#{uuid}"
        },
        'messages' => self.messages.map{ |m| m.build_hash }
      }
    end

  end
end
