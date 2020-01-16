module Traceable
  extend ActiveSupport::Concern

  def tracer
    return 'unknown' unless created_at?

    if (Time.now.to_date - created_at.to_date).to_i.zero?
      created_at.strftime('%H:%M')
    elsif created_at.year == Time.now.year
      created_at.strftime('%m-%d %H:%M')
    else
      created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
