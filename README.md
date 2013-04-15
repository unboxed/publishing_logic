# publishing_logic

### Installation

To install add the following to your gemfile:

  gem 'publishing_logic'

After installing the gem add the publishing logic fields to your model by running:

  bundle exec rails generate publishing_logic_fields NAME [options]

To see full documentation of generator options run

  bundle exec rails generate publishing_logic:fields

### Publishing logic for ActiveRecord models

* Generates a migration with fields required for publishing logic. Fields are:
  * publishing_enabled:boolean
  * published_at:datetime
  * published_until:datetime (optional)
* Defines logic on models that include PublishingLogic::ModelLogic
  * published named scope
  * published? method
  * ordering by published_at

The source for this gem can be found on http://github.com/unboxed/publishing_logic


### Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


### Copyright

Copyright (c) 2009 Unboxed Consulting and Channel 5 Broadcasting Ltd. See LICENSE for details.
