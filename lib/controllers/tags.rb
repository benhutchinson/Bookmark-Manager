class BookmarkManager < Sinatra::Base

	get '/tags/:text' do 
		tag = Tag.first(:text => params[:text])
		# first here is a Datamapper method
		# i.e. finding the Tag that has the string defined by the text 
		# parameter in the URL
		@links = (tag ? tag.links : [])
		# so this returns an empty array if tag is nil effectively
		# i.e. if tag did not find any Tag with the text defined
		# in the parameter in the URL
		erb :index
	end

end