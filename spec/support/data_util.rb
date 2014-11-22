class DataUtil
  TARGETS = %w(User)

  def self.clear
    models.each(&:delete_all)
  end

  def self.models
    TARGETS.map(&:constantize)
  end
end
