class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.to = "lake.ilakela@gmail.com"
  end
end
