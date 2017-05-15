-- Load distance data from the file
function load_cost_data_from_file(file)
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

cost_data = load_cost_data_from_file("seeds/cost_locations.txt")
print("multiple-cost-data: Found " .. #cost_data .. " costs")

request = function()
  -- Get the next distance array element
  query = cost_data[math.random(#cost_data)]

  -- Return the request object with the current URL path
  return wrk.format("GET", "/shipping/cost?" .. query)
end