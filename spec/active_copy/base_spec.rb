require 'spec_helper'

module ActiveCopy
  describe Base do
    let(:page) { BasicPage.new id: "about" }

    it "finds the page by its id" do
      expect(page).to be_present, "Page was not found"
    end

    it "finds the right folder to read source files from" do
      expect(page.collection_path).to eq("spec/fixtures/basic_pages/content")
    end

    it "reads the yaml front matter as a hash" do
      expect(page.title).to eq('About Us')
    end

    it "reads the article body" do
      expect(page.source).to match(/We are a very serious company/)
    end

    it "returns the correct partial path" do
      expect(page.to_partial_path).to eq("basic_pages/basic_page")
    end

    it "finds the basic_page that we just made" do
      expect(BasicPage.all.map(&:id)).to include(page.id)
    end
  end
end
