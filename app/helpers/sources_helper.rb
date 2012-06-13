module SourcesHelper

  # Method checks if provided tag is associated with source (instance variable @source)
  #
  # * *Args*    :
  #   tag
  # * *Returns* :
  #   true / false
  def source_tag? tag
    @source.tags.include?(tag) unless @source.nil?
  end

  # Method checks if in GET is correct work id
  #
  # * *Args*    :
  #   no ( check params['work_id'])
  # * *Returns* :
  #   work object / nil
  def with_work?
    current_user.works.find(params['work_id']) if params['work_id']
  rescue
    nil
  end

  # Method build string representation of current user tags
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   string of tags ('tag1','tag2') / ''
  def tag_list
    tags = current_user.tags
    if tags
      tag_names = []
      tags.each do |tag|
         tag_names << "\'#{tag.name}\'"
      end
      tag_names.join(',')
    else
       ''
    end
  end

  # Method build string representation of current user tags associated with source
  #
  # * *Args*    :
  #   no ( get related tags for instance variable @tags)
  # * *Returns* :
  #   string of tags ('tag1','tag2') / ''
  def related_tags
    tags = []
    @source.tags.each do |tag|
      tags << tag.name
    end
    tags.join(',')
  end

  # Method build string representation of current user tags (for tag_js)
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   string of tags ('tag1','tag2') / ''
  def get_user_tags
    tags = []
    current_user.tags.each do |tag|
      tags << '"' + tag.name + '"'
    end
    tags.join(',')
  end

end
