require 'benchmark'
require 'time'
require 'active_support/time'




start_time = Time.now
end_time = Time.now + 30.years
timestep = 30.minutes
time_array = []


Benchmark.bmbm do |x|
  x.report("time_iterate") {
    def time_iterate(start_time, end_time, step, &block)
     begin
       yield( start_time )
     end while ( start_time += step ) < end_time
    end

    time_iterate(start_time, end_time, 30.minutes) do |time|
      time_array << time
    end
   }

  x.report("while loop")  {
      minute = start_time
      while minute <= end_time
        time_array.push(minute)
        minute += 1800
      end
   }

   x.report("while loop shovel")  {
     minute = start_time
     while minute <= end_time
       time_array << minute
       minute += 1800
     end
    }

    x.report("unless loop shovel")  {
      minute = start_time
      until minute > end_time do
        time_array << minute
        minute += 1800
      end
     }


     x.report("range.to_i step do"){
     (start_time.to_i..end_time.to_i).step(1800) do |min|
       min = Time.at(min)
       time_array.push(min)
     end
     }


     x.report("range.to_i step do shovel"){
     (start_time.to_i..end_time.to_i).step(1800) do |min|
       min = Time.at(min)
       time_array << min
     end
     }

     x.report("Enumerator"){
       Enumerator.new { |y| loop { y.yield start_time; start_time += 30.minutes } }.take_while { |d| d <= end_time }
     }





end
