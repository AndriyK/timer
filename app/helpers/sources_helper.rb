module SourcesHelper
  def source_tag? tag
    @source.tags.include?(tag) unless @source.nil?
  end

  def with_work?
    current_user.works.find(params['work_id']) if params['work_id']
  rescue
    nil
  end

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

  def related_tags
    tags = []
    @source.tags.each do |tag|
      tags << tag.name
    end
    tags.join(',')
  end

  def get_user_tags
    tags = []
    current_user.tags.each do |tag|
      tags << '"' + tag.name + '"'
    end
    tags.join(',')
  end

end
