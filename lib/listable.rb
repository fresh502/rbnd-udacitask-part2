module Listable
	def format_description(description)
    "#{description}".ljust(25)
  end
  def format_date(options={})
		if options.has_key?(:start_date) || options.has_key?(:end_date)
			dates = options[:start_date].strftime("%D") if options[:start_date]
			dates << " -- " + options[:end_date].strftime("%D") if options[:end_date]
			dates = "N/A" if !dates
			return dates
		elsif options.has_key?(:due)
			options[:due] ? options[:due].strftime("%D") : "No due date"
		end
	end
	def format_priority(priority)
    value = " ⇧" if priority == "high"
    value = " ⇨" if priority == "medium"
    value = " ⇩" if priority == "low"
    value = "" if !priority
    return value
  end
end
