require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Cosmos do
  it "should have proper Julian Day for the turn of the century" do
    Cosmos::JAN_1_2000.should == DateTime.civil(2000,1,1).jd
  end
  it "should have accurate approximation of radians per degree" do
    Cosmos::RADS_PER_DEG.should be_within(1.0e-13).of( 1.0 / (Math::PI / 180) )
  end
end
