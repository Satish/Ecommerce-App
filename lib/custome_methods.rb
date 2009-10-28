def uploaded_file(path, filename='', content_type='image/jpg')
  if filename.empty?
    rindex = path.rindex(/\\|\//)
    filename = path[rindex+1..-1] if rindex
  end

  t = Tempfile.new(filename)
  t.binmode
  FileUtils.copy_file(path, t.path)
  (class << t; self; end).class_eval do
    alias local_path path
    define_method(:original_filename) {filename}
    define_method(:content_type) {content_type}
  end
  return t
end

#  # Don't forget to back up first!
#  desc "Move all the photographs to s3 server with atachment_fu (back up first!)."
#  task :move_to_fu => :environment do
#    raise "Please specify an environment" if ENV['RAILS_ENV'].nil?
#    Photograph.find(:all).each do |p|
#      fl = uploaded_file(File.join('public', 'photograph', 'file', p.id.to_s, p.file))
#      #  Photograph.create(p.attributes.update(:uploaded_data=>fl))
#      p.update_attributes(:uploaded_data=> fl)
#    end
#  end
  
