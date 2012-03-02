# == Schema Information
#
# Table name: works
#
#  id          :integer         not null, primary key
#  date        :date
#  time        :time
#  duration    :integer
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Work do
  before(:each) do
    @user = Factory(:user)
    @attr = { :date => '01/03/2012', :time => '08:30', :duration => '20', :description => "path to work" }
  end

  it "should create a new instance given valid attributes" do
    @user.works.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @work = @user.works.create(@attr)
    end

    it "should have a user attribute" do
      @work.should respond_to(:user)
    end

    it "should have the right associated user" do
      @work.user_id.should == @user.id
      @work.user.should == @user
    end
  end

  describe "validations" do
    it "should require a user id" do
      Work.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.works.build(:date=>" ", :time=>" ", :duration=>" ", :description => " ").should_not be_valid
    end
  end
end
