Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60 # sleep if empty queue
Delayed::Worker.max_attempts = 25
Delayed::Worker.max_run_time = 5.minutes # set to the amount of time of longest task will take
