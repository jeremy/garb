module Garb
  class Account
    attr_reader :id, :name, :profiles

    def initialize(profiles)
      @id = profiles.first.account_id    
      @name = profiles.first.account_name
      @profiles = profiles
    end

    def self.all(session = Session)
      Profile.all(session).group_by(&:account_id).map { |id, profiles| new profiles }
    end
  end
end
