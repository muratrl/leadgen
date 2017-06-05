require 'mail'
require 'csv'

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'localhost:3000',
            :user_name            => 'sdrexel@rentlever.com',
            :password             => 's3rv1c3!',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }


Mail.defaults do
  delivery_method :smtp, options
end

CSV.foreach('batch.csv') do |row|

Mail.deliver do
       to "#{row[3]}"
     from 'Scott Drexel <sdrexel@rentlever.com>'
     subject "Re: Your house at #{row[4]}"
     header['X-Cam'] = "06-02-07-W2"
     body "Hi #{row[1]},

Sorry to bug you again, but I wanted to pop my email back up. If you have 5-10 minutes to chat, I think we could generate great revenue in the range I mentioned in my previous email, #{row[5]} to #{row[6]}, and potentially even exceed it.

I'm also happy to shoot you an overview of our services (a bit more about our stats, how we work, etc.) if that's helpful.

Thanks, #{row[1]}.

-Scott


On June 02, 2017, at 5:04 PM, Scott Drexel <sdrexel@rentlever.com> wrote:

Hi #{row[1]},

My name is Scott, and my company, rentLEVER, is the fastest growing vacation rental manager in Lake Tahoe.

I was running through a list of homes, and came across yours at #{row[4]}.  I ran a brief analysis to get an initial idea of what kind of vacation rental income we'd be able to generate, and came up with a range of #{row[5]} and #{row[6]}. That's just based on a surface review, and it's entirely possible we could exceed that.

Do you have 10 minutes to connect about your home? Our unique approach results in greater profit for our home owners, reduced management fees (just 18%), and the highest standards for guest quality and care for your home.

Thanks, #{row[1]}.

Regards,
Scott Drexel, CEO
(530) 206-5063

rentLEVER - vacation rental management. smarter.

scott drexel | ceo • rentLEVER | 832 sansome st | san francisco • ca • 94111

find out how much your home could earn at rentLEVER.com!

"
   end
    sleep 1
    p "#{row[3]} email sent"
 end
