require 'georuby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

r = Hash.new {|h, k| h[k] = Hash.new {|h, k| h[k] = 0}}
def show(r)
  s = ''
  r.keys.sort.each {|k|
    count = r[k]['COUNT']
    s += "# #{k} (#{r[k]['COUNT']} features)\n"
    r[k].each {|key, value|
      next if key == 'COUNT'
      s += "- #{key} #{value} (#{(100.0 * value / count).round}%)\n"
    }
    s += "\n"
  }
  s
end
Dir.glob('../*') {|dir|
  next unless /^gm(.*?)(\d\d)$/.match File.basename(dir)
  (country, version) = [$1, $2]
#next unless country == 'jp'
#next unless version == '22'
  Dir.glob("#{dir}/*.shp") {|path|
    fn = File.basename(path, '.shp')
    next if %w{tileref tileret}.include?(fn)
    ShpFile.open(path) {|shp|
      fields = shp.fields.map {|f| f.name.downcase}
      fields = fields.map {|f|
        (%w{id shape_leng shape_area}.include?(f) || f.include?('_des') || f.include?('_id')) ? nil : f}.compact
      print fn, fields, "\n"
      ShpFile.open(path) {|shp|
        shp.each {|f|
          next if f.data.nil? # gmjp22/roadl_jpn workaround
          r[f.data['f_code']]['COUNT'] += 1
          fields.each {|field|
            r[f.data['f_code']][field] += 1
          }
        }
      }
print show(r)
File.write('inspector.md', show(r))
    }
  }
}
File.write('inspector.md', show(r))
