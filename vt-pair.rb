# check if each gm directory has gmvt directory
Dir.glob('../gm*') {|path|
  next unless File.basename(path).match(/^(.*?)(\d\d)$/)
  print "#{path} - #{path}vt : #{File.directory?(path + 'vt')}\n"
}
