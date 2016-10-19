require 'sqlite3'
require 'sequel'

dict = {}
Dir.glob('../*vt') {|dir|
  /^gm(.*?)(\d\d)vt$/.match File.basename(dir)
  (country, version) = [$1, $2]
  path = "#{dir}/data.mbtiles"
  next unless File.exist?(path)
  db = Sequel.sqlite(path)
  dict["#{country}#{version}"] = db[:tiles].count
}
dict.keys.sort{|a, b| dict[a] <=> dict[b]}.each {|key|
  print "#{key}: #{dict[key]}\n"
}
