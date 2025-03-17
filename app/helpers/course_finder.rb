class CourseFinder
  DEFAULT_PAGE = 1
  ITEMS_PER_PAGE = 20

  def self.call(params)
    new(params).call
  end

  def self.transcript_call(params)
    new(params).transcript_call
  end

  def initialize(params)
    @params = params
  end

  def call
    page = params[:page].to_i
    page = 1 if page < 1 # Ensure page is at least 1
    offset = (page - 1) * ITEMS_PER_PAGE # Ensure offset is never negative

    Course
      .apply_filters(params)
      .sorted(params[:sort_by], params[:direction])
      .limit(ITEMS_PER_PAGE)
      .offset(offset)
  end

  def transcript_call
    page = params[:page].to_i
    page = 1 if page < 1 # Ensure page is at least 1
    offset = (page - 1) * ITEMS_PER_PAGE # Ensure offset is never negative

    Course
      .apply_filters(params)
      .sorted(params[:sort_by], params[:direction])
      .limit(ITEMS_PER_PAGE)
      .offset(offset)
      .left_joins(:transcript_courses)
      .where('transcript_courses.student_id IS NULL OR transcript_courses.student_id != ?', params[:student])
  end

  private

  attr_reader :params

  def offset
    ((params[:page].to_i || DEFAULT_PAGE) - 1) * ITEMS_PER_PAGE
  end
end
