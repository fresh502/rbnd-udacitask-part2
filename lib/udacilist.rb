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
  def delete(*indices)
    indices.sort.reverse.each do |index|
      raise UdaciListErrors::IndexExceedsListSize, "These indices inlude the index which exceeds list size" if index > @items.size
      @items.delete_at(index-1)
    end
  end
  def all
    rows = []
    @items.each_with_index do |item, position|
      row = ["#{position + 1}) #{item.class.name.downcase.gsub('item', '')} : #{item.details}"]
      rows << row
    end
    table = Terminal::Table.new title: @title, rows: rows
    puts table
  end
  def filter(type)
    rows = []
    @items.each_with_index do |item, position|
      if item.class.name.downcase.include? type
        row = ["#{position + 1}) #{item.class.name.downcase.gsub('item', '')} : #{item.details}"]
        rows << row
      end
    end
    rows << ["There aren't any items of #{type} type"] if rows.size == 0
    table = Terminal::Table.new title: @title, rows: rows
    puts table
  end
end
