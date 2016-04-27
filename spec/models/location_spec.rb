# See README.md for copyright details

require 'rails_helper'

RSpec.describe Location, type: :model do
  it "should make a valid location" do
    expect(build(:location_with_layout)).to be_valid
  end

  it "should be invalid without a name" do
    expect(build(:location_with_layout, name: nil)).to_not be_valid
  end

  it "should be invalid with a blank name" do
    expect(build(:location_with_layout, name: '')).to_not be_valid
  end

  it "should be invalid without a layout" do
    expect(build(:location_with_layout, layout: nil)).to_not be_valid
  end
end
