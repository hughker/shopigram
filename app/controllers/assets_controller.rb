class AssetsController < ApplicationController
  def index
  end

  def persistImage
  	someurl = URI.parse(params[:myurl])
  	Net::HTTP.start( someurl.host ) { |http|
  		resp = http.get( someurl.path )
  		publicPathToImage = 'color-thief/img/' + SecureRandom.urlsafe_base64 + '.png'
      pathToImage = 'public/' + publicPathToImage

		  open(pathToImage, 'wb' ) { |file|
    		  file.write(resp.body)
  		  }

         respond_to do |format|
          format.html { render :text => publicPathToImage }
        end
	   }
  end   

  def generateTheme
    imageurl = params[:photoURL]
    Rails.logger.debug(imageurl)

    dominantColor = params[:dominantColor]
    Rails.logger.debug(dominantColor)

    otherColors = params[:otherColors]
    Rails.logger.debug(otherColors)
  end

end
