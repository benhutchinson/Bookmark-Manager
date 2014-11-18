require 'spec_helper'

describe Link do

  context "Demonstration of how datamapper works" do 

    it 'should be created and then retrived from the db' do 

      expect(Link.count).to eq(0)
      # since at the beginning, database is empty
      # therefore, there are no links

      Link.create(:title => "Makers Academy",
                  :url => "http://www.makersacademy.com")
      # this creates it in the database

      expect(Link.count).to eq(1)

      link = Link.first
      # this helps get the first and only
      # link from the database

      expect(link.url).to eq("http://www.makersacademy.com")
      expect(link.title).to eq("Makers Academy")
      # ie. it should have all the properties
      # that it was originally saved with

      link.destroy
      # we would now have no links in the database

      expect(Link.count).to eq(0)

    end

  end
  
end