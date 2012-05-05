# == Schema Information
#
# Table name: routines
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  from        :string(255)
#  to          :string(255)
#  description :string(255)
#  days        :string(255)
#  weeks       :string(255)
#  dates       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Routine do
  pending "add some examples to (or delete) #{__FILE__}"
end
