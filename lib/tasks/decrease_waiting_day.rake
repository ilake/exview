namespace :daily do
  desc 'decrease waiting days'
  task :decrease_waiting_days => :environment do
    Assign.transaction do
      Assign.unexpired.unsent.each do |a|
        Assign.decrement_counter(:waiting_days, a.id)
        #because the a still cache the waiting days
        if a.waiting_days == 2
          #send remind email
          Notifier.delay.assigned_user_expire_remind(a.sender, a.receiver)
        elsif a.waiting_days == 1
          a.destroy
        end
      end
    end
  end
end
