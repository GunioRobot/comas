class CertifFormatLine < ActiveRecord::Base
  Justifications = [:left, :center, :right, :full]
  ContentSources = {0 => _('Static'),
    1 => _('Person'),
    2 => _('Conference')}

  belongs_to :certif_format

  validates_presence_of(:certif_format_id, :content_source, :content, 
                        :x_pos, :y_pos, :max_width, :font_size, :justification)
  validates_numericality_of(:content_source, :x_pos, :y_pos, :max_width, 
                            :font_size)
  validates_inclusion_of :content_source, :in => ContentSources.keys
  validates_inclusion_of :justification, :in => Justifications
  validates_associated :certif_format

  def for(person, conference)
    @person = person
    @conference = conference
  end

  def text
    case content_source
    when 0
      return content
    when 1
      obj = @person 
    when 2
      obj = @conference
    else
      raise NoMethodError, _('Undefined content source %d for %d (%d)') % 
        [content_source, id, certif_format_id]
    end

    return obj.send(content) if
      obj.class.column_names.include? content
    raise NoMethodError, _('Undefined attribute %s for %s in format ' <<
                           'line %d (%d)') % [content, obj.class, 
                                              id, certif_format_id]
  end
end
