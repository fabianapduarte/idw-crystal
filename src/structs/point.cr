struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def get_distance(other_point : Point)
    dx = @x - other_point.x
    dy = @y - other_point.y
    Math.sqrt(dx**2 + dy**2)
  end 
end