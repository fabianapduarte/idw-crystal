struct MapEntry
  getter point : Point
  getter value : Float64

  def initialize(@point : Point, @value : Float64)
  end
end