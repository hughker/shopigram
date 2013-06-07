require 'colorist'
include Colorist
 
module ColorHelper
 
  def self.removeLowContrastColors(colorPallette)
    colorArray = Array.new
    rgbArray = colorPallette.split(/,/)
    colorIndex = 0
  
    # build our color objects using rgb values from the page.
    until colorIndex >= rgbArray.length - 1 
      r = rgbArray[colorIndex].to_i
      g = rgbArray[colorIndex + 1].to_i
      b = rgbArray[colorIndex + 2].to_i
      colorArray.push Color.from_rgb(r,g,b)
      colorIndex = colorIndex + 3
    end

    # lets remove ones that are very similar in color
    colorArray.each_with_index do |color, i|
      colorArray.each_with_index do |compareColor, j|
          contrast = color.contrast_with(compareColor)
          if (contrast > 0 && contrast < 0.165)
            Rails.logger.debug('low contrast')
            colorArray.delete_at(j)
          end  
      end
    end

    return colorArray
  end

  def self.w3cHexColors(colorObjectArray)
    colorArray = Array.new
    
    colorObjectArray.each_with_index do |color, i|
        colorArray.push color.to_s
     end

    return colorArray
  end

  def self.getDarkestColor(colorObjectArray, excludeColor)
    currentDarkestColor = colorObjectArray[0]
    if (currentDarkestColor == excludeColor)
      currentDarkestColor = colorObjectArray[1]
    end

    colorObjectArray.each_with_index do |color, i|
      if (color != excludeColor && color.brightness < currentDarkestColor.brightness)
        currentDarkestColor = color
      end 
    end
     
    return currentDarkestColor
  end

  def self.getBrightestColor(colorObjectArray, excludeColor)
    currentLightestColor = colorObjectArray[0]
    if (currentLightestColor == excludeColor)
      currentLightestColor = colorObjectArray[1]
    end
    
    colorObjectArray.each_with_index do |color, i|
      if (color != excludeColor && color.brightness > currentLightestColor.brightness)
        currentLightestColor = color
      end 
    end
     
    return currentLightestColor
  end
 
end