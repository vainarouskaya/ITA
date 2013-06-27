#!/bin/bash

# This command executes the test of SignUp App v1 and v4

#bundle exec ruby ./lib/static_element_validation.rb -d www.khatilov.com -p ./etc/test_specs/khatilovdotcom_page_urls.json
#bundle exec ruby ./lib/static_element_validation.rb -d www.khatilov.com -p ./etc/test_specs/khatilovdotcom_page_urls_attributes.json

bundle exec ruby ./lib/static_element_validation.rb -d www.khatilov.com -p ./etc/test_specs/khatilovdotcom_page_urls.json --exitstatus
#bundle exec ruby ./lib/static_element_validation.rb -d www.khatilov.com -p ./etc/test_specs/khatilovdotcom_page_urls_attributes.json --exitstatus
