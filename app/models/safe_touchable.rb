# encoding: utf-8

module SafeTouchable

  def touch
    current_time = current_time_from_proper_timezone

    self.write_attribute('updated_at', current_time) if self.respond_to?(:updated_at)
    self.write_attribute('updated_on', current_time) if self.respond_to?(:updated_on)

    self.save(false)
  end

  private

  def current_time_from_proper_timezone
    self.class.default_timezone == :utc ? Time.now.utc : Time.now
  end

end