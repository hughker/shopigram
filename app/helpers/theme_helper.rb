require 'colorist'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'fileutils'
include Colorist

module ThemeHelper
 
  def self.generateTheme(imageurl, colorArray)
    path = 'ShopigramTheme'
    uniqueId = SecureRandom.urlsafe_base64
   
    #create a temporary copy of the theme
    temporaryPath = path + uniqueId
    FileUtils.mkdir_p temporaryPath
    FileUtils.cp_r(Dir[path + '/*'],temporaryPath)

    #write image to theme folder
    FileUtils.cp(Dir['public/' + imageurl],temporaryPath + "/assets")

    #make styling changes in theme
    replaceThemeValues(temporaryPath, colorArray)

    #create a publicly visible folder where the user can download the file.
    writePath = 'public/themes/' + uniqueId
    FileUtils.mkdir_p writePath
    bundle_filename = writePath + '/' + path + ".zip"
    Zipper.zip(temporaryPath, bundle_filename)
    FileUtils.rm_r temporaryPath

    return '/themes/' + uniqueId +'/' + path + '.zip'
  end

  def self.replaceThemeValues(temporaryPath, colorArray)
    #make styling changes in theme
    full_path_to_read = File.expand_path(temporaryPath + '/config/settings_data.json')
  
    File.open(full_path_to_read) { |source_file|
      contents = source_file.read
      
      dominantColor = colorArray[0]
      dominantColorString = dominantColor.to_s
      dominantColorTextColor = dominantColor.text_color.to_s 
      Rails.logger.debug('Dominant Color: ' + dominantColorString)
      Rails.logger.debug('Dominant Color Text: ' + dominantColorTextColor)

      darkestColor = ColorHelper.getDarkestColor(colorArray,dominantColor)
      darkestColorString = darkestColor.to_s
      darkestColorTextColor = darkestColor.text_color.to_s 
      Rails.logger.debug('Darkest Color: ' + darkestColorString)
      Rails.logger.debug('Darkest Color Text: ' + darkestColorTextColor)


      brightestColor = ColorHelper.getBrightestColor(colorArray,dominantColor)
      brightestColorString = brightestColor.to_s
      brightestColorTextColor = brightestColor.text_color.to_s 
      Rails.logger.debug('Brightest Color: ' + brightestColorString)
      Rails.logger.debug('Brightest Color Text: ' + brightestColorTextColor)

      #set the background color of the toolbar to the dominant color?
      contents.gsub!(/"toolbar_bg_color":"#000000",/, '"toolbar_bg_color":"' + darkestColorString +'",')
      contents.gsub!(/"toolbar_text_color":"#000000",/, '"toolbar_text_color":"' + darkestColorTextColor +'",')
      contents.gsub!(/"toolbar_text_hover_color":"#000000",/, '"toolbar_text_hover_color":"' + brightestColorString +'",')
      contents.gsub!(/"footer_bg_color":"#000000",/, '"footer_bg_color":"' + darkestColorString +'",')
      contents.gsub!(/"footer_text_color":"#000000",/, '"footer_text_color":"' + darkestColorTextColor +'",')
      contents.gsub!(/"link_color":"#000000",/, '"link_color":"' + brightestColorString +'",')
      contents.gsub!(/"link_hover_color":"#000000",/, '"link_hover_color":"' + dominantColorString +'",')
      contents.gsub!(/"body_font_color":"#000000",/, '"body_font_color":"' + darkestColorString +'",')

      contents.gsub!(/"header_color":"#000000",/, '"header_color":"' + darkestColorString +'",')
      contents.gsub!(/"footer_link_color":"#000000",/, '"footer_link_color":"' + brightestColorString +'",')
      contents.gsub!(/"shop_btn_color":"#000000",/, '"shop_btn_color":"' + brightestColorString +'",')
      contents.gsub!(/"shop_btn_text_color":"#000000",/, '"shop_btn_text_color":"' + brightestColorTextColor +'",')        
      contents.gsub!(/"shop_btn_hover_color":"#000000",/, '"shop_btn_hover_color":"' + dominantColorString +'",')
      contents.gsub!(/"shop_btn_hover_text_color":"#000000",/, '"shop_btn_hover_text_color":"' + dominantColorTextColor +'",')        

      contents.gsub!(/"top-right-box-background":"#000000",/, '"top-right-box-background":"' + darkestColorString +'",')
      contents.gsub!(/"top-right-box-text":"#000000",/, '"top-right-box-text":"' + darkestColorTextColor +'",')
      contents.gsub!(/"bottom-right-box-background":"#000000",/, '"bottom-right-box-background":"' + brightestColorString +'",')
      contents.gsub!(/"bottom-right-box-text":"#000000",/, '"bottom-right-box-text":"' + brightestColorTextColor +'",')
      contents.gsub!(/"bottom-left-box-background":"#000000",/, '"bottom-left-box-background":"' + dominantColorString +'",')
      contents.gsub!(/"bottom-left-box-text":"#000000",/, '"bottom-left-box-text":"' + dominantColorTextColor +'",')
      contents.gsub!(/"welcome-area-background":"#000000",/, '"welcome-area-background":"' + '#CCC' +'",')
      contents.gsub!(/"welcome-area-text":"#000000",/, '"welcome-area-text":"' + '#000' +'",')
      contents.gsub!(/"header-background":"#000000",/, '"header-background":"' + dominantColorString +'",')
      contents.gsub!(/"header-background-text":"#000000",/, '"header-background-text":"' + dominantColorTextColor +'",')
      

      File.open(full_path_to_read, "w+") { |f| f.write(contents) }
    }
  end
 
end