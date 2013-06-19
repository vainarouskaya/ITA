#!/bin/bash

# This command executes the test

#bundle exec ruby ./lib/static_element_validation.rb -d www.shopping.com -p ./etc/test_specs/sdc_page_urls.json
bundle exec ruby ./lib/static_element_validation.rb -d www.shopping.com -p ./etc/test_specs/sdc_page_urls.json --exitstatus

