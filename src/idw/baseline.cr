# Versão serial - Sem otimização

require "../structs/*"

def calculate_idw(map : Array(MapEntry), power : Int32, point_readed : Point)
  numerator = 0.0
  weights = 0.0

  map.each do |map_entry|
    distance = point_readed.get_distance(map_entry.point)

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
    File.open(file_path) do |file|
      while line = file.gets
        data = line.split(",")
        line_x = data[0].to_i
        line_y = data[1].to_i
        line_value = data[2].to_f

        point = Point.new(line_x, line_y)
        map_entry = MapEntry.new(point, line_value)
        map << map_entry
      end
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