module JokerDMAPI
  module Result
    # Check result
    #
    # Get <tt>proc_id</tt>
    # Returned <tt>true</tt> if done (result deleted)
    def complete?(proc_id)
      response = result_retrieve(proc_id)
      result = parse_attributes(response[:body].split("\n\n", 1)[0])
      return false unless result.has_key? :completion_status
      case result[:completion_status]
        when 'ack' then
          result_delete proc_id
          true
        when 'nack' then
          raise_response response
        else
          false
      end
    end

    def result_retrieve(proc_id)
      query :result_retrieve, { proc_id: proc_id }
    end

    def result_delete(proc_id)
      query :result_delete, { proc_id: proc_id }
    end

  end
end