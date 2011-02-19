require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cosmos::Solar do

  context "February 19, 2011 outside Boston, MA" do
    let(:off)   { 5.0/24 }
    let(:date)  { DateTime.civil(2011,2,19,0,0,0,off) }
    let(:lat)   { 42.0 }
    let(:lng)   {-71.0 }

    subject { Cosmos::Solar.new(:date => date, :lat => lat, :lng => lng) }

    its(:julian_cycle)       { should == 4067 }
    its(:mean_anomaly)       { should be_within( 1.0e-10 ).of( 45.781563540345 ) }
    its(:equation_of_center) { should be_within( 1.0e-12 ).of( 1.3925066436534 ) }
    its(:ecliptic_longitude) { should be_within( 1.0e-8  ).of( 330.111270184   ) }
    its(:declination)        { should be_within( 1.0e-11 ).of(-11.437837158942 ) }
    its(:hour_angle)         { should be_within( 1.0e-10 ).of( 80.660463866702 ) }
    its(:noon_approximation) { should be_within( 1.0e-5  ).of( DateTime.civil(2011,2,19,12,17,17,off) ) }
    its(:noon)               { should be_within( 1.0e-5  ).of( DateTime.civil(2011,2,19,12,31,21,off) ) }
    its(:set)                { should be_within( 1.0e-5  ).of( DateTime.civil(2011,2,19,17,53,59,off) ) }
    its(:rise)               { should be_within( 1.0e-5  ).of( DateTime.civil(2011,2,19, 7, 8,42,off) ) }

    # NOAA calculator http://www.srrb.noaa.gov/highlights/sunrise/sunrise.html
    let(:margin) { 2 * 0.000694444444444444 } # two min as fraction of day
    its(:noon) { should be_within( margin ).of( DateTime.civil(2011,2,19,12,29,56,off) ) }
    its(:set)  { should be_within( margin ).of( DateTime.civil(2011,2,19,17,53, 0,off) ) }
    its(:rise) { should be_within( margin ).of( DateTime.civil(2011,2,19, 7, 7, 0,off) ) }
  end


  context "June 6, 2012 outside Anchorage, AK" do
    let(:off)   { 0 } # { 9.0/24 }
    let(:date)  { DateTime.civil(2012,6,6,0,0,0,off) }
    let(:lat)   { 61 }
    let(:lng)   {-149.0 }

    subject { Cosmos::Solar.new(:date => date, :lat => lat, :lng => lng) }

    # NOAA calculator http://www.srrb.noaa.gov/highlights/sunrise/sunrise.html
    let(:margin) { 2 * 0.000694444444444444 } # two min as fraction of day
    its(:noon) { should be_within( margin ).of( DateTime.civil(2012,6,6, 2, 2,35,off) ) }
    its(:set)  { should be_within( margin ).of( DateTime.civil(2012,6,6,11,31, 0,off) ) }
    its(:rise) { should be_within( margin ).of( DateTime.civil(2012,6,5,16,36, 0,off) ) }
  end

end
