# Versão 0: Otimização do código (sem concorrência)

require "../structs/*"

class IDW
  getter numerator : Float64
  getter weights : Float64
  property point
  property power = 2

  def initialize(point : Point)
    @numerator = 0.0
    @weights = 0.0
    @point = point
  end

  def calculate_idw(point_readed : Point, value_readed : Float64)
    distance = @point.get_distance(point_readed)
    weight = 1.0 / (distance ** power)

    @numerator += value_readed * weight
    @weights += weight
  end

  def get_idw
    @numerator / @weights
  end
end

def process_line(line : String, idw_calculator : IDW)
  end_number_1 = line.index(",").not_nil!
  end_number_2 = line.index(",", offset: end_number_1 + 1).not_nil!

  line_x = line[0..(end_number_1 - 1)].to_i
  line_y = line[(end_number_1 + 1)..(end_number_2 - 1)].to_i
  line_value = line[(end_number_2 + 1)..line.size].to_f

  point_readed = Point.new(line_x, line_y)

  idw_calculator.calculate_idw(point_readed, line_value)
end

def main()
  start_time = Time.utc.to_unix
  file_path = "./data/measurements.txt"

  x = 0
  y = 0

  if ARGV.size == 2
    x = ARGV[0].to_i
    y = ARGV[1].to_i
  else
    puts "Coordenadas inválidas."
    exit(1)
  end

  point = Point.new(x, y)
  idw_calculator = IDW.new(point)

  begin
    File.open(file_path) do |file|
      while line = file.gets
        process_line(line, idw_calculator)
      end
    end
  rescue e
    puts "Erro ao ler o arquivo: #{e.message}"
    exit(1)
  end

  idw = idw_calculator.get_idw

  puts "IDW: %.1f" % idw

  end_time = Time.utc.to_unix
  puts "Executed in: #{end_time - start_time}s"
end

main