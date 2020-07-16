require 'uri' 
require 'net/http'
require 'openssl'
require 'json'

def request(url_requested) 
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port) 
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["app_id"] = '50ed91ae-e111-4b62-8ff8-76c32857bd7c'
    request["app_key"] = 'cEDpXFgIjWAuVZ76ec4cAh45w2ZhZ7MX8G3YWrIt' 
    response = http.request(request)
    return JSON.parse(response.body)
end

body = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=cEDpXFgIjWAuVZ76ec4cAh45w2ZhZ7MX8G3YWrIt')
array = body["photos"]

values = (array.map {|photos| [photos["img_src"]]})
name = (array.map {|name| [name["camera"]]})


def build_web_page(array)
    
    output = "\n<html>\n\t<head>\n\t</head>\n\t<body>\n\t\t<ul>"
    
    array.each do |array_int|
        array_int.each do |ele|
            output += "\n\t\t\t<li><img src= #{ele} /> </li>\n"
        end
    end
    
    output += "\n\t\t</ul>\n\t<body>\n</html>"
    File.write('index.html', output)
end


build_web_page(values)


def photos_count(name)
    new_hash = {}
    new_array = []
    name.each do |camera|
        camera.each do |names|
            names.each do |k,v|
                if k == "full_name"
                    new_hash[k] = v
                    new_array.push new_hash.values
                    
                end
            end
        end
    end 
    filter = new_array.group_by { |x| x }

    filter.each do |k,v|
        filter[k] = v.count
    end

    filter
end

print photos_count(name)


