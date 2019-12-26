class Etl::ViewPost

  def self.process(user_id:, post_id: )
    date_dimension = Warehouse::DateDimension.find_dimension_for(Time.now)
    Warehouse::PostFact.create(
      user_id: user_id,
      post_id: post_id,
      date_id: date_dimension.id,
      action: Warehouse::PostFact.actions['view']
    )
  end

end