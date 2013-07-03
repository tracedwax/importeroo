module KmEverything
  class << self
    attr_accessor :record_every_controller_action
    attr_accessor :event_names
    attr_accessor :events_to_exclude
  end

  class KmEvent < Struct.new(:controller_name, :action_name)
    def event
      unless event_excluded?
        specified_event || unspecified_event
      end
    end

    private

    def specified_event
      controller_actions = KmEverything.event_names[controller_name]
      controller_actions[action_name] if controller_actions
    end

    def unspecified_event
      "#{controller_name}##{action_name}" if KmEverything.record_every_controller_action
    end

    def event_excluded?
      if events_to_exclude && events_to_exclude[controller_name]
        events_to_exclude[controller_name].include?(action_name)
      end
    end

    def events_to_exclude
      KmEverything.events_to_exclude
    end
  end
end
