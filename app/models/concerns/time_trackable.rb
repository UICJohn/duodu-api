module TimeTrackable
  extend ActiveSupport::Concern
  def trace_on_create
    return 'unknown' unless self.created_at?
    (1..7).each do |range|
      return "#{range}天前" if self.created_at < range.days.ago.end_of_day
    end
    return self.created_at.strftime('%H:%M')
  end
end
