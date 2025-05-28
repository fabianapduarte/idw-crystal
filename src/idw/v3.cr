# Versão 3: Paralelismo e mutex

require "../structs/*"
require "fiber"
require "file_utils"

class IDW
  getter numerator : Float64
  getter weights : Float64
  property point
  property power = 2
  property mutex = Mutex.new

  def initialize(point : Point)
    @numerator = 0.0
    @weights = 0.0
    @point = point
  end

  def calculate_idw(point_readed : Point, value_readed : Float64)
    distance = @point.get_distance(point_readed)
    weight = 1.0 / (distance ** power)

    mutex.lock
    @numerator += value_readed * weight
    @weights += weight
    mutex.unlock
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

def get_file_segments(file_size : Int64, num_threads : Int32, file : File)
  segments = [] of File_Segment
  last_location = 0
  chunk_size = file_size // num_threads

  num_threads.times do |i|
    start_segment = 0
    
    if i != 0
      last_location += 1
      start_segment = last_location
    end

    if (i == num_threads - 1)
      end_segment = file_size
    else
      last_location = start_segment + chunk_size
      read_ahead = 16
      file.read_at(last_location, read_ahead) do |buffer|
        buffer.each_char do |c|
          if c != '\n'
            last_location += 1
          else
            break
          end
        end
      end
      last_location += 1
      end_segment = last_location
    end

    segment = File_Segment.new(start_segment.to_i64, end_segment.to_i64)
    segments << segment
  end

  segments
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

  num_threads = 4
  file_size = File.size(file_path)
  file = File.open(file_path)
  segments = get_file_segments(file_size, num_threads, file)
  file.close

  done_channel = Channel(Nil).new(num_threads)

  mt_context = Fiber::ExecutionContext::MultiThreaded.new("workers", num_threads)

  num_threads.times do |i|
    file_segment = segments[i]

    mt_context.spawn do
      begin
        File.open(file_path) do |file|
          file.read_at(file_segment.start_segment, file_segment.end_segment - file_segment.start_segment) do |buffer|
            builder = String::Builder.new
            
            buffer.each_char do |c|
              if c == '\n'
                process_line(builder.to_s, idw_calculator)
                builder = String::Builder.new
              else
                builder << c
              end
            end
          end
        end
        done_channel.send(nil)
      rescue e
        puts "Erro ao ler o arquivo: #{e.message}"
        exit(1)
      end
    end
  end

  num_threads.times do
    done_channel.receive
  end

  idw = idw_calculator.get_idw

  puts "IDW: %.1f" % idw

  end_time = Time.utc.to_unix
  puts "Executed in: #{end_time - start_time}s"
end

main