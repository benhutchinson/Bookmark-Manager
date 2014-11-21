require 'mailgun'

mg_client = Mailgun::Client.new ENV['MY_MAILGUN_KEY']

message_params = {:from    => ENV['MY_MAILGUN_SANDBOX'],
                  :to      => ENV['MY_MAILGUN_EMAIL'],
                  :subject => 'Bookmark Manager: Reset Your Password',
                  :text    => 'Time to do this!'}

mg_client.send_message ENV['MY_MAILGUN_SANDBOX2'], message_params
