class Location
  attr_accessor :lat, :long
  def initialize(arg)
    if arg.is_a? String
      arr = arg.split(',')
      @lat = arr[0]
      @long = arr[1]
    elsif arg.size == 2 and arg.all? {|x| x.is_a? Numeric} 
      @lat = arg[0]
      @long = arg[1]
    else
      raise ArgumentError, "Argument is not string or numeric array of 2 elements, but a #{arg.class.name}"
    end
    #rescue
      #puts "invalid argument"
      ##TODO fix this
    #end
  end

  def coordinates
    [@lat, @long]
  end
#                 self.to_arr
end
