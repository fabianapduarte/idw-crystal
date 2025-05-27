# Versão serial - Sem otimização

struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end
end

struct MapEntry
  getter point : Point
  getter value : Float64

  def initialize(@point : Point, @value : Float64)
  end
end

def get_distance(p : Point, q : Point)
  dx = p.x - q.x
  dy = p.y - q.y
  Math.sqrt(dx**2 + dy**2)
end

def calculate_idw(map : Array(MapEntry), power : Int32, point_readed : Point)
  numerator = 0.0
  weights = 0.0

  map.each do |map_entry|
    distance = get_distance(map_entry.point, point_readed)

    if distance == 0.0
      return map_entry.value
    end

    weight = 1.0 / (distance ** power)
    numerator += map_entry.value * weight
    weights += weight
  end

  return numerator / weights
end

def main()
  start_time = Time.utc.to_unix
  file_path = "./data/measurements.txt"
  power = 2

  x = 0
  y = 0
  map = [] of MapEntry

  if ARGV.size == 2
    x = ARGV[0].to_i
    y = ARGV[1].to_i
  else
    puts "Coordenadas inválidas."
    exit(1)
  end

  begin
    File.each_line(file_path) do |line|
      data = line.split(",")
      line_x = data[0].to_i
      line_y = data[1].to_i
      line_value = data[2].to_f

      point = Point.new(line_x, line_y)
      map_entry = MapEntry.new(point, line_value)
      map << map_entry
    end
  rescue e
    puts "Erro ao ler o arquivo: #{e.message}"
    exit(1)
  end

  point = Point.new(x, y)

  idw = calculate_idw(map, power, point)

  puts "IDW: %.1f" % idw

  end_time = Time.utc.to_unix
  puts "Executed in: #{end_time - start_time}s"
end

main