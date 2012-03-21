module SourcesHelper
  def source_tag? tag
    @source.tags.include?(tag) unless @source.nil?
  end

  def with_work?
    current_user.works.find(params['work_id']) if params['work_id']
  rescue
    nil
  end
end
