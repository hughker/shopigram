class AssetsController < ApplicationController
  def index
  end

  def persistImage
  	someurl = URI.parse(params[:myurl])
  	
    #create unique local folder
    folderPath = 'color-thief/img/' + SecureRandom.urlsafe_base64
    FileUtils.mkdir_p 'public/' + folderPath
    
    #copy image to local folder and rename it instagram
    publicPathToImage = folderPath + "/instagram.png"
    pathToImage = 'public/' + publicPathToImage

    Net::HTTP.start( someurl.host ) { |http|
  		resp = http.get( someurl.path )
       open(pathToImage, 'wb' ) { |file|
    		  file.write(resp.body)
  		  }

        respond_to do |format|
          format.html { render :text => publicPathToImage }
        end
	   }
  end   

  def generateTheme
    #choose our theme folder and generate a unique identifier
    @imageurl = params[:photoURL]
    @otherColors = Array.new
    colorArray = ColorHelper.removeLowContrastColors(params[:otherColors])
    @otherColors = ColorHelper.w3cHexColors(colorArray)
    @downloadurl = ThemeHelper.generateTheme(@imageurl, colorArray)
  end

end
