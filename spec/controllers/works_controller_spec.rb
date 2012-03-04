require 'spec_helper'

describe WorksController do
  render_views

  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(login_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = { :from => "", :to=>"", :duration=>"", :description => "" }
      end

      it "should not create a work" do
        lambda do
          post :create, :work => @attr
        end.should_not change(Work, :count)
      end

      it "should render the user page" do
        post :create, :work => @attr
        response.should redirect_to(user_path(@user))
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :from => "2012-03-03 08:00:00", :to=>"2012-03-03 09:10:00", :duration=>"70", :description => "path to work" }
      end

      it "should create a work" do
        lambda do
          post :create, :work => @attr
        end.should change(Work, :count).by(1)
      end

      it "should redirect to the users page" do
        post :create, :work => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        post :create, :work => @attr
        flash[:success].should =~ /activity added/i
      end
    end
  end
end