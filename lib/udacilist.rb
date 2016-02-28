class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ? options[:title] : "Untitled List"
    @items = []
  end
  def add(type, description, options={})
    type = type.downcase
    case type
      when "todo"
        if options[:priority]
          raise UdaciListErrors::InvalidPriorityValue, "This priority value is invalid" unless ["low", "medium", "high"].include? options[:priority]
        end
        @items.push TodoItem.new(description, options)
      when "event"
        @items.push EventItem.new(description, options)
      when "link"
        @items.push LinkItem.new(description, options)
      else
        raise UdaciListErrors::InvalidItemType, "This type is invalid"
    end
  end
  def delete(index)
    if index > @items.size
      raise UdaciListErrors::IndexExceedsListSize, "This index exceeds list size"
    else
      @items.delete_at(index - 1)
    end
  end
  def all
    rows = []
    @items.each_with_index do |item, position|
      row = ["#{position + 1}) #{item.details}"]
      rows << row
    end
    table  = Terminal::Table.new title: @title, rows: rows
    puts table
  end
end
