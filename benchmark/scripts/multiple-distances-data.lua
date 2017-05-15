local thread_counter = 1

-- Set global variables per thread
function setup(thread)
  thread:set("id", thread_counter)
  thread:set("counter", 0)
  thread:set("counter_limit", 0)
  thread:set("chunck_size", 0)
  thread_counter = thread_counter + 1
end

-- Enable counter to access a chunck of requests
function init(args)
  chunck_size = math.floor(#distance_data / args[1])
  counter = chunck_size * id
  counter_limit = counter + chunck_size
end

-- Load distance data from the file
function load_distance_data_from_file(file)
  lines = {}

  -- Check if the file exists
  -- Resource: http://stackoverflow.com/a/4991602/325852
  local f=io.open(file,"r")
  if f~=nil then
    io.close(f)
  else
    -- Return the empty array
    return lines
  end

  -- If the file exists loop through all its lines
  -- and add them into the lines array
  for line in io.lines(file) do
    if not (line == '') then
      lines[#lines + 1] = line
    end
  end

  return lines
end

distance_data = load_distance_data_from_file("seeds/distance_locations.txt")
print("multiple-distances-data: Found " .. #distance_data .. " distances")

request = function()
  -- Get the next distance array element
  body = distance_data[counter]

  counter = counter + 1

  -- If the counter is longer than the distance_data array length then reset it
  if counter == counter_limit then
    counter = counter_limit - chunck_size
  end

  -- Return the request object with the current URL path
  return wrk.format("POST", "/shipping/distances", nil, body)
end