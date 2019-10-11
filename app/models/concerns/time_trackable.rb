module TimeTrackable
  extend ActiveSupport::Concern

  def trace_on_create
    return 'unknown' unless created_at?

    (1..7).each do |range|
      return "#{range}天前" if created_at < range.days.ago.end_of_day
    end
    created_at.strftime('%H:%M')
  end
end
