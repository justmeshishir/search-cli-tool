# Ruby command line tool (ShiftCare Assignment)

This is a Ruby command line tool to search clients and find duplicates in given client json file.
It uses rake commands to run the tasks in terminal.
This project uses Ruby version `3.4.2` and Rails version `7.2.3`.

**Setup and usage instructions**

* Clone the repo

* Run `bundle install`

* To search client use `rake "client:search[CLIENT_FULL_NAME]"`. Replace `CLIENT_FULL_NAME` by the name you want to search.
  Example: `rake "client:search[John Doe]"`

* To find duplicates use `rake "client:find_duplicates"`

* You can find the specs under `spec/services/clients`

* Run `bundle exec rspec spec/services/clients/*` to run all specs.

**Assumptions and decisions made**
* Client data is provided in a JSON format.
* All clients have `id`, `full_name` and `email` fields. Additional fields are preserved but not required.
* All comparisons are case-insensitive.
* Empty and null values are excluded from duplicate detection or searching.
* Search feature only searches in `full_name` field.
* Original data is neither modified nor stored in database.
* Command returns error message if search or duplicate is not found.
* `Clients` service is created with `Search` and `FindDuplicates` classes.
* The `Base` class is responsible for reading `clients` data from provided json file and defines commonly used methods.

**Known limitations and areas for future improvement**
* May not be suitable for large dataset as entire dataset is loaded into memory at first.
* Only searches `full_name` field. However, coding is done in a way where we can declare the field to be searched.
* Duplicate only checks `email` field.
* In future, multi-fields search can be implemented.
* Using database for better storing and index-based search.
* Result can be shown in better way in tabular form with counts.

This project follows standard Ruby conventions
* 2-space indentation
* Frozen string literals
* Rubocop for linting
* RSpec for testing

