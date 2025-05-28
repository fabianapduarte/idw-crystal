struct File_Segment
  getter start_segment : Int64
  getter end_segment : Int64

  def initialize(@start_segment : Int64, @end_segment : Int64)
  end
end