require 'spec_helper'

module ActiveCopy
  describe Base do
    let(:page) { BasicPage.new "about" }

    it "finds the page by its id" do
      page.should be_present, "Page was not found"
    end

    it "finds the right folder to read source files from" do
      BasicPage.absolute_collection_path.should =~ /\A#{Rails.root}/o
      page.collection_path.should == "spec/fixtures/basic_pages/content"
    end

    it "reads the yaml front matter as a hash" do
      page.title.should == "About Us"
    end

    it "reads the article body" do
      page.source.should =~ /We are a very serious company/
    end

    it "returns the correct partial path" do
      page.to_partial_path.should == "basic_pages/basic_page"
    end

    it "finds the basic_page that we just made" do
      BasicPage.all.map(&:id).should include(page.id)
    end
  end
end
