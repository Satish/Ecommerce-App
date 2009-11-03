# == Schema Information
#
# Table name: email_templates
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  name       :string(255)
#  subject    :string(255)
#  from       :string(255)
#  cc         :string(255)
#  bcc        :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class EmailTemplate < ActiveRecord::Base

  attr_readonly :name
  attr_protected :store_id

  validates_presence_of :name, :from, :store_id
  validates_uniqueness_of :name, :scope => [:store_id]

  validates_format_of :from, :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{ |et| !et.from.blank? }
  validates_format_of :cc, :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{ |et| !et.cc.blank? }
  validates_format_of :bcc, :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{ |et| !et.bcc.blank? }

  belongs_to :store

  def after_validation
    errors.add :template, @syntax_error unless @syntax_error.nil?
  end

  def body=(text)
    self[:body] = text
    begin
      self.parsed_body = Marshal.dump(Liquid::Template.parse(text))
    rescue Liquid::SyntaxError => error
      @syntax_error = error.message
    end
  end

  def self.search(query, options)
    conditions = ["name LIKE ? OR body LIKE ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, name ASC" }
    
    paginate default_options.merge(options)
  end

  def render(options = {})
    Liquid::Template.parse(body).render(options)
  end

  private

#  def template
#    if self.parsed_body.blank?
#      @parsed_body = Liquid::Template.parse body
#      self.parsed_body = Marshal.dump @parsed_body
#      save
#    else
#      @parsed_body = Marshal.load(self.parsed_body)
#    end
#    @parsed_body
#  end

end
