class ResetCounterCacheOnPandaCmsTemplate < ActiveRecord::Migration[7.1]
  def change
    PandaCms::Template.find_each { |t| PandaCms::Template.reset_counters(t.id, :pages) }
  end
end
