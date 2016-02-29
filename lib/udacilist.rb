class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ? options[:title] : "Untitled List"
    @items = []
  end
  def add(type, description, options={})
    types = {todo: TodoItem, event: EventItem, link: LinkItem}
    if types[type.to_sym] == nil
      raise UdaciListErrors::InvalidItemType, "This type is invalid"
    else
      if options[:priority] && !(["low", "medium", "high"].include? options[:priority])
        raise UdaciListErrors::InvalidPriorityValue, "This priority value is invalid"
      else
        @items << types[type.to_sym].new(description, options)
      end
    end
  end
  def change_priority(index, priority)
    if @items[index-1].respond_to? :priority
      @items[index-1].priority = priority
    else
      raise UdaciListErrors::IncorrectItemType, "This item is not todo"
    end
     #unless @items[index-1].class.name.downcase.include? "todo"

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
