require 'zip/zip'
require 'zip/zipfilesystem'
require 'fileutils'

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
    path = 'Minimal'
    uniqueId = SecureRandom.urlsafe_base64
    @imageurl = params[:photoURL]
    @dominantColor = params[:dominantColor]
    @otherColors = params[:otherColors]

    #create a temporary copy of the theme
    temporaryPath = path + uniqueId
    FileUtils.mkdir_p temporaryPath
    FileUtils.cp_r(Dir[path + '/*'],temporaryPath)

    #write image to theme folder
    FileUtils.cp(Dir['public/' + @imageurl],temporaryPath + "/assets")

    #make styling changes in theme
    full_path_to_read = File.expand_path(temporaryPath + '/config/settings_data.json')
  
    File.open(full_path_to_read) { |source_file|
      contents = source_file.read

      #set the background color of the toolbar to the dominant color?
      contents.gsub!(/"toolbar_bg_color": "#000000",/, '"toolbar_bg_color": "' + @dominantColor +'",')

      
      
      File.open(full_path_to_read, "w+") { |f| f.write(contents) }
    }


    #create a publicly visible folder where the user can download the file.
    writePath = 'public/themes/' + uniqueId
    FileUtils.mkdir_p writePath
    bundle_filename = writePath + '/' + path + ".zip"
    Zipper.zip(temporaryPath, bundle_filename)
    #FileUtils.rm_r temporaryPath

    #create the link where the user can download the theme zip from
    @downloadurl = '/themes/' + uniqueId +'/' + path + '.zip'

   
    Rails.logger.debug(@imageurl)
    Rails.logger.debug(@dominantColor)
    Rails.logger.debug(@otherColors)

  end

end
