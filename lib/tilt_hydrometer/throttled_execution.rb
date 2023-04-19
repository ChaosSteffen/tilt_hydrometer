# frozen_string_literal: true

module TiltHydrometer
  module ThrotteledExecution
    def throtteled_execution(uuid)
      unless execution_allowed?(uuid)
        LOGGER.debug('Execution got throtteled')
        return
      end

      reset_timer(uuid)

      yield
    end

    def execution_allowed?(uuid)
      return true if timers[uuid].nil?

      timers[uuid] + @interval < Time.now.utc
    end

    def reset_timer(uuid)
      timers[uuid] = Time.now.utc
    end

    def timers
      @timers ||= {}
    end
  end
end
