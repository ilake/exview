namespace :daily do
  desc 'decrease waiting days'
  task :decrease_waiting_days => :environment do
    Assign.transaction do
      Assign.unexpired.unsent.each do |a|
        Assign.decrement_counter(:waiting_days, a.id)
      end
    end
  end
end
