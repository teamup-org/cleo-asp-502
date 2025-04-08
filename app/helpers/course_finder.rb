class CourseFinder
  DEFAULT_PAGE = 1
  ITEMS_PER_PAGE = 20

  def self.call(params, scope = Course.all)
    new(params, scope).call
  end

  def self.transcript_call(finder_param, recommended_scope)
    recommended_scope = recommended_scope.apply_filters(finder_param)
    recommended_scope.sorted(finder_param[:sort_by], finder_param[:direction])
  end

  def initialize(params, scope)
    @params = params
    @scope = scope
  end

  def call
    Course
      .apply_filters(@params)
      .sorted(@params[:sort_by], @params[:direction])
      .limit(ITEMS_PER_PAGE)
      .offset(safe_offset)
  end

  def transcript_call(scope = Course)
    scope
      .apply_filters(@params)
      .sorted(@params[:sort_by], @params[:direction])
      .limit(ITEMS_PER_PAGE)
      .offset(safe_offset)
      .left_joins(:transcript_courses)
      .where('transcript_courses.student_id IS NULL OR transcript_courses.student_id != ?', @params[:student])
  end

  private

  def safe_offset
    page = @params[:page].to_i
    page = DEFAULT_PAGE if page < 1
    (page - 1) * ITEMS_PER_PAGE
  end

  def scoped
    scope
  end
end
