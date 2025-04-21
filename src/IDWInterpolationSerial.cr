struct Point
  getter x : Int32
  getter y : Int32
  getter value : Float64

  def initialize(@x : Int32, @y : Int32, @value : Float64)
  end
end

def getDistance(p : Point, q : Point)
  dx = p.x - q.x
  dy = p.y - q.y
  Math.sqrt(dx**2 + dy**2)
end

def calculateInverseDistanceWeighting(mapPoints : Array(Point), power : Int32, point : Point)
  numerator = 0.0
  weights = 0.0

  mapPoints.each do |mapPoint|
    distance = getDistance(mapPoint, point)

    if distance == 0.0
      return mapPoint.value
    end

    weight = 1.0 / (distance ** power)
    numerator += mapPoint.value * weight
    weights += weight
  end

  return numerator / weights
end

def main()
  filePath = "./data/measurements.txt"
  power = 2

  x = 0
  y = 0
  mapPoints = [] of Point

  if ARGV.size == 2
    x = ARGV[0].to_i
    y = ARGV[1].to_i
  else
    puts "Coordenadas inválidas."
    exit(1)
  end

  begin
    File.each_line(filePath) do |line|
      data = line.split(",")
      lineX = data[0].to_i
      lineY = data[1].to_i
      lineValue = data[2].to_f

      point = Point.new(lineX, lineY, lineValue)
      mapPoints << point
    end
  rescue e
    puts "Erro ao ler o arquivo: #{e.message}"
    exit(1)
  end

  point = Point.new(x, y, -1.0)

  idw = calculateInverseDistanceWeighting(mapPoints, power, point)

  puts "IDW: #{idw}"
end

main